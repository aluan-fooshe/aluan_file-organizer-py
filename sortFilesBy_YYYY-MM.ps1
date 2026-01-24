$folderPath = "C:\Users\Audrey\OneDrive\Pictures\Camera Roll\takeout-20250725T035235Z-1-001"
$screenshots_dir = "$folderPath\Screenshots"


function SortByMonthAndYear{
    param(
        [string]$MAINfolderpath,
        [string]$DirNamePattern
    )
    # Create screenshots directory if it doesn't exist
    if (-not (Test-Path $screenshots_dir)) {
        #New-Item -ItemType Directory -Path $screenshots_dir -Force | Out-Null
        Write-Host "Created directory $screenshots_dir"
    }
    # go through all directories with a certain name pattern based off of year range.
    for ($year = 2021; $year -le 2025; $year++){
        for ($month = 1; $month -le 12; $month++){
            # Pad month with leading zero (01, 02, etc.)
            $monthPadded = $month.ToString("00")
        
            # Go though any directory with a certain name pattern
            $dir = "$year"

            $oldPath = "$folderPath\$dir"

            # Skip if source directory doesn't exist
            if (-not (Test-Path $oldPath)) {
                continue
            }
            # Create destination folder if it doesn't exist
            $destFolder = "$folderPath\$year-$monthPadded"
            if (-not (Test-Path $destFolder)) {
                #New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
                Write-Host "Made directory $destFolder"
            }
            # Get JSON files from the source directory
            Get-ChildItem -Path $oldPath | ForEach-Object {
                # Check if filename contains the year-month pattern
                # 
                if ($_.Name -like "*_$year$monthPadded*" -and $_.Name -match "^IMG_\d{5,}"){
                    #Move-Item -Path $_.FullName -Destination $destFolder -Force
                    Write-Host "Moved $($_.Name) to $destFolder"
                }
                if ($_.Name -like "*_$year$monthPadded*" -and $_.Name -match "^VID_\d{5,}"){
                    #Move-Item -Path $_.FullName -Destination $destFolder -Force
                    Write-Host "Moved $($_.Name) to $destFolder"
                }
                elseif ($_.Name -like "*Screenshot_*"){
                    #Move-Item -Path $_.FullName -Destination $screenshots_dir -Force
                    Write-Host "Moved $($_.Name) to $screenshots_dir"
                }
            }
        }
    }

Write-Output "Sorted directories with <$DirNamePattern> in directory <$MAINfolderpath!>"
}

# Call with parameters
SortByMonthAndYear -MAINfolderpath $folderPath -DirNamePattern "Photos from YYYY"