#ps1_sysnative

# Variables
$user='${instance_user}'
$password='${instance_password}'

# Change PW
Write-Output "Changing $user password"
net user $user $password
Write-Output "Changed $user password"


##### Need Admin Privileges
### Language Pack Install
# Install-Language ja-JP
# Set-WinUserLanguageList ja,en-US -force

### Language Settings
# Set-WinUILanguageOverride -Language ja-JP
# Set-SystemPreferredUILanguage ja-JP

### Input Method to IME
# Set-WinDefaultInputMethodOverride "0411:00000411"

# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "LayerDriver JPN" /t "REG_SZ" /d "kbd106.dll" /f
# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "OverrideKeyboardIdentifier" /t "REG_SZ" /d "PCAT_106KEY" /f
# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "OverrideKeyboardSubtype" /t "REG_DWORD" /d "2" /f
# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "OverrideKeyboardType" /t "REG_DWORD" /d "7" /f

### Region
# Set-WinHomeLocation -GeoId 122

### TimeZone
# Set-TimeZone -id "Tokyo Standard Time"

### Copy All Users
# Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True

### System Locale
# Set-WinSystemLocale -SystemLocale ja-JP

### RDP Session 
# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fSingleSessionPerUser" /t "REG_DWORD" /d "0" /f

### Restart
# Restart-Computer -Force