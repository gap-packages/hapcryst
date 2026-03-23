gap> START_TEST("Test for various former bugs");

#
# IsSquareMat used to return 'true' for all matrices
#
gap> IsSquareMat([[1]]);
true
gap> IsSquareMat([[1, 2]]);
false

#
# DimensionSquareMat
#
gap> DimensionSquareMat([[1,2,3],[1,2,3],[1,2,3]]);
3
gap> DimensionSquareMat([[1,2,3],[1,2,3]]);
fail
gap> DimensionSquareMat([[1,2],[1,2,3]]);
fail

#
# Let TranslationsToBox return a list again, instead of an iterator.
# See <https://github.com/gap-packages/hapcryst/issues/15>
#
gap> TranslationsToBox([0,0],[[1/2,2/3],[1/2,2/3]]);
[  ]
gap> TranslationsToBox([0,0],[[-3/2,1/2],[1,4/3]]);
[ [ -1, 1 ], [ 0, 1 ] ]
gap> TranslationsToBox([0,0],[[-3/2,1/2],[2,1]]);
Error, Box must not be empty

#
gap> S:=SpaceGroup(3,5);;
gap> p:=[4/3,5/3,7/3];;
gap> o:=OrbitStabilizerInUnitCubeOnRight(S,VectorModOne(p)).orbit;
[ [ 1/3, 2/3, 1/3 ], [ 1/3, 2/3, 2/3 ] ]
gap> box:=p+[[-1,1],[-1,1],[-1,1]];
[ [ 1/3, 8/3, 7/3 ], [ 1/3, 8/3, 7/3 ], [ 1/3, 8/3, 7/3 ] ]
gap> o2:=Concatenation(List(o,i->i+TranslationsToBox(i,box)));;
gap> Size(o2);
54

#
gap> STOP_TEST( "bugfix.tst" );
