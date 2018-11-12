c#Download and run MSI package for Automated install
$uri = "https://s3.amazonaws.com/softwareinstall12/nginx.msi"
$out = "nginx.msi"
Invoke-WebRequest -uri $uri -OutFile $out
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $out /quiet /norestart /l c:\install.log.txt"
