$folderPath = "C:\Users\Audrey\OneDrive\Desktop\Audrey_photos_bkup\Takeout"

function SortByMonthAndYear_subDir {
    param(
        [string]$MAINfolderpath,
        [string]$DirNamePattern,
        [int]$StartYear,
        [int]$EndYear,
        [switch]$DryRun
    )

    $screenshotsDir = "$MAINfolderpath\Screenshots"

    if (-not (Test-Path $screenshotsDir)) {
        if ($DryRun) {
            Write-Host "[DryRun] Would create directory: $screenshotsDir"
        } else {
            New-Item -ItemType Directory -Path $screenshotsDir -Force | Out-Null
            Write-Host "Created directory: $screenshotsDir"
        }
    }

    for ($year = $StartYear; $year -le $EndYear; $year++) {
        for ($month = 1; $month -le 12; $month++) {
            $monthPadded = $month.ToString("00")
            $oldPath = "$MAINfolderpath\$year"

            if (-not (Test-Path $oldPath)) { continue }

            $destFolder = "$MAINfolderpath\$year-$monthPadded"

            if (-not (Test-Path $destFolder)) {
                if ($DryRun) {
                    Write-Host "[DryRun] Would create directory: $destFolder"
                } else {
                    New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
                }
            }

            Get-ChildItem -Path $oldPath | ForEach-Object {
                $isMediaFile = ($_.Name -like "*_$year$monthPadded*") -and
                               ($_.Name -match "^(IMG|VID)_\d{5,}")

                if ($isMediaFile) {
                    if ($DryRun) {
                        Write-Host "[DryRun] Would move $($_.Name) -> $destFolder"
                    } else {
                        Move-Item -Path $_.FullName -Destination $destFolder -Force
                        Write-Host "Moved $($_.Name) -> $destFolder"
                    }
                }

                # Separate check — not elseif — so IMG_ files are also evaluated
                if ($_.Name -like "*Screenshot_*") {
                    if ($DryRun) {
                        Write-Host "[DryRun] Would move $($_.Name) -> $screenshotsDir"
                    } else {
                        Move-Item -Path $_.FullName -Destination $screenshotsDir -Force
                        Write-Host "Moved $($_.Name) -> $screenshotsDir"
                    }
                }
            }
        }
    }

    Write-Output "Sorted directories matching <$DirNamePattern> in <$MAINfolderpath>"
}

function SortByMonthAndYear_oneDir {
    param(
        [string]$MAINfolderpath,
        [int]$StartYear,
        [int]$EndYear,
        [switch]$DryRun
    )

    $screenshotsDir = "$MAINfolderpath\Screenshots"

    if (-not (Test-Path $screenshotsDir)) {
        if ($DryRun) {
            Write-Host "[DryRun] Would create directory: $screenshotsDir"
        } else {
            New-Item -ItemType Directory -Path $screenshotsDir -Force | Out-Null
            Write-Host "Created directory: $screenshotsDir"
        }
    }

    for ($year = $StartYear; $year -le $EndYear; $year++) {
        for ($month = 1; $month -le 12; $month++) {
            $monthPadded = $month.ToString("00")
            # $oldPath = "$MAINfolderpath\$year"

            if (-not (Test-Path $MAINfolderpath)) { continue }

            $destFolder = "$MAINfolderpath\$year-$monthPadded"

            if (-not (Test-Path $destFolder)) {
                if ($DryRun) {
                    Write-Host "[DryRun] Would create directory: $destFolder"
                } else {
                    New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
                }
            }

            Get-ChildItem -Path $MAINfolderpath | ForEach-Object {
                $isMediaFile = ($_.Name -like "*_$year$monthPadded*") -and
                               ($_.Name -match "^(IMG|VID)_\d{5,}")

                if ($isMediaFile) {
                    if ($DryRun) {
                        Write-Host "[DryRun] Would move $($_.Name) -> $destFolder"
                    } else {
                        Move-Item -Path $_.FullName -Destination $destFolder -Force
                        Write-Host "Moved $($_.Name) -> $destFolder"
                    }
                }

                # Separate check — not elseif — so IMG_ files are also evaluated
                if ($_.Name -like "*Screenshot_*") {
                    if ($DryRun) {
                        Write-Host "[DryRun] Would move $($_.Name) -> $screenshotsDir"
                    } else {
                        Move-Item -Path $_.FullName -Destination $screenshotsDir -Force
                        Write-Host "Moved $($_.Name) -> $screenshotsDir"
                    }
                }
            }
        }
    }

    Write-Output "Sorted directories in <$MAINfolderpath>"
}

# Dry run first to preview what will move
SortByMonthAndYear_subDir -MAINfolderpath $folderPath -DryRun

# Then run for real:
# SortByMonthAndYear -MAINfolderpath $folderPath