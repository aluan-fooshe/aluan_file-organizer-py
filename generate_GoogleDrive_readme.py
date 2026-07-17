#generate_GoogleDrive_readme.py

import pickle
import os
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from tabulate import tabulate

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/drive.metadata.readonly']

def get_gdrive_service():
    creds = None
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)
    return build('drive', 'v3', credentials=creds)

def list_files(service, items, output_file="README.md"):
    """given items returned by Google Drive API, writes them as a Markdown table to a README file"""
    header = (
        "# README\n"
        "### generate_GoogleDrive_readme.py\n"
        "<b>Author:</b> Audrey Luan\n"
        "<br><b>Date:</b> 2026 June 19 09:14AM\n"
        "### Sources\n"
        "https://thepythoncode.com/article/using-google-drive--api-in-python\n"
        "\n---\n"
    )

    if not items:
        content = header + "# Google Drive Files\n\nNo files found.\n"
    else:
        rows = []
        parent_name_cache = {}  # folder_id -> folder_name, avoids repeat lookups

        for item in items:
            id = item["id"]
            name = item["name"]
            try:
                parent_ids = item.get("parents", [])
                if parent_ids:
                    parent_id = parent_ids[0]  # take the first parent
                    if parent_id not in parent_name_cache:
                        parent_info = service.files().get(
                            fileId=parent_id,
                            fields="name"
                        ).execute()
                        parent_name_cache[parent_id] = parent_info.get("name", "N/A")
                    parents = parent_name_cache[parent_id]
                else:
                    parents = "N/A"
            except Exception as e:
                parents = "N/A"
            try:
                size = get_size_format(int(item["size"]))
            except:
                size = "N/A"
            mime_type = item["mimeType"]
            created_time = item["createdTime"]
            modified_time = item["modifiedTime"]
            rows.append((id, name, parents, size, mime_type, created_time, modified_time))

        # tablefmt="github" produces GitHub-flavored Markdown table syntax
        table = tabulate(
            rows,
            headers=["ID", "Name", "Parents", "Size", "Type", "Created Time", "Modified Time"],
            showindex=range(1, len(rows) + 1),
            tablefmt="github"
        )
        content = header + f"# Google Drive Files\n\n{table}\n"

    # write to README.md
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Wrote {len(items)} file(s) to {output_file}")

def get_size_format(b, factor=1024, suffix="B"):
    """
    Scale bytes to its proper byte format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    for unit in ["", "K", "M", "G", "T", "P", "E", "Z"]:
        if b < factor:
            return f"{b:.2f}{unit}{suffix}"
        b /= factor
    return f"{b:.2f}Y{suffix}"

def main():
    """Shows basic usage of the Drive v3 API.
    Writes a Markdown table of matching files to README.md.
    """
    service = get_gdrive_service()

    all_items = []
    page_token = None

    while True:
        results = service.files().list(
            pageSize=150,
            q="'me' in owners and trashed = false and createdTime >= '2021-01-01T00:00:00' and createdTime < '2022-09-01T00:00:00'",
            orderBy="createdTime",
            fields="nextPageToken, files(id, name, mimeType, size, parents, createdTime, modifiedTime)",
            pageToken=page_token
        ).execute()

        items = results.get('files', [])
        all_items.extend(items)

        page_token = results.get('nextPageToken')
        if not page_token:
            break

    list_files(service, all_items)


if __name__ == '__main__':
    main()