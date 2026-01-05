# Set the folder path (current folder in this example)
$folderPath = "C:\Users\Audrey\Desktop-LUAN_LGGRAM-2024\takeout-20250808T041526Z-1-001\Photos from 2022"

# Define output txt file path
$outputFile = "$folderPath\README.md"

# --------------------------------------------
# Get all non-JSON files in the folder
$nonJsonFiles = Get-ChildItem -Path $folderPath -File | Where-Object { $_.Extension -ne ".json" }

# Counter for total files matched with its .json counterpart.
$matchedFiles = 0

# Write title and directory path to README
"# README" | Out-File $outputMd # erases everything in README without command "-Append"
"## Files in $directoryPath`n" | Out-File $outputMd -Append
"**Last Updated:** $(Get-Date)`n" | Out-File $outputMd -Append

Write-Host "Current Location: $(Get-Location)"
Write-Host "Directory Path: $folderPath"

"| File | .json pair? |" | Out-File $outputMd -Append
"|------|-------------|" | Out-File $outputMd -Append

foreach ($file in $nonJsonFiles) {

    # Construct the expected JSON file name
    $jsonFileName = "$($file).supplemental-metadata.json"
    
    # Check if the JSON file exists in the same folder
    $jsonFilePath = Join-Path -Path $folderPath -ChildPath $jsonFileName

    if (Test-Path $jsonFilePath) {
        Write-Host "Match found: $($file.Name) has corresponding JSON: $jsonFileName"
        # Overwrite output txt file with content
        "| $($file.Name) | $jsonFileName |" | Out-File $outputMd -Append

        $matchedFiles++
    } 
    elseif ($file.Name -eq "README.md") {
        Write-Host "--------------- a README.md exists in this directory ---------------"
        # continue
    }
    else {
        Write-Host "No JSON match for: $($file.Name)`n`t`t`t`t   $jsonFileName."
        # Overwrite output txt file with content
        "| $($file.Name) | ------------- |" | Out-File $outputMd -Append
    }
}
# needs to account for these edge cases;
# No JSON match for: Screenshot_299.png
#				     Screenshot_299.PNG.supplem
#
# No JSON match for: Screenshot_299.jpg
#				     Screenshot_299.JPG.supplemental-metada

# Optional: Output Summary
$totalFiles = $nonJsonFiles.Count
Write-Host "`nSummary: $matchedFiles out of $totalFiles non-JSON files have a corresponding JSON file."
"`nSummary: $matchedFiles out of $totalFiles non-JSON files have a corresponding JSON file." | Out-File $outputMd -Append

# --------------------------------------------
# Get the current date and time
$currentDate = Get-Date

# Format the date
$formattedDate = $currentDate.ToString("dddd MMMM dd, yyyy hh:mmtt")
Write-Host "Script completed at: $formattedDate"
