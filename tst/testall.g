LoadPackage("hapcryst");

TestDirectory(DirectoriesPackageLibrary( "hapcryst", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);
