chcp 65001 > nul
powershell Unblock-File -Path '%~dp0\run.ps1'
powershell -ExecutionPolicy RemoteSigned -File "%~dp0\run.ps1"
pause