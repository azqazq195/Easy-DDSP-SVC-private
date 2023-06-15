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

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM 필수 프로그램 다운로드
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@

@echo Downloading the following programs and files.
@echo:

@echo Program Download List
@echo  - Nvidia CUDA
@echo  - Microsoft Visual Studio 2022 Build Tools
@echo  - Python
@echo  - FFmpeg
@echo:

@echo File Download List
@echo  - https://github.com/bshall/hubert/releases/download/v0.1/hubert-soft-0d54a1f4.pt
@echo  - https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip
@echo  - https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr
@echo:

@echo Checking if CUDA is installed
winget list --name "CUDA">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Nvidia CUDA is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Nvidia.CUDA -v 11.8
) else (
    @echo Nvidia CUDA is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@echo Checking if Microsoft Visual Studio 2022 Build Tools is installed
winget list --name "Visual Studio Build Tools">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Microsoft Visual Studio 2022 Build Tools is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Microsoft.VisualStudio.2022.BuildTools
) else (
    @echo Microsoft Visual Studio 2022 Build Tools is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@echo Checking if Python 3.11 is installed
winget list --name "python">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Python 3.11 is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Python.Python.3.11
) else (
    @echo Python 3.11 is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@echo Checking if FFmpeg is installed
winget list --name "ffmpeg">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo FFmpeg is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Gyan.FFmpeg
) else (
    @echo FFmpeg is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM 모델 다운로드
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@

@echo Model installing...

@REM 모델 1
set "filename=hubert-soft-0d54a1f4.pt"
curl -L -o "%filename%" https://github.com/bshall/hubert/releases/download/v0.1/%filename%
if not exist DDSP-SVC\pretrain\hubert (
    mkdir DDSP-SVC\pretrain\hubert
)
move /Y "%filename%" DDSP-SVC\pretrain\hubert

@REM 모델 2
set "filename=nsf_hifigan_20221211.zip"
curl -L -o "%filename%" https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/%filename%
if not exist DDSP-SVC\pretrain (
    mkdir DDSP-SVC\pretrain
)
powershell -Command "Expand-Archive -Path %filename% -DestinationPath .\DDSP-SVC/pretrain -Force"
del %filename%

@REM 모델 3
if not exist DDSP-SVC\pretrain\ContentVec (
    mkdir DDSP-SVC\pretrain\ContentVec
)
echo You need to download the file directly from the open website.
:loop
echo If you are ready, please enter "Y" and press Enter.
set /p YN=
echo:
if /i "%YN%" == "Y" (
    start powershell -Command "Start-Process 'https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr'"
    goto :end
)
goto :loop
:end

echo You need to move the downloaded file to the open folder.
:loop1
echo If you are ready, please enter "Y" and press Enter.
set /p YN=
if /i "%YN%" == "Y" (
    explorer "%CD%\DDSP-SVC\pretrain\ContentVec"
    echo:
    goto :loop2
)
goto :loop1

:loop2
echo If you have moved the file, please enter "Y" and press Enter.
set /p YN2=
echo:
if /i "%YN2%" == "Y" (
    if exist %CD%\DDSP-SVC\pretrain\ContentVec\checkpoint_best_legacy_500.pt (
        echo The file has been confirmed.
        goto :end
    ) else (
        echo Please check if you have moved the file to the correct path.
        goto :loop2
    )
)
goto :loop2
:end

@echo:
@echo !ESC![32mSetup Finished!!ESC![0m

pause