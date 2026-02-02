# Load GUI components
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# 1. SETUP PARAMETERS
$userIn = [Microsoft.VisualBasic.Interaction]::InputBox("Enter GitHub Username:", "Git Identity", "kindle15")
$repoIn = [Microsoft.VisualBasic.Interaction]::InputBox("Enter REPOSITORY NAME only:", "GitHub Repo Name", "Project")

if (-not $userIn -or -not $repoIn) { exit }

# LITERAL CONCATENATION: The fix for URL truncation bugs
$u = $userIn.Trim()
$r = $repoIn.Trim()
$targetURL = "https://github.com" + "/" + $u + "/" + $r + ".git"
$targetEmail = $u + "@users.noreply.github.com"

# 2. SELECT LOCAL FOLDER
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
if ($FolderBrowser.ShowDialog() -ne "OK") { exit }
$sourcePath = $FolderBrowser.SelectedPath

# 3. INITIALIZE & SECURITY BYPASS
Set-Location -Path $sourcePath
if (-not (Test-Path ".git")) { git init }
git config --global --add safe.directory "$($sourcePath.Replace('\', '/'))"

# 4. PRE-FLIGHT SCAN (Security & Junk Exclusions)
$excludePatterns = @("*\.env*", "*\.tmp*", "*\.log*", "*\desktop.ini*", "*\thumbs.db*", "*\.DS_Store*")
$allFiles = Get-ChildItem -Path $sourcePath -Recurse -Attributes !Directory+!Hidden | Where-Object {
    $file = $_
    $isExcluded = $false
    foreach ($pattern in $excludePatterns) {
        if ($file.FullName -like $pattern) { $isExcluded = $true; break }
    }
    ($isExcluded -eq $false) -and ($file.FullName -notlike "*\.git\*")
}

# 5. STABILITY SETTINGS
git config user.name "$u"; git config user.email "$targetEmail"
git config http.postBuffer 524288000; git config http.version HTTP/1.1
git config http.lowSpeedLimit 0; git config http.lowSpeedTime 3600

# 6. DIRECT URL PUSH (Using Start-Process for URL stability)
Write-Host "--- MISSION START ---" -ForegroundColor Green
Write-Host "Targeting: $targetURL" -ForegroundColor Cyan

git checkout -b main 2>$null
git add README.md 2>$null
git commit -m "Direct Sync" 2>&1 | Out-Null

$gitArgs = @("push", "$targetURL", "main", "--force")
Start-Process -FilePath "git.exe" -ArgumentList $gitArgs -Wait -NoNewWindow

# Chunked Batches (5 files at a time for slow-link stability)
$chunkSize = 5
for ($i = 0; $i -lt $allFiles.Count; $i += $chunkSize) {
    $batch = $allFiles[$i..([Math]::Min($i + $chunkSize - 1, $allFiles.Count - 1))]
    foreach ($f in $batch) { git add $f.FullName 2>&1 | Out-Null }
    git commit -m "Batch sync $([Math]::Floor($i/5) + 1)" 2>&1 | Out-Null
    
    Write-Host "Pushing batch $([Math]::Floor($i/5) + 1)..." -ForegroundColor Gray
    $batchArgs = @("push", "$targetURL", "main")
    Start-Process -FilePath "git.exe" -ArgumentList $batchArgs -Wait -NoNewWindow
}

# 7. REVERTED COMPLETION POPUP (Original Stable Logic)
Write-Host "`n--- MISSION COMPLETE ---" -ForegroundColor Green

$msgBody = "Sync Finished!`nFiles: $($allFiles.Count)`nRepo: $targetURL"
[System.Windows.Forms.MessageBox]::Show($msgBody, "Sync Successful")
