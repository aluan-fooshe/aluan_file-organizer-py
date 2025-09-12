import os

# Write the name of the directory here,
# that needs to get sorted
path = input(r'')
os.chdir(path)
# This will create a properly organized
# list with all the filename that is
# there in the directory
list_ = os.listdir(path)
# first folder to count files in
AppleDouble = 0
file0 = 0
for file_ in list_:
    # This excludes any file formats from MacOS or Apple's operating system
    # This if statement is an AppleDouble Format
    #       This format is to prevent loss of a file's metadata when it is moved
    #       from the macOS system to other file systems
    if file_[0:2] == "._":
        AppleDouble += 1
    elif file_[0] == ".":
       continue
    else:
        file0 += 1
print(f"In {path} there are "
      f"\n\t{file0} files"
      f"\n\t{AppleDouble} AppleDouble files")