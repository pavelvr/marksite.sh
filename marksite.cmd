@echo off
setlocal
set PATH=%~dp0bin;%PATH%
set APPPATH=%~dp0
bash marksite.sh %*
endlocal