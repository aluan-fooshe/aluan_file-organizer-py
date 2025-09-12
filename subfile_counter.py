import os

# Write the name of the directory here,
# that needs to get sorted
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
            else:
                self.foldercount += 1
        print(f'In file path {file0}, there are\n{self.count} files')
        print(f'{self.foldercount} folders')

    def subfile_num(self, subfile):
        count1 = 0
        foldercount1 = 0
        AppleDouble = 0
        file0 = str(subfile)
        os.chdir(subfile)
        for path in os.scandir(subfile):
            if path.is_file():
                pathtxt = str(path)
                # indexed that way since the first ten spaces are occupied by:
                # [<DirEntry ']
                # [0123456789A]
                if pathtxt[11:13] == "._":
                    AppleDouble += 1
                elif pathtxt[11:20] == ".DS_Store":
                    print(f'\niOS file: {pathtxt[11:20]}')
                    continue
                else:
                    count1 += 1
            else:
                foldercount1 += 1
        print(f'In {file0}, there are'
              f'\n\t{count1} files'
              f'\n\t{AppleDouble} AppleDouble files'
              f'\n\t{foldercount1} folders')

    def subfile_total(self, subfile):
        self.count1 = 0
        file0 = str(subfile)
        os.chdir(subfile)
        for path in os.scandir(subfile):
            if path.is_file():
                print(path)
                self.count1 += 1
        return self.count1

if __name__ == "__main__":
    print("Type in file path:")
    f = Files(input(r''))

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
        else:
            path = os.path.join(f.path1, folders)
            #print(f"\n{path}")
            f.subfile_num(path)


#C:\Users\audre\Desktop\Vicky_s_Photos