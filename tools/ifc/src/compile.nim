import os, osproc, strutils
import gen_files

# ------------------------
# Compilar solo los cpp que le pases
# ------------------------
proc compileObjs(flags: seq[string], cppFilesToCompile: seq[string], compiler: string): seq[string] =
  var objs: seq[string] = @[]
  for cpp in cppFilesToCompile:
    if cpp.endsWith(".hpp"):
      continue
    let name = cpp.extractFilename.changeFileExt("")
    let objPath = objDir / (name & ".o")
    let cmd = @[compiler, "-c", cpp, "-o", objPath] & flags
    let res = execCmd(cmd.join(" "))
    if res != 0:
      quit("Error compilando " & cpp, QuitFailure)
    objs.add(objPath)  # recolectamos solo los objetos de esta compilación
  return objs

# ------------------------
# Linkear solo los objetos dados
# ------------------------
proc linkObjs(outName: string, objs: seq[string], compiler: string) =
  if objs.len == 0:
    quit("No hay objetos para linkear", QuitFailure)
  let linkCmd = @[compiler] & objs & @["-o", distDir / outName]
  let res = execCmd(linkCmd.join(" "))
  if res != 0:
    quit("Error linkeando", QuitFailure)

# ------------------------
# Función principal: compilar solo los archivos pasados y linkear solo sus objetos
# ------------------------
proc compileAll*(flags: seq[string], cppFilesToCompile: seq[string], outName: string = "app", compiler: string = "g++") =
  initDirs()
  let objs = compileObjs(flags, cppFilesToCompile, compiler)
  linkObjs(outName, objs, compiler)
