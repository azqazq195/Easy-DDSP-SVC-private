import os
import shutil
import subprocess
from pydub import AudioSegment

def move_file():
    input_folder = "convert"
    output_folder = "DDSP-SVC/exp"

    # 파일 개수 확인
    vocal_file = None
    instruments_file = None
    for file in os.listdir(input_folder):
        if file == ".gitignore":
            continue

        if os.path.splitext(file)[0] == "vocal":
            vocal_file = file
            continue

        if os.path.splitext(file)[0] == "instruments":
            instruments_file = file
            continue

        # 기존 파일 제거
        if file == "vocal_trans.wav" or file == "result.wav":
            os.remove(os.path.join(input_folder, file))

    if vocal_file is None or instruments_file is None:
        print("경고: vocal 파일이나 instruments 파일이 없습니다.")
        exit()

    # 기존 파일 삭제
    for root, dirs, files in os.walk(output_folder):
        for file in files:
            if file != "vocal.wav" or file != "vocal_trans.wav":
                continue
            file_path = os.path.join(root, file)
            os.remove(file_path)

    # 파일 복사
    file_path = os.path.join(input_folder, vocal_file)
    wav_path = os.path.join(output_folder, "vocal.wav")

    audio = AudioSegment.from_file(file_path)
    audio = audio.set_frame_rate(44100)
    audio.export(wav_path, format="wav")

def select_and_move_model():
    models_folder = "models"
    output_folder = "DDSP-SVC/exp/combsub-test"
    file_extension = ".pt"

    # 파일 목록 가져오기
    files = []
    for file_name in os.listdir(models_folder):
        if file_name != ".gitignore" and file_name.endswith(file_extension):
            files.append(file_name)

    # 파일이 없을 경우 종료
    if len(files) == 0:
        print("모델 폴더에 파일이 없습니다.")
        sys.exit()

    # 파일 목록 출력
    print("모델 목록:")
    for i, file_name in enumerate(files):
        print(f"{i+1}. {file_name}")
    print()

    # 사용자 선택
    while True:
        try:
            choice = int(input("적용할 모델 번호를 입력해 주세요:\n"))
            if 1 <= choice <= len(files):
                selected_file = files[choice - 1]
                source_file_path = os.path.join(models_folder, selected_file)
                destination_file_path = os.path.join(output_folder, "model.pt")
                
                if os.path.exists(destination_file_path):
                    os.remove(destination_file_path)

                shutil.copy(source_file_path, destination_file_path)
                break
            else:
                print("목록의 숫자를 입력해 주세요.\n")
        except ValueError:
            print("목록의 숫자를 입력해 주세요\n")

def convert():
    os.chdir(f"{os.getcwd()}/DDSP-SVC")
    command = 'python main.py -i "exp\\vocal.wav" -m "exp\\combsub-test\\model.pt" -o "exp\\vocal_trans.wav" -k 0 -id 1 -eak 0'
    subprocess.run(command, shell=True)
    os.chdir("..")

def move_result():
    source_file = 'DDSP-SVC\\exp\\vocal_trans.wav'
    destination_folder = 'convert'

    shutil.move(source_file, destination_folder)

def merge():
    print(os.getcwd())
    input_folder = "convert"
    vocal_file = AudioSegment.from_file(os.path.join(input_folder, 'vocal_trans.wav'))
    instruments_file = AudioSegment.from_file(os.path.join(input_folder, 'instruments.mp3'))
    instruments_file = instruments_file.set_frame_rate(44100)

    combined = instruments_file.overlay(vocal_file)

    combined.export(os.path.join(input_folder, 'result.wav'), format='wav')

if __name__ == "__main__":
    move_file()
    select_and_move_model()
    convert()
    move_result()
    merge()