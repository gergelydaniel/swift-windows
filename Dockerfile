# escape=`

FROM mcr.microsoft.com/windows/servercore:1809-amd64

# Install windows buildtools.
RUN powershell mkdir .\TEMP\; `
    Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vs_buildtools.exe -OutFile .\TEMP\vs_buildtools.exe; `
    Start-Process .\TEMP\vs_buildtools.exe  -Wait -ArgumentList '--quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Component.VC.CMake.Project `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows10SDK `
    --add Microsoft.VisualStudio.Component.Windows10SDK.17763'; `
    Remove-Item –path .\TEMP\vs_buildtools.exe

# Install git
ENV GIT_VERSION 2.15.1
ENV GIT_PATCH_VERSION 2

RUN powershell -Command $ErrorActionPreference = 'Stop' ; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
    Invoke-WebRequest $('https://github.com/git-for-windows/git/releases/download/v{0}.windows.{1}/MinGit-{0}.{1}-busybox-64-bit.zip' -f $env:GIT_VERSION, $env:GIT_PATCH_VERSION) -OutFile 'mingit.zip' -UseBasicParsing ; `
    Expand-Archive mingit.zip -DestinationPath c:\mingit ; `
    Remove-Item mingit.zip -Force ; `
    setx /M PATH $('c:\mingit\cmd;{0}' -f $env:PATH)

# Install swift tools
ADD "https://swift.org/builds/development/windows10/swift-DEVELOPMENT-SNAPSHOT-2021-02-18-a/swift-DEVELOPMENT-SNAPSHOT-2021-02-18-a-windows10.exe" "C:\swift-windows-installer.exe"
RUN C:\swift-windows-installer.exe /quiet

# Set up modulemaps and environment variables
ADD "https://raw.githubusercontent.com/apple/swift/main/stdlib/public/Platform/ucrt.modulemap" "C:\\modulemaps\\ucrt.modulemap"
ADD "https://raw.githubusercontent.com/apple/swift/main/stdlib/public/Platform/visualc.modulemap" "C:\\modulemaps\\visualc.modulemap"
ADD "https://raw.githubusercontent.com/apple/swift/main/stdlib/public/Platform/visualc.apinotes" "C:\\modulemaps\\visualc.apinotes"
ADD "https://raw.githubusercontent.com/apple/swift/main/stdlib/public/Platform/winsdk.modulemap" "C:\\modulemaps\\winsdk.modulemap"

COPY "setup.bat" "c:\setup.bat"

RUN "setup.bat"

# Cleanup
RUN DEL /F/Q/S c:\modulemaps && DEL c:\setup.bat && DEL C:\swift-windows-installer.exe

ADD glfw "c:\libraries\glfw"

RUN setx LIB "%LIB%;c:\libraries\glfw\lib" && setx INCLUDE "%INCLUDE%;c:\libraries\glfw\include"

ENTRYPOINT ["cmd"]
