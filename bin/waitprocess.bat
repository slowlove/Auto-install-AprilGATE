@echo off
color 0e
mode 80,6
SETLOCAL EnableExtensions
set /a count = 0

:not_found
cls
if %count% == %3 goto end
set /a count += 1
title %count%s...
@echo --- wait %count%s to finish ---
timeout 1 >nul
tasklist /nh /fi "windowtitle eq %~1" | findstr /i /C:%2
if %errorlevel% neq 0 goto not_found
goto found

:found
title done !
@echo found process name [%~1] - [%~2]
timeout 1

:end
exit
::exit /b 0