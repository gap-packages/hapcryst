LoadPackage("hapcryst");

AlwaysPrintTracebackOnError:=true;
OnBreak := function() Where(6000); end;

TestDirectory(DirectoriesPackageLibrary( "hapcryst", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);
