copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui C:\Windows\System32\en-US\
cleanmgr.exe /verylowdisk


net stop wuauserv
net stop bits
rd c:\windows\SoftwareDistribution /q /s
net start wuauserv
net start bits
wuauclt /detectnow
