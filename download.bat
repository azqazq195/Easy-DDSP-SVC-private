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