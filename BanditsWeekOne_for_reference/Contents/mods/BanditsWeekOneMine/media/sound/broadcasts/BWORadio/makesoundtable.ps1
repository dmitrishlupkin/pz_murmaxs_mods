# Define the root folder to scan
$RootFolder = ".\"
# Define the output file path
$OutputFile = ".\OutputFilesoundtable.lua"

# Ensure the output file is empty before starting
"" > $OutputFile

# Function to generate the desired output for each file
function Generate-Output {
    param (
        [string]$FileName
    )

    $FileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)

    return "RadioWavs.addSongs(`"$FileBaseName`",`"$FileBaseName`")"
}

# Loop over all directories and .ogg files
Get-ChildItem -Path $RootFolder -Recurse -File -Filter "*.ogg" | ForEach-Object {
    $File = $_
    $FileName = $File.Name

    # Generate output for each .ogg file
    $Output = Generate-Output -FileName $FileName

    # Append output to the file
    $Output | Out-File -Append -FilePath $OutputFile
}

Write-Host "Output has been written to $OutputFile"
