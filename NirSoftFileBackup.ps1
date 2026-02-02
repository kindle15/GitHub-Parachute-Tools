#v5.4f
# Load GUI for user input
Add-Type -AssemblyName Microsoft.VisualBasic

# 1. SETUP PARAMETERS
$repoURL = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your GitHub Repo URL:", "Clean NirSoft Backup", "https://github.com")
$gitUser = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your GitHub Username:", "Git Identity")
$gitEmail = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your GitHub Email:", "Git Identity")

if (-not $repoURL -or -not $gitUser) { Write-Host "Required info missing. Exiting..."; exit }

# Force TLS 1.2 for modern web compatibility
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$baseDirName = "NirSoft_Structured_Backup"
$tempDirName = "temp_dl"

# --- CLEAN START BLOCK ---
if (!(Test-Path $baseDirName)) { 
    New-Item -ItemType Directory -Path $baseDirName 
} else {
    Write-Host "--- Performing Clean Start (Clearing local folder) ---" -ForegroundColor Yellow
    # Deletes all files and folders inside EXCEPT the .git folder to preserve history
    Get-ChildItem -Path $baseDirName -Exclude ".git" | Remove-Item -Recurse -Force
}

Set-Location -Path $baseDirName

$zipPath = "zips"; $exePath = "exes"; $x64Path = "x64zips"; $tempPath = $tempDirName
New-Item -ItemType Directory -Force -Path $zipPath, $exePath, $x64Path, $tempPath | Out-Null

# 2. IMPROVED SCRAPE
Write-Host "--- Scraping Utility Descriptions ---" -ForegroundColor Cyan
$descTable = @{}
try {
    $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    $html = Invoke-WebRequest -Uri "https://launcher.nirsoft.net" -UserAgent $userAgent -UseBasicParsing
    
    $regexPattern = '(?s)<tr>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?</tr>'
    $regexMatches = [regex]::Matches($html.Content, $regexPattern)
    
    foreach ($m in $regexMatches) {
        $name = $m.Groups[1].Value.Trim().ToLower()
        $desc = $m.Groups[2].Value.Trim()
        if ($name) { $descTable[$name] = $desc }
    }
    Write-Host "Successfully scraped $($descTable.Count) descriptions." -ForegroundColor Green
} catch {
    Write-Host "Scrape failed: $($_.Exception.Message). Using placeholders." -ForegroundColor Red
}

# 3. DOWNLOAD TOOLS (Wget2)
Write-Host "--- Downloading NirSoft Tools ---" -ForegroundColor Yellow
wget2.exe --mirror -H -np -nd `
    --domains="www.nirsoft.net,launcher.nirsoft.net" `
    --accept="zip,exe" --reject-regex "\.html|\.php|\.asp|_lng" `
    -X "/languages/,/trans/,/utils/trans/" `
    --max-threads=10 -P "$tempPath" "https://www.nirsoft.net"

# 4. SORTING & PURGE
Write-Host "--- Sorting Files & Purging Translations ---" -ForegroundColor Cyan
$downloadedFiles = Get-ChildItem "$tempPath" -File
foreach ($file in $downloadedFiles) {
    $name = $file.Name
    if ($name -like "*x64*") { Move-Item $file.FullName "$x64Path\$name" -Force }
    elseif ($name -match "_") { Remove-Item $file.FullName -Force }
    elseif ($file.Extension -eq ".zip") { Move-Item $file.FullName "$zipPath\$name" -Force }
    elseif ($file.Extension -eq ".exe") { Move-Item $file.FullName "$exePath\$name" -Force }
}
if (Test-Path $tempPath) { Remove-Item $tempPath -Recurse -Force }

# 5. GENERATE 3-COLUMN HTML LISTINGS
function Create-Index($targetDir, $htmlFileName, $title) {
    $files = Get-ChildItem $targetDir -File
    $folderName = Split-Path $targetDir -Leaf
    $htmlContent = "<html><head><style>
        body{font-family:Segoe UI,Tahoma,sans-serif;padding:30px;background:#f4f4f9;}
        h1{color:#2c3e50; border-bottom: 2px solid #2c3e50; padding-bottom: 10px;}
        .grid{display:grid;grid-template-columns: 200px auto 120px;gap:15px;border-bottom:1px solid #ddd;padding:12px;background:white;}
        .header{font-weight:bold;background:#2c3e50;color:white;}
        .desc{font-size: 0.85em; color: #555; line-height:1.5;}
        a{color:#3498db;text-decoration:none;font-weight:bold;}
        a:hover{text-decoration:underline;}
    </style></head><body><h1>$title</h1><div class='grid header'><div>File Name</div><div>Description</div><div>Action</div></div>"
    
    foreach ($f in $files) {
        $cleanName = $f.BaseName.Replace("x64", "").ToLower()
        $description = if ($descTable.ContainsKey($cleanName)) { $descTable[$cleanName] } else { "Official NirSoft English Utility" }
        $htmlContent += "<div class='grid'><div>$($f.Name)</div><div class='desc'>$description</div><div><a href='./$folderName/$($f.Name)'>Download</a></div></div>"
    }
    Set-Content -Path $htmlFileName -Value ($htmlContent + "</body></html>") -Encoding UTF8
}

Write-Host "--- Generating Structured HTML ---" -ForegroundColor Magenta
Create-Index $zipPath "zips.html" "Standard ZIP Utilities"
Create-Index $exePath "exes.html" "Standalone EXEs"
Create-Index $x64Path "x64zips.html" "64-Bit ZIP Utilities"

# 6. GITHUB SYNC (CLEAN OUTPUT)
Write-Host "--- Pushing to GitHub (Batch Mode) ---" -ForegroundColor Green
if (-not (Test-Path ".git")) { git init; git remote add origin $repoURL; git branch -M main }
git config user.name "$gitUser"
git config user.email "$gitEmail"
git config http.postBuffer 524288000

$allFiles = Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notlike "*\.git*" }
$chunkSize = 10
for ($i = 0; $i -lt $allFiles.Count; $i += $chunkSize) {
    $batch = $allFiles[$i..([Math]::Min($i + $chunkSize - 1, $allFiles.Count - 1))]
    foreach ($f in $batch) { git add $f.FullName }
    
    git commit -m "Batch upload $([Math]::Floor($i/10) + 1)" 2>&1 | Out-Null
    Write-Host "Pushing batch $([Math]::Floor($i/10) + 1)..." -ForegroundColor Gray
    
    # Redirecting Git's status stream to prevent red false-positive errors
    git push origin main 2>&1
}

Write-Host "--- MISSION COMPLETE ---" -ForegroundColor Green
pause
