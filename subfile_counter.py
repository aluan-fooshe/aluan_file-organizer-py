import os
from pathlib import Path

# Write the name of the directory here that needs to get sorted
class Files:
    def __init__(self, path1):
        self.path1 = path1

    def list_folders(self):
        list_ = os.listdir(self.path1)
        self.res_files = []
        for file_ in list_:
            self.res_files.append(file_)
            self.file1 = file_
        return self.res_files
    def print_res_files(self):
        for folders in self.res_files:
            print(folders)
    def file_num(self):
        self.count = 0
        self.foldercount = 0
        file0 = str(self.path1)
        os.chdir(self.path1)
        for path in os.scandir(self.path1):
            if path.is_file():
                self.count += 1
            elif path.is_dir():
                self.foldercount += 1
            else:
                continue
        print(f'In file path {file0}, there are\n{self.count} files')
        print(f'{self.foldercount} folders')

    def subfile_num(self, subfile):
        filecount1 = 0
        directorycount1 = 0
        AppleDouble = 0
        SupplementalFiles = 0
        file0 = str(subfile)
        os.chdir(subfile)
        for path in os.scandir(subfile):
            if path.is_file():
                pathtxt = str(path)
                p = Path(pathtxt)
                """
                indexed that way since the first ten spaces are occupied by:
                [<DirEntry ']
                [0123456789A]
                """
                if pathtxt[11:13] == "._":
                    AppleDouble += 1
                elif pathtxt[11:20] == ".DS_Store":
                    print(f'\niOS file: {pathtxt[11:20]}')
                    continue
                elif p.suffix == ".json'>":
                    SupplementalFiles += 1
                else:
                    filecount1 += 1
            elif path.is_dir():
                directorycount1 += 1
            else:
                continue
        print(f'In {file0}, '
              f'\nthere are a total of {filecount1 + AppleDouble + SupplementalFiles + directorycount1} items'
              f'\n\t{filecount1} files'
              f'\n\t{AppleDouble} AppleDouble files'
              f'\n\t{SupplementalFiles} JSON files'
              f'\n\t{directorycount1} directories')

    def subfile_total(self, subfile):
        self.count1 = 0
        os.chdir(subfile)
        for path in os.scandir(subfile):
            if path.is_file():
                print(path)
                self.count1 += 1
        return self.count1

if __name__ == "__main__":
    # print("Type in file path:")
    # f = Files(input(r''))
    path = r'C:\Users\Audrey\OneDrive\Pictures\Vickys_Photos-backup\google takeout 8-6-25'
    f = Files(path)

    f.file_num()
    f.list_folders()
    print("\n")
    for folders in f.res_files:
        # This excludes any file formats from MacOS or Apple's operating system
        # This if statement is an AppleDouble Format
        #       This format is to prevent loss of a file's metadata when it is moved
        #       from the macOS system to other file systems
        if folders[0:2] == "._":
            print(f"iOS file: {folders}")
            continue
        # This excludes files related to the Apple Desktop Services Store.
        elif folders[0] == ".":
            print(f"iOS file: {folders}")
            continue
        elif folders[-5:] == ".json":
            path = os.path.join(f.path1, folders)
            print(f"{folders}")
        else:
            path = os.path.join(f.path1, folders)
            f.subfile_num(path)

        print("\n")


#C:\Users\audre\Desktop\Vicky_s_Photos