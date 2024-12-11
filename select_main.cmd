@echo off
chcp 65001 > nul
powershell Unblock-File -Path '%~dp0\run.ps1'
powershell -ExecutionPolicy RemoteSigned -File "%~dp0\run.ps1" "{0.0.0.00000000}.{c9c4857f-b663-4cfb-8cea-e98cc275deb3}" "-DefaultOnly"