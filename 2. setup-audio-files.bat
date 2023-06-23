@ECHO OFF
chcp 65001 >nul
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)

SETLOCAL EnableDelayedExpansion

@echo ================================================
@echo 파일을 변환합니다.
@echo 44100hz wav 파일 변환 및 음원의 공백을 제거합니다.
@echo 한곡당 30초 ~ 1분 소요됩니다.
@echo ================================================
@echo:

call python -m venv .venv
call .venv\Scripts\activate.bat
call python convert-audio.py

@echo ================================================
@echo 파일을 15초 간격으로 분활합니다.
@echo ================================================
@echo:

call python split-audio.py

@echo !ESC![32m변환 완료!!ESC![0m
pause