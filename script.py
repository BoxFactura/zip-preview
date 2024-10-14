import argparse
import os
import pyzipper

def comprimir_carpeta(carpeta_origen, archivo_zip_destino):
    with pyzipper.AESZipFile(archivo_zip_destino, 'a', compression=pyzipper.ZIP_DEFLATED) as zip_file:
        for carpeta_raiz, _, archivos in os.walk(carpeta_origen):
            for archivo in archivos:
                ruta_completa = os.path.join(carpeta_raiz, archivo)
                ruta_relativa = os.path.relpath(ruta_completa, carpeta_origen)
                zip_file.write(ruta_completa, ruta_relativa)

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('-z', '--zip', type=str, help='Archivo zip a escribir')
  parser.add_argument('-p', '--path', type=str, help='Ruta de archivos a comprimir')
  args = parser.parse_args()

  zip_filename = args.zip
  folder_path = args.path

  print(f"zip: {zip_filename}, folder: {folder_path}")
  comprimir_carpeta(folder_path, zip_filename)
