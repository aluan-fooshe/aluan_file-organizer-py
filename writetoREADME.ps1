
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
        $origNum = $FilePath.Name.Substring(4, $index-4)
    }

    # Generate the appropriate standard name based on these conditions; 
    # iPhone17 pro or not
    # OTHER file
    # index is equal to -1
    if ($extension -eq ".md"){
        $StandardName = $FilePath.Name.Substring(0, $index) + "_" + "$YYYY$Month$DD" + $extension
    }
    elseif ($label -eq "OTHER") {
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
        [System.IO.FileInfo]$FilePath
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

#------------main()-------------------

$directoryPath = "C:\Users\Audrey\OneDrive\Desktop\Audrey_photos_bkup\.1 MEIMEI HELP TAKEOUT" 

ListContents $directoryPath | Sort-Object DateCreated | Format-Table -AutoSize



# test code for formatting the table to a README.md file

# declare output file path
$outputMd = "$directoryPath\README.md"

# Write title and directory path to README
"# README" | Out-File $outputMd # erases everything in README without command "-Append"
"## Files in $directoryPath`n" | Out-File $outputMd -Append
"**Last Updated:** $(Get-Date)`n" | Out-File $outputMd -Append

Write-Host (Get-Location)
Write-Host $directoryPath

"| File | StandardName | Size (MB) | DateCreated | DateModified | DateAccessed | " | Out-File $outputMd -Append
"|------|--------------|----------:|-------------|--------------|--------------|" | Out-File $outputMd -Append

Get-ChildItem -Path $directoryPath | Sort-Object -Property Name | ForEach-Object {
    "| $($_.Name) | $(RenameFileToTimestamp $_.FullName) | $([math]::Round($_.Length / 1MB, 2)) MB | $($_.CreationTime.ToString("yyyy/MM/dd hh:mm tt")) | $($_.LastWriteTime.ToString("yyyy/MM/dd hh:mm tt")) | $($_.LastAccessTime.ToString("yyyy/MM/dd hh:mm tt")) |" |
        Out-File $outputMd -Append

    # Write-Host $($_.Name)
}

# test code for function RenameFileToTimestamp
# Write-Host (RenameFileToTimestamp "D:\Audrey's Stuff\iPhone17Pro_bkup\VID_20251225_Christmas\IMG_0052.MOV")