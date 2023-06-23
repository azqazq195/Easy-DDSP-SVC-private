@echo OFF
cd DDSP-SVC
call python -m venv .venv
call .venv\Scripts\activate.bat
call python -m pip install --upgrade pip
call pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
call pip install -r requirements.txt
call pip install pydub