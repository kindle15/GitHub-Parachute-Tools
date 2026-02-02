# GitHub Parachute Tools

A collection of specialized PowerShell scripts designed to mirror websites and local folders to GitHub, optimized for **slow/unstable internet connections**.

## 🛠 Included Scripts

### 1. NirSoft Offloader (`NirSoftUltimateBackup.ps1`)
**Purpose:** Automates the mirroring of the NirSoft utility collection.
- **Organization:** Sorts into Zips, EXEs, and x64 categories.
- **Directories:** Generates 3-column HTML index files with scraped descriptions.
- **Filtering:** Pure English tools only (removes thousands of translation files).

⚖️ License
This project is for personal backup and educational purposes. Ensure compliance with NirSoft's redistribution policies when hosting public mirrors.

### 2. Local-to-GitHub Parachute (`LocalSyncParachute.ps1`)
**Purpose:** Mirrors any local folder or USB drive directly to a new GitHub repo.
- **Slow-Link Optimized:** Uses tiny 5-file batches to prevent connection drops.
- **Safety First:** Blocks files > 100MB and excludes sensitive `.env` or `.log` files.
- **Identity:** Auto-configures Git identity locally for the specific folder.

## 🚀 Getting Started

### Prerequisites
1. **Wget2:** Required for the NirSoft script. Install via:  
   `winget install GNU.Wget2`
2. **Git:** Required for both scripts. Ensure it is in your system PATH.
3. **GitHub Token:** Have your Personal Access Token (PAT) ready for the first upload.

### Installation
1. Clone this repository:
   `git clone https://github.com`
2. Open the desired script in **PowerShell ISE**.
3. Run the script and follow the on-screen prompts for your GitHub Username and Repo Name.

## 📁 Repository Structure
```text
├── NirSoftUltimateBackup.ps1   # Web-to-GitHub script
├── LocalSyncParachute.ps1      # Local-to-GitHub script
└── README.md                   # This file


# GitHub Parachute Tools (Stable Release)

Specialized PowerShell tools for mirroring web assets and local folders to GitHub via unstable "Slow-Link" connections.

## 📁 Repository Contents

### 1. NirSoft Offloader (v5.5)
- **File:** `NirSoftUltimateBackup.ps1`
- **Function:** Deep-mirrors NirSoft utilities with auto-generated 3-column HTML index pages.
- **Filtering:** Blocks >4000 translation files to maintain a lean, English-only repository.

⚖️ License
This project is for personal backup and educational purposes. Ensure compliance with NirSoft's redistribution policies when hosting public mirrors.


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
