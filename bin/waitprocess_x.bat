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
if %errorlevel% == 0 goto found1
tasklist /nh /fi "windowtitle eq %~4" | findstr /i /C:%5
if %errorlevel% == 0 goto found2
goto not_found

:found1
title done !
@echo found process name [%~1] - [%~2]
timeout 1
goto end

:found2
title done !
@echo found process name [%~4] - [%~5]
timeout 1
goto end

:end
exit
::exit /b 0