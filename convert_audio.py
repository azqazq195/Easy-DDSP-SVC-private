import os
import shutil
from pydub import AudioSegment
from pydub.silence import split_on_silence

input_folder = "voice"
output_folder = "voice-source"

for dir_name, subdir_list, file_list in os.walk(input_folder):
    if dir_name == input_folder:
        continue

    target_folder_name = os.path.basename(dir_name)
    target_folder_path = os.path.join(output_folder, target_folder_name)

    print("======================")
    print(f"{target_folder_name}: 폴더 확인")
    print("======================")
    if not os.path.exists(target_folder_path):
        os.makedirs(target_folder_path)
        print("폴더 생성 완료\n")
    else:
        print("이미 존재하는 폴더\n")

    for file_name in file_list:
        if file_name == ".gitignore":
            continue

        file_path = os.path.join(dir_name, file_name)
        wav_name = os.path.splitext(file_name)[0]
        wav_path = os.path.join(target_folder_path, f"{wav_name}.wav")

        print(f"{wav_name}: 작업 시작")
        if os.path.exists(wav_path):
            print(f"이미 변환된 파일\n")
            continue

        audio = AudioSegment.from_file(file_path)
        audio = audio.set_frame_rate(44100)

        # silence_thresh 
        #   여운을 더 길게 남기려면 더 낮은 숫자 (ex: -60 등)
        #   더 짧게 자르려면 더 높은 숫자(ex: -40 등)
        segments = split_on_silence(audio, min_silence_len=1000, silence_thresh=-50)
        combined_audio = segments[0]
        for segment in segments[1:]:
            combined_audio += segment

        combined_audio.export(wav_path, format="wav")
        print("변환 완료\n")

