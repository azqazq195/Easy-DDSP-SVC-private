import os
import shutil
import subprocess
import sys
from pydub import AudioSegment

convert_path = "convert"
vocal_file_name = "vocal"
instruments_file_name = "instruments"

exp_path =  os.path.join("DDSP-SVC", "exp")
trans_file = "vocal_trans.wav"
vocal_file_target_path = os.path.join(exp_path, "vocal.wav")
trans_file_path = os.path.join(exp_path, trans_file)

models_path = "models"
model_extension = ".pt"
model_folder_path = os.path.join(exp_path, "combsub-test")
model_file_path = os.path.join(model_folder_path, "model.pt")

def remove_file(file_path):
    if os.path.exists(file_path):
        os.remove(file_path)

def remove_old_files():
    remove_file(trans_file_path)
    remove_file(model_file_path)
    for file in get_files(convert_path, ".wav"):
        file_path = os.path.join(convert_path, file)
        remove_file(file_path)

def setup_model():
    models = get_files(models_path, ".pt")

    # 파일이 없을 경우 종료
    if len(models) == 0:
        print("models 폴더에 모델 파일이 없습니다.")
        sys.exit()
    
    # 파일 목록 출력
    prompt = "모델 목록:\n"
    prompt_lines = [f"{i+1}. {model_name}\n" for i, model_name in enumerate(models)]
    prompt = "".join([prompt] + prompt_lines)
    print(prompt)

    # 파일 선택
    while True:
        try:
            choice = int(input("적용할 모델 번호를 입력해 주세요:\n"))
            if 1 <= choice <= len(models):
                selected_file = models[choice - 1]
                selected_file_path = os.path.join(models_path, selected_file)
                copy(selected_file_path, model_file_path)
                print()

                return
            raise ValueError
        except ValueError:
            print("목록의 숫자를 입력해 주세요.\n")

def copy(from_path, to_path):
    shutil.copy(from_path, to_path)

def move(from_path, to_path):
    shutil.move(from_path, to_path)

def get_files(dir_path, extension=None):
    files = []
    for file in os.listdir(dir_path):
        if file == ".gitignore":
            continue

        file_path = os.path.join(dir_path, file)
        if os.path.isfile(file_path) and (extension is None or file.endswith(extension)):
            files.append(file)

    return files

def get_dirs(dir_path):
    dirs = []
    for file in os.listdir(dir_path):
        if file == ".gitignore":
            continue

        path = os.path.join(dir_path, file)
        if os.path.isdir(path):
            dirs.append(file)

    return dirs

def get_file(dir_path, file_name):
    for file in os.listdir(dir_path):
        if (os.path.splitext(file)[0] == file_name):
            return file
    return None

def convert_audio(from_path, to_path, fram_rate=44100, format="wav"):
    audio = AudioSegment.from_file(from_path)
    audio = audio.set_frame_rate(fram_rate)
    audio.export(to_path, format=format)

def setup_files(dir_path):
    vocal_file = get_file(dir_path, vocal_file_name)
    instruments_file = get_file(dir_path, instruments_file_name)

    if vocal_file is None:
        print(f"{dir_path}에 {vocal_file_name}아 존재하지 않습니다.\n")
        return False
    
    if instruments_file is None:
        print(f"{dir_path}에 {instruments_file_name}아 존재하지 않습니다.\n")
        return False
    
    vocal_file_path = os.path.join(dir_path, vocal_file)
    convert_audio(vocal_file_path, vocal_file_target_path)
    
    return True

def convert():
    vocal = os.path.relpath(vocal_file_target_path, "DDSP-SVC")
    model = os.path.relpath(model_file_path, "DDSP-SVC")
    trans = os.path.relpath(trans_file_path, "DDSP-SVC")

    os.chdir(f"{os.getcwd()}/DDSP-SVC")
    command = f'python main.py -i "{vocal}" -m "{model}" -o "{trans}" -k 0 -id 1 -eak 0'
    completed_process = subprocess.run(command, shell=True)
    os.chdir("..")

    return completed_process.returncode == 0

def merge(dir_path, filename):
    instruments_file = get_file(dir_path, instruments_file_name)
    instruments_file_path = os.path.join(dir_path, instruments_file)

    vocal = AudioSegment.from_file(trans_file_path)
    instruments = AudioSegment.from_file(instruments_file_path)
    instruments.set_frame_rate(44100)

    combined = instruments.overlay(vocal)
    combined.export(os.path.join(convert_path, f'{filename}.wav'), format='wav')

if __name__ == "__main__":
    print("========================================================")
    print("convert 폴더의 결과 파일들은 모두 지워지며 새로 만들어 집니다.")
    print("보관이 필요한 경우 '보관함'에 이동시키거나 별도로 보관해 주세요.")
    print("========================================================\n")

    remove_old_files()
    setup_model()

    # convert 폴더 하위의 노래 폴더들의 작업 시작
    dirs = get_dirs(convert_path)
    for file in dirs:
        print(f"[{file}] 작업 시작\n")
        dir_path = os.path.join(convert_path, file)
        if not setup_files(dir_path):
            print("\n필요한 파일이 준비되지 않아 스킵합니다.")
            continue

        if not convert():
            print("\n변환중 오류가 발생하여 스킵합니다.")
            continue

        merge(dir_path, file)
        print(f"\n[{file}] 작업 완료\n")

    print("\n========================================================")
    print("작업 완료.")
    print("========================================================\n")