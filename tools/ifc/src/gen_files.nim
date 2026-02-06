import os

# ------------------------
# Configuración de rutas
# ------------------------
const
  cacheDir* = "dist/cpp"
  distDir*  = "dist"
  objDir*   = "dist/obj"

# ------------------------
# Crear carpeta si no existe
# ------------------------
proc initDirs*() =
  for path in @[cacheDir, objDir, distDir]:
    if not dirExists(path):
      createDir(path)

# ------------------------
# Generar archivo .cpp solo si no existe
# ------------------------
proc genCppFile*(name, code: string, hpp: bool = false):string =
  var ext: string
  if hpp: ext = ".hpp"
  else: ext = ".cpp"
  let path = cacheDir / (name & ext)
  writeFile(path, code)
  return path
