# Script parses users from file and creates according AD users. 
param (
    [Parameter(Mandatory=$true)]
    [string]$filepath
)

if ( -Not (Test-Path $filepath)) {
    Write-Error "Csv file not found"
    exit
}

$users = Import-Csv -Path $filepath

foreach ($user in $users) {

    if (Get-ADUser -Filter {SamAccontName -eq $Username}) {
        Write-User "$Username ADuser already exists."
        continue
    }

    $FirstName = $user.FirstName
    $LastName = $user.LastName
    $Username = $user.Username
    $Password = $user.Password | ConvertTo-SecureString -AsPlainText -Force
    $FullName = "$FirstName $LastName"

    try {  
        New-ADUser -Name $FullName `
                   -GivenName $FirstName `
                   -Surname $LastName `
                   -SamAccountName $Username `
                   -AccountPassword $Password `

        Write-Host "User $FullName created successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to call New-ADUser $FullName : $_"
    }
}