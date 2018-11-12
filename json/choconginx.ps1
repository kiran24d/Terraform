
Start-Process -FilePath "powershell.exe" -ArgumentList "/i $out /quiet /norestart /l c:\install.log.txt" 

 Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | Out-File -FilePath C:\Windows\Temp\choco-chocolatey.txt}

 Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {choco install nginx-service -y | Out-File -FilePath C:\Windows\Temp\choco-nginx.txt}
    