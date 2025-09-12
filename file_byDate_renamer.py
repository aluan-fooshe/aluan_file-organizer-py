import datetime
import os

path = input(r'')

file0 = 0

# This goes through every existing file in the specified folder path
list_ = os.listdir(path)
res_files = []
for file_ in list_:
    file1 = file_
    # This excludes any file formats from MacOS or Apple's operating system
    # This if statement is an AppleDouble Format
    #       This format is to prevent loss of a file's metadata when it is moved
    #       from the macOS system to other file systems
    if file1[0:2] == "._":
        print(f"iOS file: {file1}")
        continue
    # This excludes files related to the Apple Desktop Services Store.
    elif file1[0] == ".":
        print(f"iOS file: {file1}")
        continue
    # everything visible to any viewers looking at that file path will be counted
    # and added to the list.
    else:
        file0 += 1

        res_files.append(file_)

# An array for all original names of the renamed files
L = []



###
for file in res_files:
    # displays the path and the current file being renamed.
    curr_file = str(file)
    print(path)
    print(curr_file)

    # takes record of the file's original name before its changed.
    L.append(curr_file)



    # file format gets altered into this common naming convention:
    #   IMG_20240502_225546_696
    #   IMG_YYYYMMDD_HHMMSS_nnn
    # Displays the file name before it's been changed.
    path_bef = os.path.join(path, curr_file)

    # obtains timestamp for the file before the name is changed.
    c_timestamp = os.path.getctime(path_bef)

    # convert creation timestamp into DateTime object
    c_datestamp = datetime.datetime.fromtimestamp(c_timestamp)
    print('\tCreated Date/Time on:', c_datestamp)

    # convert creation timestamp into string format
    c_datestamp_str = str(c_datestamp)
    alt_name = f"IMG_{c_datestamp_str[0:4]}{c_datestamp_str[5:7]}{c_datestamp_str[8:10]}_{c_datestamp_str[11:13]}{c_datestamp_str[14:16]}{c_datestamp_str[17:18]}{c_datestamp_str[20:27]}"

    # Displays the file name after it's been changed.
    if curr_file[-5:-1]+curr_file[-1] == '.heic':
        path_aft = os.path.join(path, f'{alt_name}{curr_file[-5:-1]}{curr_file[-1]}')
    else:
        path_aft = os.path.join(path, f'{alt_name}{curr_file[-4:-1]}{curr_file[-1]}')

    print(f"\n\tBefore Renaming: {path_bef}")
    os.rename(path_bef, path_aft)
    print(f"\tAfter Renaming: {path_aft}")
###



# opens text file to store the file's original name before its changed.
orig_file_names = open("orig_file_names.txt", "w")

# \n is placed to indicate EOL (End of Line)
for lines in L:
    orig_file_names.write(f"{lines}\n")
orig_file_names.close()  # to change file access modes

orig_file_names = open("orig_file_names.txt", "r+")

print("\n\n----Contents in text file: ----")
print(f"{orig_file_names.read()}")
print()

#C:\Users\audre\Desktop\random images