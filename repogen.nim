import parsecfg, parseopt

import gorepository

import sqlgen

const version* = "0.1.0"

proc sqlCmd(): string =
  result = ""
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      result = key
    of cmdLongOption, cmdShortOption:
      case key
      of "input", "file", "i", "f": result = val
    of cmdEnd:
      quit "Please provide sql file path"


proc main =

  var
    cfg = loadConfig "config.cfg"
    svcname = cfg.getSectionValue("service-path", "service-name")
    basepath = cfg.getSectionValue("service-path", "base-path")
    sqlf = cfg.getSectionValue("sql", "file")

    inputsql = sqlCmd()

  if inputsql != "":
    sqlf = inputsql

  var sqltbls = sqlf.parseSql.parse.getTables
  for sqltable in sqltbls:
    #echo gorepository(sqltable, svcname, basepath)
    var f = (sqltable.name & ".go").open fmWrite
    f.write gorepository(sqltable, svcname, basepath, version = version)
    close f

main()
