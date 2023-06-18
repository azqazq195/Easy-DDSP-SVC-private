@ECHO OFF
chcp 65001 >nul
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)

SETLOCAL EnableDelayedExpansion

@echo 파일을 변환 중입니다.
@echo 44100hz wav 파일 변환 및 음원의 공백을 제거합니다.
@echo 한곡당 30초 ~ 1분 소요됩니다.
@echo:

call python -m venv .venv
call .venv\Scripts\activate.bat
call python convert_audio.py

@echo !ESC![32m변환 완료!!ESC![0m
pause