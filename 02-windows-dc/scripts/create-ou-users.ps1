# Requires: Run as Domain Admin on DC01
Import-Module ActiveDirectory

$root = "DC=mylab,DC=local"

# Create OU structure
New-ADOrganizationalUnit -Name "Lab" -Path $root -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
New-ADOrganizationalUnit -Name "Windows" -Path "OU=Lab,$root" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
New-ADOrganizationalUnit -Name "Linux" -Path "OU=Lab,$root" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
New-ADOrganizationalUnit -Name "Users" -Path "OU=Lab,$root" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
New-ADOrganizationalUnit -Name "Groups" -Path "OU=Lab,$root" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue

# Create groups
New-ADGroup -Name "Linux_Admins" -GroupScope Global -Path "OU=Groups,OU=Lab,$root" -Description "Admins on Linux hosts" -ErrorAction SilentlyContinue
New-ADGroup -Name "Windows_Admins" -GroupScope Global -Path "OU=Groups,OU=Lab,$root" -Description "Admins on Windows hosts" -ErrorAction SilentlyContinue

# Create sample users
$users = @(
  @{GivenName="Alice"; Surname="Admin"; SamAccountName="alice.admin"; Password="P@ssw0rd123!"},
  @{GivenName="Bob";   Surname="User";  SamAccountName="bob.user";   Password="P@ssw0rd123!"}
)

foreach ($u in $users) {
  $secure = ConvertTo-SecureString $u.Password -AsPlainText -Force
  $upn = "$($u.SamAccountName)@mylab.local"
  if (-not (Get-ADUser -Filter "SamAccountName -eq '$($u.SamAccountName)'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "$($u.GivenName) $($u.Surname)" `
      -GivenName $u.GivenName -Surname $u.Surname `
      -SamAccountName $u.SamAccountName -UserPrincipalName $upn `
      -Path "OU=Users,OU=Lab,$root" `
      -AccountPassword $secure -Enabled $true -ChangePasswordAtLogon $false
  }
}

# Add Alice to Linux_Admins
Add-ADGroupMember -Identity "Linux_Admins" -Members "alice.admin" -ErrorAction SilentlyContinue
