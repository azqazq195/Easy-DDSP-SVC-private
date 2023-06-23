@ECHO OFF
chcp 65001 >nul
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)

SETLOCAL EnableDelayedExpansion

@REM !ESC![30mBlack!ESC![0m
@REM !ESC![31mRed!ESC![0m
@REM !ESC![32mGreen!ESC![0m
@REM !ESC![33mYellow!ESC![0m
@REM !ESC![34mBlue!ESC![0m
@REM !ESC![35mMagenta!ESC![0m
@REM !ESC![36mCyan!ESC![0m
@REM !ESC![37mWhite!ESC![0m

@echo 아래 프로그램 및 파일을 다운로드 합니다.
@echo:

@echo 1. 프로그램 설치 (약 7 GB)
@echo  - Nvidia CUDA
@echo  - Microsoft Visual Studio 2022 Build Tools
@echo  - Python
@echo:

@echo 2. 파일 다운로드 (약 2 GB)
@echo  - FFmpeg
@echo  - https://github.com/bshall/hubert/releases/download/v0.1/hubert-soft-0d54a1f4.pt
@echo  - https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip
@echo  - https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr
@echo:

@echo 3. 파이썬 환경 구성 (약 3 GB)
@echo:

call install.bat
call download.bat
call python-settings.bat

@echo !ESC![32m설치 완료!!ESC![0m
pause