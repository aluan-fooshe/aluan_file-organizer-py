function Repair-JsonFileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$FolderPath
    )

    if (-not (Test-Path -Path $FolderPath)) {
        throw "Path not found: $FolderPath"
    }

    $jsonNameEnding = "supplemental-metadata.json"
    $brokenfilename = @()
    $pos_names = ""

    foreach ($char in $jsonNameEnding.ToCharArray()) {
        $pos_names += $char
        $brokenfilename += $pos_names
    }

    foreach ($name in $brokenfilename) {
        Get-ChildItem -Path $FolderPath -Recurse -File |
            Where-Object { $_.Name -like "*.$name.json*" } |
            ForEach-Object {
                if (-not $_.Name.EndsWith("supplemental-metadata.json")) {
                    $newName = $_.Name -replace "\.$name\.json", ".supplemental-metadata.json"
                    Write-Host "$($_.Name) will be renamed as $newName"
                    Rename-Item -Path $_.FullName -NewName $newName
                }
            }
    }
}

# Example: pass any folder (or file) path as an argument when running the script
# .\fix_json_file_name.ps1 "C:\Users\Audrey\OneDrive\Pictures\Camera Roll\takeout-20250725T035235Z-1-001"
if ($args.Count -gt 0) {
    Repair-JsonFileName -FolderPath $args[0]
}

