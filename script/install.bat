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


@echo Python 이 설치되었는지 확인합니다.
winget list --name "python">nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    @echo Python 이 설치되지 않았습니다. !ESC![32m설치중...!ESC![0m
    winget install -e --id Python.Python.3.9
) else (
    @echo Python 이 설치되었습니다. !ESC![32m생략...!ESC![0m
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

@echo Visual Studio 에서 추가 파일을 다운로드 받습니다.
@echo 오픈되는 인스톨러 창에서 수정(우측 하단) 버튼을 눌러주세요.
@echo 설치가 완료되면 인스톨러 창을 종료해 주세요.
@echo:
:loop
@echo 준비되었다면 "Y" 입력 후 엔터
@set /p YN=
@echo:
if /i "%YN%" == "y" (
    "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" --add Microsoft.VisualStudio.Component.Windows11SDK.22000  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.ASAN
    goto :end
)
goto :loop
:end