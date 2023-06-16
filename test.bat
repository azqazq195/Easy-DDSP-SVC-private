
@REM set "filename=ffmpeg-6.0-full_build.zip"
@REM curl -L -o "%filename%" https://github.com/GyanD/codexffmpeg/releases/download/6.0/%filename%
@REM powershell -Command "Expand-Archive -Path %filename% -DestinationPath .\ -Force"
@REM del %filename%

@echo OFF

powershell -Command "$currentPath = Get-Location; $existingPath = [Environment]::GetEnvironmentVariable('PATH', 'User'); $newPath = $existingPath + ';'+ $currentPath + '\ffmpeg-6.0-full_build\bin'; [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')"

pause
