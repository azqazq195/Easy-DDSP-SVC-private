@ECHO OFF
chcp 65001 >nul
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)

@echo batch size를 지정합니다.
@echo vram 사용량을 확인하여 8 ~ 128 사이의 값으로 조정해 주세요.


:input_batch_size
@set /p batch_size=batch size 값 입력 후 엔터: 

@echo %batch_size%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo 숫자만 입력해 주세요.
    goto input_batch_size
)

cd DDSP-SVC
call python -m venv .venv
call .venv\Scripts\activate.bat
cd ..

call python script\update-config.py %batch_size%

cd DDSP-SVC
call python train.py -c configs/combsub.yaml

pause