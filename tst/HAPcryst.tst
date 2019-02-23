gap> START_TEST("HAPcryst test");
gap>  G:=SpaceGroup(3,165);
SpaceGroupOnRightBBNWZ( 3, 6, 1, 1, 4 )
gap>  SetInfoLevel(InfoHAPcryst,1);
gap>  PointGroupRepresentatives(G);
[ [ [ -1, -1, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 5/3, 1 ] ],
  [ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/2, 1 ] ],
  [ [ 0, -1, 0, 0 ], [ 1, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 5/6, 1 ] ],
  [ [ 0, 1, 0, 0 ], [ -1, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 4/3, 1 ] ],
  [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  [ [ 1, 1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 13/6, 1 ] ] ]
gap>  res:=ResolutionBieberbachGroup(G);
Resolution of length 4 in characteristic
0 for SpaceGroupOnRightBBNWZ( 3, 6, 1, 1, 4 ) .
No contracting homotopy available.

#
gap>  List([0..3],Dimension(res));
[ 2, 5, 4, 1 ]
gap> BoundaryOfGenerator_LargeGroupRep(res,2,1);
[ (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  (-1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  (-1)*[ [ 1, 1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/6, 1 ] ],
  <zero> of ...,
  (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ] ]
gap> res:=ResolutionBieberbachGroup(G,[1/2,1/3,1/5]);
Resolution of length 4 in characteristic
0 for SpaceGroupOnRightBBNWZ( 3, 6, 1, 1, 4 ) .
No contracting homotopy available.

#
gap> List([0..3],Dimension(res));
[ 9, 18, 10, 1 ]
gap> BoundaryOfGenerator_LargeGroupRep(res,2,1);
[ (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  (-1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ]+(
    -1)*[ [ 1, 1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/6, 1 ] ],
  (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  (-1)*[ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/2, 1 ] ],
  <zero> of ...,
  (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  (-1)*[ [ -1, -1, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 2/3, 1 ] ],
  <zero> of ...,
  (-1)*[ [ 1, 1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/6, 1 ] ],
  <zero> of ..., <zero> of ...,
  (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  <zero> of ...,
  (-1)*[ [ 1, 1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/6, 1 ] ],
  <zero> of ..., <zero> of ...,
  (1)*[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ],
  <zero> of ... ]
gap> res:=ResolutionBieberbachGroup(SpaceGroup(4,4));
Resolution of length 5 in characteristic
0 for SpaceGroupOnRightBBNWZ( 4, 2, 1, 1, 2 ) .
No contracting homotopy available.

#
gap> List([0..4],i->Homology(TensorWithIntegers(res),i));
[ [ 0 ], [ 2, 0, 0, 0 ], [ 2, 2, 0, 0, 0 ], [ 2, 0 ], [  ] ]
gap> List([0..4],i->Cohomology(HomToIntegers(res),i));
[ [ 0 ], [ 0, 0, 0 ], [ 2, 0, 0, 0 ], [ 2, 2, 0 ], [ 2 ] ]

#
gap> STOP_TEST("tst.g", 10000);
