.onLoad <- function(libname, pkgname) {

  rJava::.jpackage(pkgname, jars = "*", lib.loc = libname)
  rJava::.jaddClassPath(
    list.files(
      system.file("java", package = "kafkaesquejars")
    )
  )

}
