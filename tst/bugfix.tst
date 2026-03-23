gap> START_TEST("Test for various former bugs");

# IsSquareMat used to return 'true' for all matrices
gap> IsSquareMat([[1]]);
true
gap> IsSquareMat([[1, 2]]);
false

#
gap> STOP_TEST( "bugfix.tst" );
