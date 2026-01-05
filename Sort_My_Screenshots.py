# ----------------------------------------
# Name    : Audrey
# Note    : This makes a spreadsheet of all the screenshots in my Screenshots folder, before I turn them into a Canva
#           collage and trash the originals. It will show the amount of GB I removed and the date it was created.
#           Potentially stuff I can add to my future collage projects.
#
# Date Created : August 27, 2025 @2:01PM
# ----------------------------------------

# public library imports
import datetime
import sys
from openpyxl import Workbook
import os

if __name__ == "__main__":
    print(sys.executable)
    print(sys.path)

    now = datetime.datetime.now()
    formatted = now.strftime("%Y-%m-%d_%H%M%S")

    screenshots_wb = Workbook()
    ws = screenshots_wb.active
    ws.title = f"Screenshots {formatted}"

    """List everything that is in the Screenshots directory"""
    screenshots_folder = r"C:\Users\Audrey\OneDrive\Pictures\screenshot-collages"
    print(f"\nFiles in the directory: {screenshots_folder}\n")
    all_screenshots = os.listdir(screenshots_folder)
    all_screenshots = [f for f in all_screenshots if os.path.isfile(screenshots_folder+'/'+f)]
    print(*all_screenshots, sep="\n")

    print("\n", screenshots_wb.sheetnames)
    screenshots_wb.save('Screenshots.xlsx')