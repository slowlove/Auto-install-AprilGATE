@echo              --------  Security status check  --------

@echo off
color 1f
@echo Try disable UAC...
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
@echo done!

@echo remove file types download in IDM
reg add "HKEY_CURRENT_USER\SOFTWARE\DownloadManager" /v "Extensions" /t REG_SZ /d "" /f
@echo done !

@echo Disabling "open file - security warning"...
reg add "HKCU\Environment" /V SEE_MASK_NOZONECHECKS /T REG_SZ /D 1 /F
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V SEE_MASK_NOZONECHECKS /T REG_SZ /D 1 /F
@echo done!

@echo Disabling "SmartScreen filter"...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV8 /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f
@echo done!

@echo Set IE to default brower...
@echo .htm extension
reg add "HKCU\Software\Classes\.htm" /t REG_SZ /d "htmlfile" /ve /f
@echo .html extension
reg add "HKCU\Software\Classes\.html" /t REG_SZ /d "htmlfile" /ve /f
@echo http shell
reg add "HKCU\Software\Classes\http\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" -nohome" /ve /f
@echo ftp shell
reg add "HKCU\Software\Classes\ftp\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" %%1" /ve /f
@echo https shell
reg add "HKCU\Software\Classes\https\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" -nohome" /ve /f
@echo http class
reg delete "HKCU\Software\Classes\http\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\http\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f
@echo ftp class
reg delete "HKCU\Software\Classes\ftp\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\ftp\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f
@echo https class
reg delete "HKCU\Software\Classes\https\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\https\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f
@echo ddeexec keys
reg add "HKCU\Software\Classes\http\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f
reg add "HKCU\Software\Classes\ftp\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f
reg add "HKCU\Software\Classes\https\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f
@echo StartMenuInternet key
reg delete "HKCU\Software\Clients\StartMenuInternet" /ve /f
reg add "HKLM\Software\Clients\StartMenuInternet" /t REG_SZ /d "IEXPLORE.EXE" /ve /f
@echo ddeexec app keys
reg add "HKCR\HTTP\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\HTTPS\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\FTP\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\htmlfile\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\htmlfile\shell\opennew\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\mhtmlfile\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\mhtmlfile\shell\opennew\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
@echo ifexec keys
reg add "HKLM\SOFTWARE\Classes\ftp\shell\open\ddeexec\ifExec" /t REG_SZ /d "*" /ve /f
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 10" >nul && goto for_win10
 goto end

:for_win10
@echo Remove Custom Default App Associations...
Dism.exe /Online /Remove-DefaultAppAssociations
@echo Import Custom Default App Associations...
dism /online /Import-DefaultAppAssociations:"MyDefaultAppAssociations.xml"
:@echo export...
:dism /online /Export-DefaultAppAssociations:"%UserProfile%\Desktop\MyDefaultAppAssociations.xml"
@echo Neu' nhin thay' loi~ gi thi dung quan tam nhe' ^^
timeout 3

:end
exit