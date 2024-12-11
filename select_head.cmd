@echo off
chcp 65001 > nul
powershell Unblock-File -Path '%~dp0\run.ps1'
powershell -ExecutionPolicy RemoteSigned -File "%~dp0\run.ps1" "{0.0.0.00000000}.{8325a135-f30b-4905-b30a-2fbe89bb868e}"