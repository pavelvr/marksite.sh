@echo off
setlocal
set PATH=%~dp0;%PATH%
start "marksite console" cmd /k "prompt $P^:$_$B$G$S & echo Tip: run marksite without parameters for usage help"
endlocal