# Set the folder path (current folder in this example)
# $folderPath = "C:\Users\Audrey\OneDrive\Pictures\Camera Roll\takeout-20250725T035235Z-1-001\Deep cleaning and room makeover\VID_20200407_110729254.mp4"

$jsonNameEnding = "supplemental-metadata.json"
$brokenfilename = @()
$pos_names = ""

foreach ($char in $jsonNameEnding.ToCharArray()) {
    $pos_names += $char
    $brokenfilename += $pos_names
}

$brokenfilename

# for ($year = 2021; $year -le 2025; $year++){
$folderPath = "C:\Users\Audrey\OneDrive\Pictures\Camera Roll\takeout-20250725T035235Z-1-001"

foreach ($name in $brokenfilename){
# Write-Host "[$name]"

Get-ChildItem $folderPath -Recurse -File |
Where-Object { $_.Name -like "*.$name.json*" } |
ForEach-Object { 
    # Write-Host "$($_.Name)"

        if (-not $_.Name.EndsWith("supplemental-metadata.json")){
            $newName = $_.Name -replace "\.$name\.json", ".supplemental-metadata.json"
            Write-Host "$($_.Name) will be renamed as $newName"
            Rename-Item $_.FullName -NewName $newName
        }
        else{
            # "$($_.Name) remains the same."
        }

    }
}
# }

