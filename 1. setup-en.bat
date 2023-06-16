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

@echo Downloading the following programs and files.
@echo:

@echo Installation list
@echo  - Nvidia CUDA
@echo  - Microsoft Visual Studio 2022 Build Tools
@echo  - Python
@echo:

@echo Download list
@echo  - FFmpeg
@echo  - https://github.com/bshall/hubert/releases/download/v0.1/hubert-soft-0d54a1f4.pt
@echo  - https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip
@echo  - https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr
@echo:

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM Installation
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@

@echo Checking if Nvidia CUDA is installed.
winget list --name "CUDA">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Nvidia CUDA is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Nvidia.CUDA -v 11.8
) else (
    @echo Nvidia CUDA is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@echo Checking if Microsoft Visual Studio 2022 Build Tools is installed.
winget list --name "Visual Studio Build Tools">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Microsoft Visual Studio 2022 Build Tools is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Microsoft.VisualStudio.2022.BuildTools
) else (
    @echo Microsoft Visual Studio 2022 Build Tools is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@echo Checking if Python is installed.
winget list --name "python">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Python is not installed. !ESC![32mInstalling...!ESC![0m
    winget install -e --id Python.Python.3.11
) else (
    @echo Python is already installed. !ESC![32mSkipping...!ESC![0m
)
@echo:

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM Downloading
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@

@REM FFmpeg
if exist ffmpeg (
    rmdir /s /q ffmpeg
)
set "filename=ffmpeg-6.0-full_build.zip"
curl -L -o "%filename%" https://github.com/GyanD/codexffmpeg/releases/download/6.0/%filename%
powershell -Command "Expand-Archive -Path '%filename%' -DestinationPath '.' -Force"
rename ffmpeg-6.0-full_build ffmpeg
del "%filename%"
powershell -Command "$currentPath = Get-Location; $existingPath = [Environment]::GetEnvironmentVariable('PATH', 'User'); $newPath = $existingPath + ';'+ $currentPath + '\ffmpeg\bin'; [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')"

@REM Model 1
set "filename=hubert-soft-0d54a1f4.pt"
curl -L -o "%filename%" https://github.com/bshall/hubert/releases/download/v0.1/%filename%
if not exist DDSP-SVC\pretrain\hubert (
    mkdir DDSP-SVC\pretrain\hubert
)
move /Y "%filename%" DDSP-SVC\pretrain\hubert

@REM Model 2
set "filename=nsf_hifigan_20221211.zip"
curl -L -o "%filename%" https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/%filename%
if not exist DDSP-SVC\pretrain (
    mkdir DDSP-SVC\pretrain
)
powershell -Command "Expand-Archive -Path %filename% -DestinationPath .\DDSP-SVC/pretrain -Force"
del %filename%

@REM Model 3
if not exist DDSP-SVC\pretrain\ContentVec (
    mkdir DDSP-SVC\pretrain\ContentVec
)
echo:
echo You will need to directly download the file from the opened website.
:loop
echo If you're ready, input "Y" and press enter.
set /p YN=
echo:
if /i "%YN%" == "y" (
    start powershell -Command "Start-Process 'https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr'"
    goto :end
)
goto :loop
:end

echo Move the downloaded file to the opened folder.
:loop1
echo When ready, input "Y" and press enter.
set /p YN=
if /i "%YN%" == "Y" (
    explorer "%CD%\DDSP-SVC\pretrain\ContentVec"
    echo:
    goto :loop2
)
goto :loop1

:loop2
echo If you've moved the file, input "Y" and press enter.
set /p YN2=
echo:
if /i "%YN2%" == "Y" (
    if exist %CD%\DDSP-SVC\pretrain\ContentVec\checkpoint_best_legacy_500.pt (
        echo File verified.
        goto :end
    ) else (
        echo Please verify that you've moved the file to the correct location.
        goto :loop2
    )
)
goto :loop2
:end

@echo:

@echo !ESC![32mSetup Finished!!ESC![0m
pause
