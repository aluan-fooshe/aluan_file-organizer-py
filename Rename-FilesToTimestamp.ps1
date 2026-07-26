
function RenameFileToTimestamp {
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$FilePath
    )
     
    # Get the last separator for file extension name. $index returns an integer. Example: 8
    $index = $FilePath.Name.LastIndexOf(".")

    # Get the proper label based on filetype
    if ($index -eq -1) {
        $extension = "---"
        $label = "NO_EXT"  # You'll need to set a label for files without extensions
    }
    else{
        $extension = $FilePath.Name.Substring($index)

        switch ($extension) {
            ""      { $label = "" }
            ".jpg"  { $label = "IMG" }
            ".jpeg" { $label = "IMG" }
            ".png"  { $label = "IMG" }
            ".mp4"  { $label = "VID" }
            ".mp3"  { $label = "VID" }
            ".mov"  { $label = "MOV" }
            ".heic"  { $label = "IMG" }
            default { $label = "OTHER" }
        }
    }

    # break down CreationTime to its components: year, month, day
    $date = $FilePath.LastWriteTime
    $YYYY = "{0:D4}" -f $date.Year 
    $Month = "{0:D2}" -f $date.Month
    $DD = "{0:D2}" -f $date.Day
    $HH = "{0:D2}" -f $date.Hour    # 00–23
    $mm = "{0:D2}" -f $date.Minute  # 00–59
    $ss = "{0:D2}" -f $date.Second  # 00–59

    # Get the proper label based on filetype
    if ($index -eq -1){
        # usually a directory
        $extension = ""
        $origNum = ""
    }
    else{
        $extension = $FilePath.Name.Substring($index)
        # $origNum = $FilePath.Name.Substring(4, $index-4)
    }

    # Generate the appropriate standard name based on these conditions; 
    # iPhone17 pro or not
    # OTHER file
    # index is equal to -1
    if ($label -eq "OTHER") {
        $StandardName = "---"
    }
    else{
        #$StandardName =  $label + "_" + "$YYYY$Month$DD" + "_" + "$HH$mm$ss" + "_" + "IP17p$origNum"
        $StandardName =  $label + "_" + "$YYYY$Month$DD" + "_" + "$HH$mm$ss" +  $extension
    }
    return $StandardName
}



function ListContents {
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$DirectoryPath
    )

    Get-ChildItem $DirectoryPath -File | ForEach-Object {

    # Get the file size of each object in MB.
    $size = [math]::Round($_.Length / 1MB, 2)
    $StandardName = (RenameFileToTimestamp $DirectoryPath/$_)

    # Write-Host "it is $StandardName"
    
    [PSCustomObject]@{
        OriginalName = $_.Name.PadRight(15)
        StandardName = $StandardName.PadRight(30)
        SizeMB = $("$size MB").PadRight(10)
        DateCreated = $_.CreationTime.ToString("yyyy/MM/dd hh:mm tt").PadRight(25)
        DateModified = $_.LastWriteTime.ToString("yyyy/MM/dd hh:mm tt").PadRight(25)
        DateAccessed = $_.LastAccessTime.ToString("yyyy/MM/dd hh:mm tt")
        }

    }
}


function Rename-FileSafely {
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File,
        [Parameter(Mandatory)]
        [string]$NewName,
        [switch]$WhatIfMode
    )

    $targetPath = Join-Path $File.DirectoryName $NewName
    $finalName = $NewName

    if ((Test-Path $targetPath) -and ($File.FullName -ne $targetPath)) {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($NewName)
        $ext  = [System.IO.Path]::GetExtension($NewName)
        $counter = 1
        do {
            $finalName = "${base}_$($counter.ToString('000'))$ext"
            $targetPath = Join-Path $File.DirectoryName $finalName
            $counter++
        } while (Test-Path $targetPath)
    }

    if ($File.Name -eq $finalName) {
        return  # nothing to do
    }

    Rename-Item -LiteralPath $File.FullName -NewName $finalName -WhatIf:$WhatIfMode
    Write-Host "$($File.Name)  ->  $finalName"
}


function Rename-Files-and-add-README {
    param (
        [switch]$WhatIfMode,
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo]$DirectoryPath
    )

    ListContents $directoryPath | Sort-Object DateCreated | Format-Table -AutoSize

    $outputMd = "$directoryPath\README.md"
    "# README" | Out-File $outputMd
    "## Files in $directoryPath`n" | Out-File $outputMd -Append
    "**Last Updated:** $(Get-Date)`n" | Out-File $outputMd -Append
    Write-Host (Get-Location)
    Write-Host $directoryPath
    "| File | StandardName | Size (MB) | DateCreated | DateModified | DateAccessed | " | Out-File $outputMd -Append
    "|------|--------------|----------:|-------------|--------------|--------------|" | Out-File $outputMd -Append

    Get-ChildItem -Path $directoryPath -File | Sort-Object -Property Name | ForEach-Object {
        $newName = RenameFileToTimestamp $_.FullName
        "| $($_.Name) | $($newName) | $([math]::Round($_.Length / 1MB, 2)) MB | $($_.CreationTime.ToString("yyyy/MM/dd hh:mm tt")) | $($_.LastWriteTime.ToString("yyyy/MM/dd hh:mm tt")) | $($_.LastAccessTime.ToString("yyyy/MM/dd hh:mm tt")) |" |
            Out-File $outputMd -Append

        if ($newName -ne "---") {
            Rename-FileSafely -File $_ -NewName $newName -WhatIfMode:$WhatIfMode
        }
    }
}


#------------HOW TO RUN in windows powershell terminal-------------------

#.\script.ps1          # RUNS the script — functions are defined, then discarded when it finishes
#. .\script.ps1        # DOT-SOURCES the script — functions stay loaded in your current session

#.\script.ps1
# Get-Command {chosen-function}
# {chosen-function} {parameters} -WhatIfMode