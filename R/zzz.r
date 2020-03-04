.onLoad <-
  function(libname, pkgname) {
    rJava::.jpackage(pkgname, jars = "*", lib.loc = libname)
    #rJava::J("java.util.logging.LogManager")$getLogManager()$reset()
  }
