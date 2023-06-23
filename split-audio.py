import os
import shutil
from pydub import AudioSegment
from pydub.silence import split_on_silence

input_folder = "voice-source"
output_folder = "voice-source-splited"
# 분할 길이 설정 (15초)
chunk_length_ms = 15 * 1000

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
        wav_path = os.path.join(target_folder_path, f"{wav_name}_1.wav")
        vocal_file = AudioSegment.from_wav(file_path)

        print(f"{target_folder_name}: {wav_name}: 작업 시작")
        if os.path.exists(wav_path):
            print(f"이미 작업된 파일\n")
            continue

        chunks = []
        start_time = 0
        end_time = chunk_length_ms

        while end_time < len(vocal_file):
            chunk = vocal_file[start_time:end_time]
            chunks.append(chunk)
            start_time += chunk_length_ms
            end_time += chunk_length_ms

        # 나머지 부분 따로 처리
        if start_time < len(vocal_file):
            last_chunk = vocal_file[start_time:]
            chunks.append(last_chunk)

        # 분할된 파일 저장
        for i, chunk in enumerate(chunks):
            output_file = os.path.join(target_folder_path, f"{wav_name}_{i + 1}.wav")
            chunk.export(output_file, format="wav")

        print("작업 완료\n")