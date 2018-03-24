@echo off
:WHILE
SETLOCAL EnableExtensions
set EXE=iexplore.exe
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto FOUND
@echo iexplore Not running
goto CONTINUE

:FOUND
@echo found iexplore running...try kill all process
start "" /w taskkill /f /im iexplore.exe /t && (@echo done !) || (@echo error)
goto WHILE

:CONTINUE
exit