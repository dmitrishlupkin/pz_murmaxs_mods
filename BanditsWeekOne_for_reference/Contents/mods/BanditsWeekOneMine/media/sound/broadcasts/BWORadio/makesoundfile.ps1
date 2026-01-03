# Define the root folder to scan
$RootFolder = ".\"
# Define the output file path
$OutputFile = ".\OutputFile.txt"

# Ensure the output file is empty before starting
"" > $OutputFile

# Function to generate the desired output for each file
function Generate-Output {
    param (
        [string]$Directory,
        [string]$FileName,
        [string]$FilePath
    )

    $FileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $DirectoryName = [System.IO.Path]::GetFileName($Directory)

    return @"
    sound $FileBaseName {
        category = Object, 
        clip { 
            file = media/sound/Broadcasts/BWORadio/$DirectoryName/$FileBaseName.ogg, 
            distanceMin = 5, distanceMax = 50, reverbMaxRange = 10, reverbFactor = 0.1, 
        } 
    }
"@
}

# Loop over all directories and files
Get-ChildItem -Path $RootFolder -Recurse -File -Filter "*.ogg" | ForEach-Object {
    $File = $_
    $Directory = $File.DirectoryName
    $FileName = $File.Name

    # Generate output for each file
    $Output = Generate-Output -Directory $Directory -FileName $FileName -FilePath $File.FullName

    # Append output to the file
    $Output | Out-File -Append -FilePath $OutputFile
}

Write-Host "Output has been written to $OutputFile"