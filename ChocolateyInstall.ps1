# Download and install Chocolatey nupkg from an OData (HTTP/HTTPS) url such as Artifactory, Nexus, ProGet (all of these are recommended for organizational use), or Chocolatey.Server (great for smaller organizations and POCs)
# This is where you see the top level API - with xml to Packages - should look nearly the same as https://chocolatey.org/api/v2/
# If you are using Nexus, always add the trailing slash or it won't work
# === EDIT HERE ===
$packageRepo = 'http://tnvgtwcch01.netone.net.tr:8081/repository/chocolatey-proxy/'

# If the above $packageRepo repository requires authentication, add the username and password here. Otherwise these leave these as empty strings.
$repoUsername = ''    # this must be empty is NOT using authentication
$repoPassword = ''    # this must be empty if NOT using authentication

# Determine unzipping method
# 7zip is the most compatible, but you need an internally hosted 7za.exe.
# Make sure the version matches for the arguments as well.
# Built-in does not work with Server Core, but if you have PowerShell 5
# it uses Expand-Archive instead of COM
$unzipMethod = 'builtin'
#$unzipMethod = '7zip'
#$7zipUrl = 'https://chocolatey.org/7za.exe' (download this file, host internally, and update this to internal)

# === ENVIRONMENT VARIABLES YOU CAN SET ===
# Prior to running this script, in a PowerShell session, you can set the
# following environment variables and it will affect the output

# - $env:ChocolateyEnvironmentDebug = 'true' # see output
# - $env:chocolateyIgnoreProxy = 'true' # ignore proxy
# - $env:chocolateyProxyLocation = '' # explicit proxy
# - $env:chocolateyProxyUser = '' # explicit proxy user name (optional)
# - $env:chocolateyProxyPassword = '' # explicit proxy password (optional)

# === NO NEED TO EDIT ANYTHING BELOW THIS LINE ===
# Ensure we can run everything
Set-ExecutionPolicy Bypass -Scope Process -Force;

# If the repository requires authentication, create the Credential object
if ((-not [string]::IsNullOrEmpty($repoUsername)) -and (-not [string]::IsNullOrEmpty($repoPassword))) {
$securePassword = ConvertTo-SecureString $repoPassword -AsPlainText -Force
$repoCreds = New-Object System.Management.Automation.PSCredential ($repoUsername, $securePassword)
}

$searchUrl = ($packageRepo.Trim('/'), 'Packages()?$filter=(Id%20eq%20%27chocolatey%27)%20and%20IsLatestVersion') -join '/'

# Reroute TEMP to a local location
New-Item $env:ALLUSERSPROFILE\choco-cache -ItemType Directory -Force
$env:TEMP = "$env:ALLUSERSPROFILE\choco-cache"

$localChocolateyPackageFilePath = Join-Path $env:TEMP 'chocolatey.nupkg'
$ChocoInstallPath = "$($env:SystemDrive)\ProgramData\Chocolatey\bin"
$env:ChocolateyInstall = "$($env:SystemDrive)\ProgramData\Chocolatey"
$env:Path += ";$ChocoInstallPath"
$DebugPreference = 'Continue';

# PowerShell v2/3 caches the output stream. Then it throws errors due
# to the FileStream not being what is expected. Fixes "The OS handle's
# position is not what FileStream expected. Do not use a handle
# simultaneously in one FileStream and in Win32 code or another
# FileStream."
function Fix-PowerShellOutputRedirectionBug {
$poshMajorVerion = $PSVersionTable.PSVersion.Major

if ($poshMajorVerion -lt 4) {
try{
# http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
$consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
[void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
$field.SetValue($consoleHost, [Console]::Out)
[void] $consoleHost.GetType().GetProperty("IsStandardErrorRedirected", $bindingFlags).GetValue($consoleHost, @())
$field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
$field2.SetValue($consoleHost, [Console]::Error)
} catch {
Write-Output 'Unable to apply redirection fix.'
}
}
}

Fix-PowerShellOutputRedirectionBug

# Attempt to set highest encryption available for SecurityProtocol.
# PowerShell will not set this by default (until maybe .NET 4.6.x). This
# will typically produce a message for PowerShell v2 (just an info
# message though)
try {
# Set TLS 1.2 (3072), then TLS 1.1 (768), then TLS 1.0 (192)
# Use integers because the enumeration values for TLS 1.2 and TLS 1.1 won't
# exist in .NET 4.0, even though they are addressable if .NET 4.5+ is
# installed (.NET 4.5 is an in-place upgrade).
[System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192
} catch {
Write-Output 'Unable to set PowerShell to use TLS 1.2 and TLS 1.1 due to old .NET Framework installed. If you see underlying connection closed or trust errors, you may need to upgrade to .NET Framework 4.5+ and PowerShell v3+.'
}

function Get-Downloader {
param (
[string]$url
)
$downloader = new-object System.Net.WebClient

$defaultCreds = [System.Net.CredentialCache]::DefaultCredentials
if (Test-Path -Path variable:repoCreds) {
Write-Debug "Using provided repository authentication credentials."
$downloader.Credentials = $repoCreds
} elseif ($defaultCreds -ne $null) {
Write-Debug "Using default repository authentication credentials."
$downloader.Credentials = $defaultCreds
}

$ignoreProxy = $env:chocolateyIgnoreProxy
if ($ignoreProxy -ne $null -and $ignoreProxy -eq 'true') {
Write-Debug 'Explicitly bypassing proxy due to user environment variable.'
$downloader.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
} else {
# check if a proxy is required
$explicitProxy = $env:chocolateyProxyLocation
$explicitProxyUser = $env:chocolateyProxyUser
$explicitProxyPassword = $env:chocolateyProxyPassword
if ($explicitProxy -ne $null -and $explicitProxy -ne '') {
# explicit proxy
$proxy = New-Object System.Net.WebProxy($explicitProxy, $true)
if ($explicitProxyPassword -ne $null -and $explicitProxyPassword -ne '') {
$passwd = ConvertTo-SecureString $explicitProxyPassword -AsPlainText -Force
$proxy.Credentials = New-Object System.Management.Automation.PSCredential ($explicitProxyUser, $passwd)
}

Write-Debug "Using explicit proxy server '$explicitProxy'."
$downloader.Proxy = $proxy

} elseif (!$downloader.Proxy.IsBypassed($url)) {
# system proxy (pass through)
$creds = $defaultCreds
if ($creds -eq $null) {
Write-Debug 'Default credentials were null. Attempting backup method'
$cred = get-credential
$creds = $cred.GetNetworkCredential();
}

$proxyaddress = $downloader.Proxy.GetProxy($url).Authority
Write-Debug "Using system proxy server '$proxyaddress'."
$proxy = New-Object System.Net.WebProxy($proxyaddress)
$proxy.Credentials = $creds
$downloader.Proxy = $proxy
}
}

return $downloader
}

function Download-File {
param (
[string]$url,
[string]$file
)
$downloader = Get-Downloader $url
$downloader.DownloadFile($url, $file)
}

function Download-Package {
param (
[string]$packageODataSearchUrl,
[string]$file
)
$downloader = Get-Downloader $packageODataSearchUrl

Write-Output "Querying latest package from $packageODataSearchUrl"
[xml]$pkg = $downloader.DownloadString($packageODataSearchUrl)
$packageDownloadUrl = $pkg.feed.entry.content.src

Write-Output "Downloading $packageDownloadUrl to $file"
$downloader.DownloadFile($packageDownloadUrl, $file)
}

function Install-ChocolateyFromPackage {
param (
[string]$chocolateyPackageFilePath = ''
)

if ($chocolateyPackageFilePath -eq $null -or $chocolateyPackageFilePath -eq '') {
throw "You must specify a local package to run the local install."
}

if (!(Test-Path($chocolateyPackageFilePath))) {
throw "No file exists at $chocolateyPackageFilePath"
}

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "chocInstall"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "chocolatey.zip"
Copy-Item $chocolateyPackageFilePath $file -Force

# unzip the package
Write-Output "Extracting $file to $tempDir..."
if ($unzipMethod -eq '7zip') {
$7zaExe = Join-Path $tempDir '7za.exe'
if (-Not (Test-Path ($7zaExe))) {
Write-Output 'Downloading 7-Zip commandline tool prior to extraction.'
# download 7zip
Download-File $7zipUrl "$7zaExe"
}

$params = "x -o`"$tempDir`" -bd -y `"$file`""
# use more robust Process as compared to Start-Process -Wait (which doesn't
# wait for the process to finish in PowerShell v3)
$process = New-Object System.Diagnostics.Process
$process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo($7zaExe, $params)
$process.StartInfo.RedirectStandardOutput = $true
$process.StartInfo.UseShellExecute = $false
$process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
$process.Start() | Out-Null
$process.BeginOutputReadLine()
$process.WaitForExit()
$exitCode = $process.ExitCode
$process.Dispose()

$errorMessage = "Unable to unzip package using 7zip. Perhaps try setting `$env:chocolateyUseWindowsCompression = 'true' and call install again. Error:"
switch ($exitCode) {
0 { break }
1 { throw "$errorMessage Some files could not be extracted" }
2 { throw "$errorMessage 7-Zip encountered a fatal error while extracting the files" }
7 { throw "$errorMessage 7-Zip command line error" }
8 { throw "$errorMessage 7-Zip out of memory" }
255 { throw "$errorMessage Extraction cancelled by the user" }
default { throw "$errorMessage 7-Zip signalled an unknown error (code $exitCode)" }
}
} else {
if ($PSVersionTable.PSVersion.Major -lt 5) {
try {
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace($file)
$destinationFolder = $shellApplication.NameSpace($tempDir)
$destinationFolder.CopyHere($zipPackage.Items(),0x10)
} catch {
throw "Unable to unzip package using built-in compression. Set `$env:chocolateyUseWindowsCompression = 'false' and call install again to use 7zip to unzip. Error: `n $_"
}
} else {
Expand-Archive -Path "$file" -DestinationPath "$tempDir" -Force
}
}

# Call Chocolatey install
Write-Output 'Installing chocolatey on this machine'
$toolsFolder = Join-Path $tempDir "tools"
$chocInstallPS1 = Join-Path $toolsFolder "chocolateyInstall.ps1"

& $chocInstallPS1

Write-Output 'Ensuring chocolatey commands are on the path'
$chocInstallVariableName = 'ChocolateyInstall'
$chocoPath = [Environment]::GetEnvironmentVariable($chocInstallVariableName)
if ($chocoPath -eq $null -or $chocoPath -eq '') {
$chocoPath = 'C:\ProgramData\Chocolatey'
}

$chocoExePath = Join-Path $chocoPath 'bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower()) -eq $false) {
$env:Path = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine);
}

Write-Output 'Ensuring chocolatey.nupkg is in the lib folder'
$chocoPkgDir = Join-Path $chocoPath 'lib\chocolatey'
$nupkg = Join-Path $chocoPkgDir 'chocolatey.nupkg'
if (!(Test-Path $nupkg)) {
Write-Output 'Copying chocolatey.nupkg is in the lib folder'
if (![System.IO.Directory]::Exists($chocoPkgDir)) { [System.IO.Directory]::CreateDirectory($chocoPkgDir); }
Copy-Item "$file" "$nupkg" -Force -ErrorAction SilentlyContinue
}
}

# Idempotence - do not install Chocolatey if it is already installed
if (!(Test-Path $ChocoInstallPath)) {
# download the package to the local path
if (!(Test-Path $localChocolateyPackageFilePath)) {
Download-Package $searchUrl $localChocolateyPackageFilePath
}

# Install Chocolatey
Install-ChocolateyFromPackage $localChocolateyPackageFilePath
}