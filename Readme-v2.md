# GitHub Parachute Tools (Stable Release)

Specialized PowerShell tools for mirroring web assets and local folders to GitHub via unstable "Slow-Link" connections.

## 📁 Repository Contents

### 1. NirSoft Offloader (v5.5)
- **File:** `NirSoftUltimateBackup.ps1`
- **Function:** Deep-mirrors NirSoft utilities with auto-generated 3-column HTML index pages.
- **Filtering:** Blocks >4000 translation files to maintain a lean, English-only repository.

### 2. Local-to-GitHub Parachute (v3.1)
- **File:** `LocalSyncParachute.ps1`
- **Function:** Syncs any local or USB folder to GitHub while preserving directory structure.
- **Safety:** Automatically excludes `.env`, `.log`, and `.tmp` files. Blocks files > 100MB.

## 🛠 Stability Routines (Built-In)
- **Chunked Uploads:** 5-10 file batches to prevent HTTP 408/RPC Timeouts.
- **URL Fix:** Literal string concatenation to bypass PowerShell ISE truncation bugs.
- **Identity:** Automated GitHub `noreply` email generation.
- **Security:** Automated `safe.directory` whitelisting for USB/External drives.

## 🚀 Usage
1. Open your chosen script in **PowerShell ISE**.
2. Run (F5) and provide your GitHub Username and Repository Name.
3. Use your **Personal Access Token (PAT)** as the password when prompted.
