$month = 08
$year = "2025"

$dir = "C:\Users\Audrey\OneDrive\Desktop\Audrey_photos_bkup\Takeout\Photos from $year"

for ($month = 1; $month -le 12; $month++) {
    $monthPadded = $month.ToString("00")  # Converts 1 -> "01", 2 -> "02", etc.
    $destination = "C:\Users\Audrey\OneDrive\Desktop\$year-$monthPadded"
    
    if (!(Test-Path $destination)) { 
        New-Item -Path $destination -ItemType Directory 
    }
    
    Get-ChildItem -Path $dir -Filter "*_$year$monthPadded*" | Move-Item -Destination $destination
}