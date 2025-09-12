import datetime
import os

path = input(r'')
file0 = 0

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
    else:
        file0 += 1

        res_files.append(file_)
        path1 = os.path.join(path, file1)

        # shows you which image the dates are from
        print(f"\n{file1}")

        # file modification
        timestamp = os.path.getmtime(path1)

        # convert timestamp into DateTime object
        datestamp = datetime.datetime.fromtimestamp(timestamp)
        print('\tModified Date/Time:', datestamp)

        # convert creation timestamp into string format
        datestamp_str = str(datestamp)

        print(f'\t\tIMG_{datestamp_str[0:4]}{datestamp_str[5:7]}{datestamp_str[8:10]}_'
              f'{datestamp_str[11:13]}{datestamp_str[14:16]}{datestamp_str[17:18]}'
              f'{datestamp_str[-2:-1]}')



        # file creation
        c_timestamp = os.path.getctime(path1)

        # convert creation timestamp into DateTime object
        c_datestamp = datetime.datetime.fromtimestamp(c_timestamp)

        print('\tCreated Date/Time on:', c_datestamp)

        # convert creation timestamp into string format
        c_datestamp_str = str(c_datestamp)

        print(f'\t\tIMG_{c_datestamp_str[0:4]}{c_datestamp_str[5:7]}{c_datestamp_str[8:10]}_'
              f'{c_datestamp_str[11:13]}{c_datestamp_str[14:16]}{c_datestamp_str[17:18]}'
              f'{c_datestamp_str[20:27]}')


print(f"\n\nIn {path} there are "
      f"\n\t{file0} files")

#C:\Users\audre\Desktop\random images