$directory = ".\"

# Change to the target directory
Set-Location -Path $directory

# Get all files in the directory matching the pattern 001.png to 060.png
Get-ChildItem -Filter "0??.png" | Sort-Object Name | ForEach-Object {
    # Extract the numeric part of the file name
    $fileNumber = [int]($_.BaseName)

    # Format the new file name
    $newFileName = "mist_01_$($fileNumber - 1).png"

    # Rename the file
    Rename-Item -Path $_.FullName -NewName $newFileName
}
