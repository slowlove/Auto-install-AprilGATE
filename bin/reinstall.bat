@echo off
del "%homepath%\Desktop\April GATE (for APAX Eng.).appref-ms" /f /s /q
del "%homepath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\APAX English" /f /s /q
rmdir /s /q "%homepath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\APAX English"

dir "%localappdata%\apps\2.0" /s /p | findstr /i /C:"AprilGateVietnam.exe"
if %errorlevel% == 0 goto found

echo Fresh install mode...
goto:eof

:found
echo Gate detected !, goto remove all data of program !
del "%localappdata%\apps\2.0\*.*" /f /s /q
rmdir /s /q "%localappdata%\apps\2.0"
goto:eof