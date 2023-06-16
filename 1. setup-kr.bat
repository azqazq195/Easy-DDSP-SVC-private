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

@echo 설치 목록
@echo  - Nvidia CUDA
@echo  - Microsoft Visual Studio 2022 Build Tools
@echo  - Python
@echo:

@echo 다운로드 목록
@echo  - FFmpeg
@echo  - https://github.com/bshall/hubert/releases/download/v0.1/hubert-soft-0d54a1f4.pt
@echo  - https://github.com/openvpi/vocoders/releases/download/nsf-hifigan-v1/nsf_hifigan_20221211.zip
@echo  - https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr
@echo:

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM 설치
@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@

@echo Nvidia CUDA 가 설치되었는지 확인합니다.
winget list --name "CUDA">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Nvidia CUDA 가 설치되지 않았습니다. !ESC![32m설치중...!ESC![0m
    winget install -e --id Nvidia.CUDA -v 11.8
) else (
    @echo Nvidia CUDA 가 설치되었습니다. !ESC![32m생략...!ESC![0m
)
@echo:

@echo Microsoft Visual Studio 2022 Build Tools 이 설치되었는지 확인합니다.
winget list --name "Visual Studio Build Tools">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Microsoft Visual Studio 2022 Build Tools 이 설치되지 않았습니다. !ESC![32m설치중...!ESC![0m
    winget install -e --id Microsoft.VisualStudio.2022.BuildTools
) else (
    @echo Microsoft Visual Studio 2022 Build Tools 이 설치되었습니다. !ESC![32m생략...!ESC![0m
)
@echo:

@echo Python 이 설치되었는지 확인합니다.
winget list --name "python">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Python 이 설치되지 않았습니다. !ESC![32m설치중...!ESC![0m
    winget install -e --id Python.Python.3.11
) else (
    @echo Python 이 설치되었습니다. !ESC![32m생략...!ESC![0m
)
@echo:

@REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@
@REM 다운로드
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
echo:
echo 오픈되는 웹사이트에서 파일을 직접 다운로드 해야합니다.
:loop
echo 준비되었다면 "Y" 입력 후 엔터
set /p YN=
echo:
if /i "%YN%" == "y" (
    start powershell -Command "Start-Process 'https://ibm.ent.box.com/s/z1wgl1stco8ffooyatzdwsqn2psd9lrr'"
    goto :end
)
goto :loop
:end

echo 방금 다운로드한 파일을 오픈되는 폴더에 옮겨야합니다.
:loop1
echo 준비되었다면 "Y"를 입력한 후 엔터를 눌러주세요.
set /p YN=
if /i "%YN%" == "Y" (
    explorer "%CD%\DDSP-SVC\pretrain\ContentVec"
    echo:
    goto :loop2
)
goto :loop1

:loop2
echo 파일을 옮겼다면 "Y"를 입력한 후 엔터를 눌러주세요.
set /p YN2=
echo:
if /i "%YN2%" == "Y" (
    if exist %CD%\DDSP-SVC\pretrain\ContentVec\checkpoint_best_legacy_500.pt (
        echo 파일을 확인했습니다.
        goto :end
    ) else (
        echo 경로에 파일을 옮겼는지 확인해 주세요.
        goto :loop2
    )
)
goto :loop2
:end

@echo:

@echo !ESC![32mSetup Finished!!ESC![0m
pause