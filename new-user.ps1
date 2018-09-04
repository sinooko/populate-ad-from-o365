# Quickly populate a new DC with users from office365 export csv file.

function Write-Log($String){
    $LogDir = "$PWD\Logs"
    $Date = Get-Date -UFormat "%Y%m%d"
    $Time = Get-Date -Format "HH:mm:ss"


    # If logs directory does not exist, create it,
    if(!(Test-Path -Path $LogDir )){
        Write-Host ""
        Write-Host "Log folder does not exist, creating $LogDir"
        New-Item -ItemType directory -Path $LogDir
    }

    # If log file for today does not exist, create it
    if(!(Test-Path -Path "$LogDir\$Date.txt" )){
        Write-Host ""
        Write-Host "Log file for today does not yet exist, creating $LogDir\$Date.txt"
        New-Item -ItemType file -Path "$LogDir\$Date.txt"
    }

    # Write string to log
    Write-Host $String
    Add-Content "$LogDir\$Date.txt" "$Date $Time $String"
}

function New-User($user)
{
    Write-Log("User: $($User.First) $($User.Last) started...")
    $Attributes = @{

        Enabled = $true
        ChangePasswordAtLogon = $true
        # Change this OU and DC info
        Path = "OU=Example Group,DC=Example Domain Name,DC=local/com/whatever"

        Name = "$($User.First) $($User.Last)"
        # Change the domain at the end of this line
        UserPrincipalName = "$($User.First).$($User.Last)@example.local"
        SamAccountName = "$($User.First).$($User.Last)"

        GivenName = $User.First
        Surname = $User.Last
        # Probably want to change the password as well...
        AccountPassword = "Passw0rd!" | ConvertTo-SecureString -AsPlainText -Force

     }

     Write-Log($Attributes | Out-String)
     New-ADUser @Attributes
}

$UserList = Import-Csv -Path "$PWD\users.csv"
Write-Host("$PWD\users.csv")

foreach ($User in $UserList) { New-User($User) }

Write-Host("You have 10 minutes to read the red text...")
Timeout 600
