# ©2019 Emre Özüdoğru
# Add DNS query answer to host file
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$serv = Read-Host -Prompt 'Host dosyasına eklenecek domaini giriniz'
$resl = "10.2.1.2"
$file = "$($env:SystemRoot)\System32\drivers\etc\hosts"
$ipv4 = (Resolve-DnsName -Name $serv -DnsOnly -Type A -Server $resl)[0]
$ipv6 = (Resolve-DnsName -Name $serv -DnsOnly -Type AAAA -Server $resl)[0]
if ($ipv6.IpAddress){Add-Content -Path $file -Value "$($ipv6.IpAddress) $($ipv6.Name)"} 
if ($ipv4.IpAddress){Add-Content -Path $file -Value "$($ipv4.IpAddress) $($ipv4.Name)"}
Get-Content -Path $file
cmd /c pause