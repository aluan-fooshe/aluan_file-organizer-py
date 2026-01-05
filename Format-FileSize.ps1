function Format-FileSize {
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$FilePath
    )
    
    $SizeInBytes = $FilePath.Length
    Write-Host $SizeInBytes

    if ($SizeInBytes -ge 1TB) {
        $size = [math]::Round($SizeInBytes / 1TB, 2)
        return "$size TB"
    }
    elseif ($SizeInBytes -ge 1GB) {
        $size = [math]::Round($SizeInBytes / 1GB, 2)
        return "$size GB"
    }
    elseif ($SizeInBytes -ge 1MB) {
        $size = [math]::Round($SizeInBytes / 1MB, 2)
        return "$size MB"
    }
    elseif ($SizeInBytes -ge 1KB) {
        $size = [math]::Round($SizeInBytes / 1KB, 2)
        return "$size KB"
    }
    else {
        return "$SizeInBytes Bytes"
    }
}


# Vicky's iCloud from iPhone 15 2025-12-26