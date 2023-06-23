import os
from pydub import AudioSegment

# 입력 폴더 경로
input_folder = "voice/"

# 출력 폴더 경로
output_folder = "split-voice/"

# 분할 길이 설정 (15초)
chunk_length_ms = 15 * 1000

# 출력 폴더가 없으면 생성
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 입력 폴더의 모든 MP3 파일에 대해 분할 작업 수행
for filename in os.listdir(input_folder):
    if filename.endswith(".mp3"):
        # 보컬 파일 로드 (MP3 형식)
        vocal_file = AudioSegment.from_mp3(os.path.join(input_folder, filename))

        # 보컬 파일 분할
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
            output_file = os.path.join(output_folder, f"cut_{filename}_{i + 1}.mp3")
            chunk.export(output_file, format="mp3")
