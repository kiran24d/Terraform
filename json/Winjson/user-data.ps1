<powershell>
Set-ExecutionPolicy Bypass -Scope Process -Force
$uri = "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe"
$out = "$home\Downloads\vc_redist.x64.exe"
Invoke-WebRequest -uri $uri -OutFile $out
powershell "$home\Downloads\vc_redist.x64.exe /quiet /feature-on" -ArgumentList "/i $out /quiet  /norestart /l c:\vc_redist.x64.txt"

$uri = "http://cdn.mysql.com/Downloads/MySQL-Shell/mysql-shell-8.0.12-windows-x86-64bit.msi"
$out = "$home\Downloads\mysql-shell-8.0.12-windows-x86-64bit.msi"
Invoke-WebRequest -uri $uri -OutFile $out
Start-Process "msiexec.exe" -ArgumentList "/i $out /quiet  /norestart /l c:\mysqlshell.txt"

$uri = "https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi"
$out = "$home\Downloads\AWSCLI64PY3.msi"
Invoke-WebRequest -uri $uri -OutFile $out
Start-Process "msiexec.exe" -ArgumentList "/i $out /quiet  /norestart /l c:\awscli.txt"
Write-Host -ForegroundColor Green "Installation successful on $env:COMPUTERNAME"
</powershell>
