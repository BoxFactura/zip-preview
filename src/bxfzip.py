import argparse
import os
import pyzipper
import sys

def bxfzip(source_folder, destination_zip_file):
    with pyzipper.AESZipFile(destination_zip_file, 'w', compression=pyzipper.ZIP_DEFLATED) as zip_file:
        for root, _, files in os.walk(source_folder):
            for file in files:
                full_path = os.path.join(root, file)
                relative_path = os.path.relpath(full_path, source_folder)
                zip_file.write(full_path, relative_path)

def main():
    parser = argparse.ArgumentParser(description="Compress a folder into a zip archive with AES encryption.")
    parser.add_argument('-z', '--zip', required=True, type=str, help='Destination zip file path')
    parser.add_argument('-p', '--path', required=True, type=str, help='Source folder path to compress')
    parser.add_argument('--debug', action='store_true', help='Enable debug output')
    args = parser.parse_args()

    zip_filename = args.zip
    folder_path = args.path

    if not os.path.isdir(folder_path):
        print(f"Error: The provided folder path '{folder_path}' does not exist or is not a directory.", file=sys.stderr)
        exit(1)

    try:
        bxfzip(folder_path, zip_filename)
        if args.debug:
        print(f"Successfully compressed '{folder_path}' into '{zip_filename}'")
    except Exception as e:
        print(f"An error occurred during compression: {e}", file=sys.stderr)
        exit(1)

if __name__ == "__main__":
    main()
