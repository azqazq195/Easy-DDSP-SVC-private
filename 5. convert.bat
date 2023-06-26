cd DDSP-SVC
call python -m venv .venv
call .venv\Scripts\activate.bat
cd ..

call python script/convert.py

pause