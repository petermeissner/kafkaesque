.onLoad <- function(libname, pkgname) {

  # let rJava find right Java version on its own
  if ( grepl( "^i386", utils::sessionInfo()$platform) ){
    Sys.setenv(
      JAVA_HOME =
        tail(
          list.files("C:/Program Files (x86)/Java", full.names = TRUE),
          1
        )
    )
  } else {
    Sys.setenv(JAVA_HOME = "")
  }

  rJava::.jpackage(pkgname, jars = "*", lib.loc = libname)
  rJava::.jaddClassPath(
    list.files(
      system.file("java", package = pkgname)
    )
  )

}
