import os

def check_order(directory):
    files = os.listdir(directory)
    sorted_files = sorted(files)
    if files != sorted_files:
        print("Files are not in alphabetical order.")
    else:
        print("Files are sorted alphabetically.")

check_order(".")
