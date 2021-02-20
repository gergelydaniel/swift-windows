CALL C:\BuildTools\Common7\Tools\VsDevCmd.bat -arch=amd64

copy C:\modulemaps\ucrt.modulemap "%UniversalCRTSdkDir%\Include\%UCRTVersion%\ucrt\module.modulemap"
copy C:\modulemaps\visualc.modulemap "%VCToolsInstallDir%\include\module.modulemap"
copy C:\modulemaps\visualc.apinotes "%VCToolsInstallDir%\include\visualc.apinotes"
copy C:\modulemaps\winsdk.modulemap "%UniversalCRTSdkDir%\Include\%UCRTVersion%\um\module.modulemap"

setx INCLUDE "%INCLUDE%"
setx LIB "%VCToolsInstallDir%lib\x64;%UniversalCRTSdkDir%Lib\%UCRTVersion%\ucrt\x64;%UniversalCRTSdkDir%Lib\%UCRTVersion%\um\x64"
setx SWIFTFLAGS "-sdk %SDKROOT% -resource-dir %SDKROOT%\usr\lib\swift -I %SDKROOT%\usr\lib\swift -L %SDKROOT%\usr\lib\swift\windows"
