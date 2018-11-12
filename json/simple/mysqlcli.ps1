<powershell>
mkdir "c:\aws\download"
Set-Location "c:\aws\download"

$wc = New-Object System.Net.WebClient
$myurl = "https://s3.amazonaws.com/ec2-downloads/"