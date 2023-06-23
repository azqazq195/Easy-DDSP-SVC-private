import os
import shutil
import sys

input_folder = sys.argv[1]
output_folder = "DDSP-SVC/data/train/audio"

# 기존 파일 삭제
for root, dirs, files in os.walk(output_folder):
    for file in files:
        if file == ".gitignore":
            continue
        file_path = os.path.join(root, file)
        os.remove(file_path)

for root, dirs, files in os.walk("DDSP-SVC\\data\\val\\audio"):
    for file in files:
        if file == ".gitignore":
            continue
        file_path = os.path.join(root, file)
        os.remove(file_path)

# 파일 복사
for root, dirs, files in os.walk(input_folder):
    for file in files:
        if file == ".gitignore":
            continue
        src_file = os.path.join(root, file)
        dst_file = os.path.join(output_folder, file)
        shutil.copy2(src_file, dst_file)
