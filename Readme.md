# GitHub Parachute Tools

A collection of specialized PowerShell scripts designed to mirror websites and local folders to GitHub, optimized for **slow/unstable internet connections**.

## 🛠 Included Scripts

### 1. NirSoft Offloader (`NirSoftUltimateBackup.ps1`)
**Purpose:** Automates the mirroring of the NirSoft utility collection.
- **Organization:** Sorts into Zips, EXEs, and x64 categories.
- **Directories:** Generates 3-column HTML index files with scraped descriptions.
- **Filtering:** Pure English tools only (removes thousands of translation files).

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


⚖️ License
This project is for personal backup and educational purposes. Ensure compliance with NirSoft's redistribution policies when hosting public mirrors.