$uri = "http://cdn.mysql.com/Downloads/MySQL-Shell/mysql-shell-8.0.12-windows-x86-64bit.msi"
$out = "$home\Downloads\mysql-shell-8.0.12-windows-x86-64bit.msi"
Invoke-WebRequest -uri $uri -OutFile $out
Start-Process "msiexec.exe" -ArgumentList "/i $out /quiet  /norestart /l c:\installlog.txt"