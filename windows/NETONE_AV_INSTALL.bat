@echo off
rem Written by Emre Ozudogru
TITLE NETONE Antivirus Install
color 47
cls
echo.
rem Burada kullanıcı adı ve parola sorgulaması yapılıyor.
ECHO Lutfen bu dosyayi PsExec64 ile aynı dizinden calistirin.
ECHO.
SET /p UserName=Domain Yetkili Kullanici Adiniz: 
SET /p Password=Domain Yetkili Parolaniz: 
cls
rem ad sorgulanıp istenilen bilgisayarların dokumu dosyaya yazılıyor.
dsquery * -u %UserName% -p %Password%  "OU=Computers,OU=NEW NETONE,DC=netone,DC=net,DC=tr" -filter "(objectcategory=computer)" -limit 999999 -attr name  > domaincomputers.txt
dsquery * -u %UserName% -p %Password%  "OU=Izmir_Computers,OU=NEW NETONE,DC=netone,DC=net,DC=tr" -filter "(objectcategory=computer)" -limit 999999 -attr name >> domaincomputers.txt
rem bu bilgisayarlara istenilen işlemler yaptırılıyor.
FOR /f %%i IN ( domaincomputers.txt ) DO (
set ERRORLEVEL=
rem öncelikle ping atarak bilgisayarın aık olup olmadığı kontrol ediliyor. bu yapılmaz ise time out süreleri uzun olduğu için işlem ciddi şekilde yavaş oalcaktır.
ping %%i.netone.net.tr -n 1 -w 100 >>PING.txt 
if not ERRORLEVEL == 1 (
echo %%i Ayarlaniyor...
echo %%i ACIK %date%-%time% >>acik.txt
START /MIN PsExec64.exe \\%%i.netone.net.tr -d -u %UserName% -p %Password% -s if not exist "C:\Program Files (x86)\Trend Micro\OfficeScan Client\Ntrtscan.exe" \\btantsrpg01.netone.net.tr\ofcscan\AutoPcc.exe

  )
  )

