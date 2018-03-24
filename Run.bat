@echo       -------- AprilGATE Auto installer --------
@echo           	 Made by Slowlove
@echo       ------------------------------------------
      
@echo off
color 3f
title AprilGATE Auto installer
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set vc_path="./bin/vcredist_x86.exe"
set flash_path="./bin/install_flash_player_23_active_x.msi"
set net_path="./bin/NET Framework 4.0 Setup (Full Package).exe"
set netfolder_path="%windir%\Microsoft.NET\Framework\v4.0.30319"
set killie_path="./bin/kill_ie-admin.lnk"
set gate_path="%appdata%\AprilGateVietnam"
set seedbed_path="%appdata%\SeedbedVietnam"
set temp_path="%localappdata%\apps\2.0"
set gate_url=http://deploy.apaxenglish.com/aprilgatevietnam/aprilgatevietnam.application
set Seedbed_url=http://deploy.apaxenglish.com/SeedbedVietnam/AprilSeedbedVietnam.application
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:begin
REG QUERY HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\ /v EnableLUA ^
 | findstr /I /C:"0x1" >nul && (goto duac) || (goto error)
:error
if "%ERRORLEVEL%" NEQ "0" @echo UAC status: OFF !
goto pass
:duac
@echo Found UAC status: ON !
start "" /w ./bin/nircmd infobox "Disable UAC truoc' khi chay chuong trinh !" "Warning"
useraccountcontrolsettings
::goto begin
:pass
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
start ./bin/srt-admin.lnk
start ./bin/reinstall.lnk
start "" /w ./bin/nircmd setvolume 0 65535 65535
if exist "%systemdrive%\Program Files (x86)" (set /a arc_os=64) else set /a arc_os=32
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows xp" >nul && @echo Thong tin HDH: Windows XP - %arc_os%bit && goto ip_info
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows vista" >nul && @echo Thong tin HDH: Windows Vista - %arc_os%bit && goto ip_info
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 7" >nul && @echo Thong tin HDH: Windows 7 - %arc_os%bit && goto ip_info
 reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:".1" >nul && @echo Thong tin HDH: Windows 8.1 - %arc_os%bit && goto ip_info
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 8" >nul && @echo Thong tin HDH: Windows 8 - %arc_os%bit && goto ip_info
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 10" >nul && @echo Thong tin HDH: Windows 10 - %arc_os%bit && goto ip_info
 :ip_info
ipconfig /all | findstr /i /c:"IPv4 Address" /c:"subnet"
@echo ---------------------------------------------------------------
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows xp" >nul && goto winxp
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows vista" >nul && goto win_vista
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 7" >nul && goto win7
 reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:".1" >nul && goto win8.1
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 8" >nul && goto win8
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" ^
 | findstr /I /C:"windows 10" >nul && goto win10
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win_vista
:win7
@echo Dang cai dat vc_x86...
start "" /w %vc_path% /passive && (@echo done !) || (@echo error !)
@echo Dang cai dat flash player for windows 7...
start "" /w %flash_path% /passive && (@echo done !) || (@echo error !)

if not exist %netfolder_path% (
	@echo Dang cai dat NetFreamwork 4.0...
	start "" /w %net_path% /passive /norestart
	if not exist %netfolder_path% (
		@echo Install .Net error, try Auto fix !
		start "" /w taskkill /f /im Setup.exe /t ^
		&& (@echo kill setup .Net done !) || (@echo kill .NET error)
		net stop WuAuServ
		start "" /w ./bin/IObitUnlocker /Rename /Advanced ^
		"C:\Windows\SoftwareDistribution" "SoftwareDistribution_old" ^
		&& (@echo Unlock ok !) || (@echo Unlock error !)
		ren "%windir%\SoftwareDistribution" "SoftwareDistribution_old"
		net start WuAuServ
			if exist %windir%\SoftwareDistribution_old (
				@echo rename Success, try reinstall .NET !
				start "" /w "./bin/ResetWUAgent v2.0-admin.lnk"
				start "" /w %net_path% /passive /norestart
				if not exist %netfolder_path% (
					start "" /w ./bin/nircmd infobox "Install .Net bi loi~, Try repair nhung khong thanh cong !" "Error"
					goto:eof
				) else (
					@echo done
				)
			) else (
				start "" /w ./bin/nircmd infobox "Install .Net bi loi~, thu' cai dat thu' cong !" "Error"
				goto:eof
			)
	) else (
		@echo done !
	)
) else (
@echo NET4.0 da duoc cai dat tren may tinh nay!
)

goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win8
@echo Dang cai dat vc_x86...
start "" /w %vc_path% /passive && (@echo done !) || (@echo error !)
@echo Dang cai dat flash player for windows 8...
start "" /w %flash_path% /passive && (@echo done !) || (@echo error !)
goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:win8.1
:win10
@echo Dang cai dat vc_x86...
start "" /w %vc_path% /passive && (@echo done !) || (@echo error !)
goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:main
@echo Reset IE setting...
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
start "" /w ./bin/nircmd win activate title "Reset Internet Explorer Settings"
timeout 3
start "" /w ./bin/nircmd sendkey tab press
start "" /w ./bin/nircmd sendkey spc press
timeout 1
start "" /w ./bin/nircmd sendkeypress alt+R
timeout 10
start "" /w ./bin/nircmd win close title "Reset Internet Explorer Settings"
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)

start "" iexplore %gate_url%
@echo Dang cai dat April Gate...
start "" /w ./bin/nircmd win child ititle "Internet Explorer" close ititle "Internet Explorer"

start "" /w call ./bin/waitprocess "Application Install - Security Warning" "dfsvc.exe" 90
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+I

start "" /w call ./bin/waitprocess_x ^
"Open File - Security Warning" "dfsvc.exe" 90 "Creative Learning" "AprilGateVietnam.exe"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+R

start "" /w call ./bin/waitprocess "Creative Learning" "AprilGateVietnam.exe" 30
::if exist %gate_path% (@echo AprilGate done !) else @echo AprilGate fail !
dir "%localappdata%\apps\2.0" /s /p | findstr /i /C:"AprilGateVietnam.exe" >nul
if %errorlevel% == 0 (echo AprilGate done !) else echo AprilGate fail !

start "" /w taskkill /f /im AprilGateVietnam.exe
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)

start "" iexplore %Seedbed_url%
@echo Dang cai dat April Seedbed...
start "" /w call ./bin/waitprocess "Application Install - Security Warning" "dfsvc.exe" 20
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+I

start "" /w call ./bin/waitprocess_x ^
"Open File - Security Warning" "dfsvc.exe" 30 "Seedbed" "AprilSeedbedVietnam.exe"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+R
::if exist %seedbed_path% (@echo Seedbed done !) else @echo Seedbed fail !
dir "%localappdata%\apps\2.0" /s /p | findstr /i /C:"AprilSeedbedVietnam.exe" >nul
if %errorlevel% == 0 (echo Seedbed done !) else echo Seedbed fail !

start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)
@echo Hoan tat cai dat!
start "" /w ./bin/nircmd beep 2000 350
start "" /w ./bin/nircmd beep 2500 350
start "" /w ./bin/nircmd beep 3000 350
echo test_sb2|clip
timeout 5
exit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:winxp
@echo Dang cai dat vc_x86...
start "" /w %vc_path% /passive && (@echo done !) || (@echo error !)
@echo Dang cai dat flash player for windows XP...
start "" /w %flash_path% /passive && (@echo done !) || (@echo error !)

if not exist %netfolder_path% (
	@echo Dang cai dat NetFreamwork 4.0...
	start "" /w %net_path% /passive /norestart
	if not exist %netfolder_path% (
		@echo Install .Net error, try Auto fix !
		start "" /w taskkill /f /im Setup.exe /t ^
		&& (@echo kill setup .Net done !) || (@echo kill .NET error)
		start "" /w "./bin/ResetWUAgent v2.0-admin.lnk"
		net stop msiserver
		start "" /w ./bin/WindowsInstaller-KB893803-v2-x86.exe /passive /norestart
		REG add "HKLM\SYSTEM\CurrentControlSet\services\msiserver" /v Start /t REG_DWORD /d 2 /f
		net start msiserver
		start "" /w ./bin/wic_x86_enu.exe /passive /norestart
		net stop WuAuServ
		start "" /w ./bin/IObitUnlocker /Rename /Advanced ^
		"C:\Windows\SoftwareDistribution" "SoftwareDistribution_old" ^
		&& (@echo Unlock ok !) || (@echo Unlock error !)
		ren "%windir%\SoftwareDistribution" "SoftwareDistribution_old"
		net start WuAuServ
			if exist %windir%\SoftwareDistribution_old (
				@echo rename Success, try reinstall .NET !
				start "" /w %net_path% /passive /norestart
				if not exist %netfolder_path% (
					start "" /w ./bin/nircmd infobox "Install .Net bi loi~, Try repair nhung khong thanh cong !" "Error"
					goto:eof
				) else (
					@echo done
				)
			) else (
				start "" /w ./bin/nircmd infobox "Install .Net bi loi~, thu' cai dat thu' cong !" "Error"
				goto:eof
			)
	) else (
		@echo done !
	)
) else (
@echo NET4.0 da duoc cai dat tren may tinh nay!
)

@echo Reset IE setting...
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)
start RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
start "" /w ./bin/nircmd win activate title "Reset Internet Explorer Settings"
PING 127.0.0.1 -n 3 >NUL 2>&1
start "" /w ./bin/nircmd sendkey tab press
start "" /w ./bin/nircmd sendkey spc press
PING 127.0.0.1 -n 1 >NUL 2>&1
start "" /w ./bin/nircmd sendkeypress alt+R
PING 127.0.0.1 -n 10 >NUL 2>&1
start "" /w ./bin/nircmd win close title "Reset Internet Explorer Settings"
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)

start "" iexplore %gate_url%
@echo Dang cai dat April Gate...
PING 127.0.0.1 -n 40 >NUL 2>&1
start "" /w ./bin/nircmd win child ititle "Internet Explorer" close ititle "Internet Explorer"
PING 127.0.0.1 -n 2 >NUL 2>&1
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+I
PING 127.0.0.1 -n 40 >NUL 2>&1
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+R
PING 127.0.0.1 -n 10 >NUL 2>&1
::if exist %gate_path% (@echo AprilGate done !) else @echo AprilGate fail !
dir "%localappdata%\apps\2.0" /s /p | findstr /i /C:"AprilGateVietnam.exe" >nul
if %errorlevel% == 0 (echo AprilGate done !) else echo AprilGate fail !

start "" /w taskkill /f /im AprilGateVietnam.exe
start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)

start "" iexplore %Seedbed_url%
@echo Dang cai dat April Seedbed...
PING 127.0.0.1 -n 10 >NUL 2>&1
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd win activate title "Application Install - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+I
PING 127.0.0.1 -n 20 >NUL 2>&1
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd win activate title "Open File - Security Warning"
start "" /w ./bin/nircmd sendkeypress alt+R
::if exist %seedbed_path% (@echo Seedbed done !) else @echo Seedbed fail !
dir "%localappdata%\apps\2.0" /s /p | findstr /i /C:"AprilSeedbedVietnam.exe" >nul
if %errorlevel% == 0 (echo Seedbed done !) else echo Seedbed fail !

start "" /w %killie_path% && (@echo Kill IE done !) || (@echo Kill IE error !)
@echo Hoan tat cai dat!
start "" /w ./bin/nircmd beep 2000 350
start "" /w ./bin/nircmd beep 2500 350
start "" /w ./bin/nircmd beep 3000 350
echo test_sb2|clip
PING 127.0.0.1 -n 5 >NUL 2>&1
exit