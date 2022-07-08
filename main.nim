# This is a quick/dirty script to compress/encrypt or decrypt/expand some directory
# TODO: add checks to skip compression if src is just a file
#   make sure to remove trailing / for directories!
#   also ensure that you can handle things like ./../ or absolute paths, or $VARS
# Should I keep the intermediate .tgz files?
import std/strformat
import os

# Decrypts a .gpg file and extracts the .tgz output to a new directory
proc decrypt(args: seq[string]) = 
  let src = args[0]
  let dst = src[0 ..< ^4]
  discard execShellCmd fmt"gpg --output {dst} --decrypt {src}"
  discard execShellCmd fmt"tar -xzvf {dst}"

# Compress a directory to .tgz and encrypt to .gpg file
# TODO: add --recipient flag and prompt user if none is provided
# Alternatively, allow the user to configure a persistent "permanent"
proc encrypt(args: seq[string]) = 
  let src = args[0]
  discard execShellCmd fmt"tar -czvf {src}.tgz {src}"
  discard execShellCmd fmt"gpg --encrypt --recipient realdude {src}.tgz"

proc compress(args: seq[string]) =
  let src = args[0]
  discard execShellCmd fmt"tar -czvf {src}.tgz {src}"

when isMainModule:
  # let src = commandLineParams()[0]
  # let dst = src[0 ..< ^4]
  # echo fmt"  source file is: {src}"
  # echo fmt"    dest file is: {dst}"
  # encrypt src
  # decrypt src, dst
  # discard execShellCmd fmt"tar -tzvf {dst}"
  import cligen
  dispatchMulti(
    [decrypt],
    [encrypt],
    [compress],
  )
