@ECHO OFF
chcp 65001 >nul
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)

SETLOCAL EnableDelayedExpansion

@echo ================================================
@echo 학습 모델을 만듭니다.
@echo 모델을 만들 폴더를 선택해 주세요.
@echo ================================================
@echo:

set "folder=voice-source-splited"
set "selected_folder="

:input
REM 폴더 목록 가져오기
set /a index=0
for /d %%d in ("%folder%\*") do (
    set /a index+=1
    set "folders[!index!]=%%~nd"
    echo !index!. %%~nd
)

echo:
set /p "choice=원하는 폴더 번호를 입력하세요 (또는 'q'를 입력하여 종료): "

if "%choice%"=="q" (
    echo 종료합니다.
    exit /b
)

if defined folders[%choice%] (
    set "selected_folder=!folders[%choice%]!"
    echo 선택한 폴더: !selected_folder!
    echo:

    cd DDSP-SVC
    call python -m venv .venv
    call .venv\Scripts\activate.bat
    cd ..

    call python script\move-audio-prepare.py !folder!/!selected_folder!

    cd DDSP-SVC
    call python draw.py
    call python preprocess.py -c configs/combsub.yaml

) else (
    echo 잘못된 입력입니다. 다시 선택하세요.
    echo:
    goto input
)

@echo !ESC![32m변환 완료!!ESC![0m
pause