import strutils

proc funcLogError*(where: string, what = "err"): string =
  """level.Error(r.logger).Log("function", "$#", "Error", $#)""" % [where, what]
