# (C)2007-2008 by Marc Roeder,
#   distribute under the terms of the GPL version 2.0 or later
    
    
############################################################################# 
## This file provides functions to generate fundamental domains for 
## 3 dimensional Bieberbach groups and view them as colored polytopes in 
## JavaView.
##
## The functions you might want to use are in 3dimBieberbachFD.gap
## Look there first.
#############################################################################


#############################################################################
##
## A square root approximation using continued fractions.
##  Used for the Cholesky decomposition.
    

    sqrt:=function(rat)
        local   x,denom,  num;
        denom:=DenominatorRat(rat);
        num:=NumeratorRat(rat);
        x:=Indeterminate(Rationals);
        return ContinuedFractionApproximationOfRoot(denom*x^2-num,100);
    end;


#############################################################################
## 
## A quick and dirty implementation of a Cholesky decomposition (approximation)
## 

CholeskyDecomposition:=function(mat)
    local   dim, L,  line,x,  col;
    
    if not mat=TransposedMat(mat)
       then
        Error("matrix is not symmetric");
    fi;
    dim:=DimensionSquareMat(mat);
    if not ForAll([1..dim],d->Determinant(mat{[1..d]}{[1..d]})>0)
       then
        Error("matrix is not positive definite");
    fi;
    L:=NullMat(dim,dim);
    L[1][1]:=sqrt(mat[1][1]);
    for line in [1..dim]
      do
        for col in [1..line-1]
          do
            if col>1 
               then
                L[line][col]:=(mat[line][col]-(L[line]{[1..col-1]}*L[col]{[1..col-1]}))/L[col][col];
            else
                L[line][col]:=mat[line][col]/L[col][col];
            fi;
            if line>1 
               then
                L[line][line]:=sqrt(mat[line][line]-L[line]{[1..line-1]}^2);
            fi;
        od;
    od;
    return L;
end;



#############################################################################
## convert hsv color space to rgb color space.
## hsv is a triple [h,s,v] where 
## h\in [0..259], s,v\in[0..255].
##
hsv2rgb:=function(hsv)
    local   H,  S,  V,  Hi,  f,  p,  q,  t,  rgb;

    H:=hsv[1];
    S:=1/256*hsv[2];
    V:=1/256*hsv[3];
    Hi:=Int(H/60) mod 6;
    f:=H/60-Hi;
    p:=V*(1-S);
    q:=V*(1-f*S);
    t:=V*(1-(1-f)*S);
    if Hi=0
       then
        rgb:=[V,t,p];
    elif Hi=1
      then
        rgb:= [q,V,p];
    elif Hi=2
      then
        rgb:= [p,V,t];
    elif Hi=3
      then
        rgb:= [p,q,V];
    elif Hi=4
      then 
        rgb:= [t,p,V];
    elif Hi=5
      then
        rgb:= [V,p,q];
    else
        Error("bad programming, Marc");
    fi;
    return List(rgb*256,Int);
end;

#############################################################################
## create a list of length n which contains strings of the form
##  "xxx yyy zzz" representing a point in rgb-colorspace.
##
ncolorStrings:=function(n)
    local   colorlist,  Hvalues,  color,  rem,  H,  S,  V;
    
    if n<=10
       then
        colorlist:=List([0..n-1]*360/n,i->[Int(i),255,255]);
    else
        colorlist:=[];
        Hvalues:=Reversed([0..Int(n/3)+1]*360/(Int(n/3)+1));
        for color in [1..n]
          do
#                        H:=(360/(Int(n/4)+1))*Int(color/4);
            rem:=(color-1) mod 3;
            if rem=0
               then
                H:=Remove(Hvalues);
                S:=255;
                V:=255;
            elif rem=1
              then
                S:=127;
                V:=255;
            else
                S:=255;
                V:=127;
            fi;
           Add(colorlist,[H,S,V]);
        od;
    fi;
    Apply(colorlist,hsv2rgb);
    Apply(colorlist,c->List(c,String));
    Apply(colorlist,c->JoinStringsWithSeparator(c," "));
    return colorlist;
end;


##########################
## the same, returning a slightly paler set of colors.
##
ncolorStringsPale:=function(n)
    local   colorlist,  Hvalues,  color,  rem,  H,  S,  V;
    
    if n<=10
       then
        colorlist:=List([0..n-1]*360/n,i->[Int(i),180,200]);
    else
        colorlist:=[];
        Hvalues:=Reversed([0..Int(n/3)+1]*360/(Int(n/3)+1));
        for color in [1..n]
          do
            #            H:=(360/(Int(n/4)+1))*Int(color/4);
            rem:=(color-1) mod 3;
            if rem=0
               then
                H:=Remove(Hvalues);
                S:=127;
                V:=255;
            elif rem=1
              then
                S:=64;
                V:=255;
            else
                S:=127;
                V:=127;
            fi;
            Add(colorlist,[H,S,V]);
        od;
    fi;
    Apply(colorlist,hsv2rgb);
    Apply(colorlist,c->List(c,String));
    Apply(colorlist,c->JoinStringsWithSeparator(c," "));
    return colorlist;
end;



#############################################################################
## Convert a rational number into a "floating point" string.
## <precision> gives the number of digits after the first non-zero 
## digit after the point.
## Example with precision=3: 1/7 is converted to "0.142"
##                            1/700 is converted to "0.00142"
##

fraction2floatString:=function(q,precision)
    local   sign,  signString,  magnitude,  beforepoint,  qright,  
            prezeros,  afterpoint,  returnstring;
    
    if q=0
       then
        return "0";
    fi;
    sign:=SignRat(q);
    if sign=-1
       then
        signString:="-";
    else
        signString:="";
    fi;
    
    if AbsoluteValue(q)>0
       then
        beforepoint:=String(sign*Int(q));
        qright:=sign*(q-Int(q));
    else 
        qright:=sign*q;
        beforepoint:="0";
    fi;
    
    if qright<>0
       then
        magnitude:=LogInt(NumeratorRat(qright),10)-LogInt(DenominatorRat(qright),10);
        if AbsoluteValue(qright)*10^(-magnitude)<1
           then
            magnitude:=magnitude-1;
        fi;
        prezeros:=Concatenation(List([1..-magnitude-1],i->"0"));
        afterpoint:=String(Int(10^(precision-magnitude)*qright));
        returnstring:=Concatenation([signString,beforepoint,".",prezeros,afterpoint]);
    else
        returnstring:=Concatenation(signString,beforepoint,".0");
    fi;
    while returnstring[Size(returnstring)]='0'
      do
        Unbind(returnstring[Size(returnstring)]);
    od;
    if returnstring[Size(returnstring)]='.'
       then
        Unbind(returnstring[Size(returnstring)]);
    fi;
    return returnstring;
end;


#############################################################################
## This converts a number to a string and fills it up with leading zeros
## if necessary.
## Example with digits=3: 5->"005"
##                        1234->"1234"
##
numberWithLeadingZeros:=function(n,digits)
    local   string;
    
    string:=String(n);
    while Size(string)<digits
       do
        string:=Concatenation(["0",string]);
    od;
    return string;
end;



###################################

vertexOrbitDecomposition:=function(vertexlist,group)
    local   vertices,  vertexorbits,  vertex,  orbit;
    
    vertices:=Set(vertexlist);
    vertexorbits:=[];
    while vertices<>[]
      do
        vertex:=vertices[1];
        orbit:=Concatenation(
                       OrbitPartInVertexSetsStandardSpaceGroup(group,[vertex],
                               vertices));
        Add(vertexorbits,orbit);
        SubtractSet(vertices,orbit);
    od;
    Apply(vertexorbits,i->List(i,j->Position(vertexlist,j)));
    
    return vertexorbits;
end;

###################################

edgeOrbitDecomposition:=function(edges,vertexlist,group)
    local   edgesasvectors,  edgeorbits,  edge,  orbit;
    
    edgesasvectors:=Set(edges,i->Set(i,j->vertexlist[j]));
    edgeorbits:=[];
    while edgesasvectors<>[]
      do
        edge:=edgesasvectors[1];
        orbit:=Set(OrbitPartInVertexSetsStandardSpaceGroup(group,edge,
                       Set(vertexlist)));
        SubtractSet(edgesasvectors,orbit);
        Add(edgeorbits,orbit);
    od;
    edgeorbits:=Set(edgeorbits);
    Apply(edgeorbits,i->Set(i,j->Set(j,k->Position(vertexlist,k))));
    return edgeorbits;
end;


#############################################################################
## Take a string and put <tag> and </tag> arund it
##
enclosedByTag:=function(string,tag)
    return Concatenation(["<",tag,">",string,"</",tag,">\n"]);
end;

enclosedByTagNN:=function(string,tag)
    return Concatenation(["<",tag,">",string,"</",tag,">"]);
end;


enclosedByTagWithOptions:=function(string,tag,options)
    return Concatenation(["<",tag," ",options,">\n",string,"</",tag,">\n"]);
end;

####################

javaviewWrappedDatastring:=function(title,abstract,detail,datastring,wrapper)
    local   outstring,  stream,  line;
        
    outstring:=[];
    stream:=InputTextFile(wrapper);
    while not IsEndOfStream(stream)
      do
        line:=ReadLine(stream);
        if line="##Insert Title##\n"
           then
            line:=enclosedByTag(title,"title");
            Append(line,"\n");
        elif line ="##Insert Abstract##\n"
          then
            line:=enclosedByTag(abstract,"abstract");
            Append(line,"\n");
    
        elif line ="##Insert Detail##\n"
          then
            line:=enclosedByTag(detail,"detail");
            Append(line,"\n");
        elif line="##Insert Data String##\n"
          then
            line:=enclosedByTag(datastring,"geometries");
            Append(line,"\n");
        else
        fi;
        Append(outstring,line);
    od;
    CloseStream(stream);
    return outstring;
end;

####################

    isposdef:=function(mat)
        return ForAll([1..Size(mat)],d->Determinant(mat{[1..d]}{[1..d]})>0);
    end;
    
    
#############################################################################
## This generates the vertices for JavaView:
##  The coloring is calculates separately.    
    ############
    
    javaviewJustPointBlock:=function(vertices,group,precision)
        local   vector2floatString,  cd,  coordstrings,  pstring;
        
        vector2floatString:=function(v,precision)
            local coordstring;
            coordstring:= List(v,q->fraction2floatString(q,precision));
            return JoinStringsWithSeparator(coordstring," ");
        end;
    
    cd:=CholeskyDecomposition(GramianOfAverageScalarProductFromFiniteMatrixGroup(PointGroup(group)));
    coordstrings:=List(vertices,i->vector2floatString(i*cd,precision));
    pstring:=Concatenation([List(coordstrings,s->enclosedByTag(s,"p")),
                     [enclosedByTag("3","thickness")],
                     ["\n"]]);
    pstring:=Concatenation(pstring);
    return enclosedByTag(pstring,"points");
end;


    javaviewPointColors:=function(vertices,group)
        local   porbits,  pcolors,  pcolorlist;
        
        porbits:=vertexOrbitDecomposition(vertices,group);
        
        pcolors:=ncolorStrings(Size(porbits));
        pcolorlist:=List([1..Size(vertices)],v->pcolors[PositionProperty(porbits,o->v in o)]);
        return enclosedByTag(
                          Concatenation(List(pcolorlist,s->enclosedByTag(s,"c"))),
                      "colors");
    
end;
    
    
#############################################################################
## And the edges
################
    
    javaviewEdgeBlock:=function(poly,group)
        local   int2vec,  vec2int,  vertices,  facelattice,  edges,  
                edgeorbits,  orientededges,  orbit,  firstedge,  edge,  
                vecedge,  map,  edgeimage,  estring,  ecolors,  
                ecolorlist,  ecstring;

        int2vec:=function(n)
            return vertices[n];
        end;
        vec2int:=function(v)
            return Position(vertices,v);
        end;
        vertices:=Polymake(poly,"VERTICES");
        facelattice:=Polymake(poly,"FACE_LATTICE");
        edges:=Set(facelattice[Size(facelattice)-1]);
        edgeorbits:=edgeOrbitDecomposition(edges,vertices,group);    

        orientededges:=[];
        for orbit in edgeorbits
          do
            firstedge:=Set(orbit[1],int2vec);
            Add(orientededges,List(firstedge,vec2int));
            for edge in orbit{[2..Size(orbit)]}
              do
                vecedge:=Set(edge,int2vec);
                map:=RepresentativeActionOnRightOnSets(group,firstedge,vecedge);
                edgeimage:=List(firstedge,v->(Concatenation(v,[1])*map));
                Add(orientededges,List(edgeimage,i->vec2int(i{[1..3]})));
            od;
        od;

        orientededges:=List(edges,e->First(orientededges,i->Set(i)=Set(e)));

        estring:=List(orientededges,e->List(e-1,String));
        Apply(estring,s->JoinStringsWithSeparator(s," "));
        Apply(estring,s->enclosedByTag(s,"l"));
        estring:=enclosedByTag(
                         Concatenation(Concatenation(estring),
                             enclosedByTag("4","thickness"))
                             ,"lines");
    
                         ecolors:=ncolorStrings(Size(edgeorbits));
        ecolorlist:=List(edges,v->ecolors[PositionProperty(edgeorbits,o->v in o)]);
        ecstring:=enclosedByTag(
                          Concatenation(List(ecolorlist,s->enclosedByTag(s,"c"))),
                          "colors");
        
        return enclosedByTagWithOptions(Concatenation(["\n",estring,ecstring]),
                       "lineSet", "line=\"show\" color=\"show\" arrow=\"show\"");
     end;        
        
#############################################################################
## FACETS
        
        
javaviewFacetBlock:=function(poly,group)
    local   crossProduct,  facets,  facelattice,  edges,  ofacets,  
            facet,  facetedges,  ofacet,  nextvertex,  nextedge,  
            vertices,  pos,  v1,  v2,  normal,  eq,  testpoint,  
            fstring,  facetorbits,  fcolors,  fcolorlist,  fcstring;
    
    crossProduct:=function(x,y)
        return [  x[2]*y[3]-x[3]*y[2],
                  -(x[1]*y[3]-x[3]*y[1]),
                  x[1]*y[2]-x[2]*y[1]];
    end;
    
    Polymake(poly,"VERTICES_IN_FACETS FACE_LATTICE");
    facets:=Polymake(poly,"VERTICES_IN_FACETS");
    ## first, generate "ordered" versions of the facets:
    facelattice:=Polymake(poly,"FACE_LATTICE");
    edges:=Set(facelattice[Size(facelattice)-1]);
    ofacets:=[];
    for facet in facets
      do
        facetedges:=Set(Filtered(edges,e->IsSubset(facet,e)));
        ofacet:=List(facetedges[1]);
        RemoveSet(facetedges,ofacet);
        nextvertex:=ofacet[2];
        while facetedges<>[]
          do
            nextedge:=First(facetedges,f->nextvertex in f);
            RemoveSet(facetedges,nextedge);
            nextvertex:=First(nextedge,i->i<>nextvertex);
            Add(ofacet,nextvertex);
        od;
        Remove(ofacet);
        Add(ofacets,ofacet);
    od;
    
    ## now check if the ordering must be reversed:
    ## We're lucky this happens in 3-space.
    
    vertices:=Polymake(poly,"VERTICES");
   for pos in [1..Size(ofacets)]
      do
        v1:=vertices[ofacets[pos][2]]-vertices[ofacets[pos][1]];
        v2:=vertices[ofacets[pos][3]]-vertices[ofacets[pos][1]];
        normal:=crossProduct(v1,v2);
        eq:=Concatenation([vertices[ofacets[pos][1]]*normal],normal);
        testpoint:=vertices[Representative(Difference([1..Size(vertices)],ofacets[pos]))];
        if WhichSideOfHyperplane(testpoint,eq)=-1
           then
            ofacets[pos]:=Reversed(ofacets[pos]);
        fi;
    od;
   
    fstring:=List(ofacets,e->List(e-1,String));
    Apply(fstring,s->JoinStringsWithSeparator(s," "));
    Apply(fstring,s->enclosedByTag(s,"f"));
    fstring:=enclosedByTag(Concatenation(fstring) ,"faces");
    facetorbits:=edgeOrbitDecomposition(facets,vertices,group);
    
    fcolors:=ncolorStringsPale(Size(facetorbits));
    fcolorlist:=List(facets,v->fcolors[PositionProperty(facetorbits,o->v in o)]);
    fcstring:=enclosedByTag(
                      Concatenation(List(fcolorlist,s->enclosedByTag(s,"c"))),
                      "colors");
    return enclosedByTagWithOptions(Concatenation(["\n",fstring,fcstring]),
            "faceSet", "face=\"show\" edge=\"show\" color=\"show\"");
end;
       
        
        
        
#############################################################################
## Finally,
## generate a nice javaview file.
    ## It takes a number of affine matrices and generates the
    ## image under each of them.
    ###########################
    
        
javaviewDatastring:=function(poly,maps,group,precision)
    local   vertices,  pstring,  pcstring,  edgeblock,  facetblock,  
            allgeometries,  i,  gshow,  numberstring,  m,  pointblock,  
            facetgeometry,  edgegeometry;
    
    vertices:=Polymake(poly,"VERTICES");
    pstring:=javaviewJustPointBlock(vertices,group,precision);
    pcstring:=javaviewPointColors(vertices,group);
    edgeblock:=javaviewEdgeBlock(poly,group);
    facetblock:=javaviewFacetBlock(poly,group);
    
    allgeometries:=[];
    
    for i in [1..Size(maps)]
      do
        if i=1 
           then
            gshow:="\"show\"";
            if Size(maps)=1
               then
                numberstring:="";
            else
                numberstring:=" FD";
            fi;
        else
            gshow:="\"hide\"";
            numberstring:=String(i-2);
        fi;
        m:=maps[i];
        pstring:=javaviewJustPointBlock(List(vertices,v->
                         List(Concatenation(v,[1])*m){[1..3]}),
                         group,
                         precision);
        pointblock:=enclosedByTagWithOptions(
                            Concatenation(["\n",pstring,pcstring]),
                            "pointSet",
                            "dim=\"3\" point=\"show\" color=\"show\" "
                            );
        facetgeometry:=enclosedByTagWithOptions(
                               Concatenation(["\n",pointblock,"\n",facetblock,"\n"]),
                           "geometry",
                               Concatenation("name=\"points and facets ",numberstring,"\""," visible=",gshow)
                               );
        edgegeometry:=enclosedByTagWithOptions(
                              Concatenation(["\n",pointblock,"\n",edgeblock,"\n"]),
                              "geometry",
                              Concatenation("name=\"points and edges ",numberstring,"\""," visible=",gshow)
                                      
                                      );
        
        Append(allgeometries,Concatenation([facetgeometry,"\n",edgegeometry,"\n\n"]));
    od;
    return allgeometries;
end;
          
    
   
#    ########### Here we are. The orbits are colored.
#    ## Now we mark a vertex for each facet to give the whole thing some
#    ## sort of orientation.
#    ## Facet normals are calculated as well.
#    
#    normals:=[];
#    markingpoints:=[];
#    marklines:=[];
#    currentpointnr:=0;
#    
#    for facetorbit in facetorbits
#      do
#        facet:=facetorbit[1];
#        facetpos:=Position(facets,facet);
#        v1:=vertices[ofacets[facetpos][1]];
#        v2:=vertices[ofacets[facetpos][2]];
#        v3:=vertices[ofacets[facetpos][3]];
#        cp:=crossProduct((v2-v1)*cd,(v3-v1)*cd);
#        normal:=cp;
#                
#        maps:=List([1..Size(facetorbit)],i->
#                   RepresentativeActionOnRightOnSets(group,
#                           Set(facet,int2vec),
#                           Set(facetorbit[i],int2vec)
#                           )
#                   );
#        markedvertex:=facet[1];
#        otherpointsformark:=Flat(Filtered(edges,e->markedvertex in e
#                                    and IsSubset(facet,e)));
#        otherpointsformark:=Filtered(Set(otherpointsformark),p->p<>markedvertex);
#        Apply(otherpointsformark,p->1/3*(int2vec(p)-int2vec(markedvertex))+int2vec(markedvertex));
#        
#        
#        for mapnr in [1..Size(maps)]
#          do
#            map:=maps[mapnr];
#            #normals first:
#            normalimage:=normal*LinearPartOfAffineMatOnRight(map)^cd;
##            normalimage:=normalimage{[1..3]}*cd;
#            normalimage:=normalimage*1/sqrt(normalimage*normalimage);
#            facetpos:=Position(facets,facetorbit[mapnr]);
#            normals[facetpos]:=enclosedByTag(vector2floatString(normalimage{[1..3]},precision),"n");
#            #now the marked corners:
#            imagepoints:=List(otherpointsformark,p->Concatenation(p,[1])*map);
#            Apply(imagepoints,p->p{[1..3]}*cd);
#            
#            for point in imagepoints
#              do
#                Add(markingpoints,enclosedByTag(vector2floatString(point,precision),"p"));
#            od;
#            Add(marklines,enclosedByTag(Concatenation([String(currentpointnr)," ",String(currentpointnr+1)]),"l"));
#            currentpointnr:=currentpointnr+2;
#        od;        
#    od;
#    
#    normals:=enclosedByTag(Concatenation(normals),"normals");
#    
#    Add(marklines,Concatenation([enclosedByTag("3","thickness"),"\n"]));
#    marklines:=enclosedByTag(Concatenation(marklines),"lines");
#    markingpoints:=enclosedByTag(Concatenation(markingpoints),"points");
#    Add(markingpoints,'\n');
#        
#    markblock:=Concatenation(
#                       ["\n",
#                        enclosedByTagWithOptions(markingpoints,
#                                "pointSet",
#                                "dim=\"3\" point=\"hide\""),
#                        "\n",
#                        enclosedByTagWithOptions(marklines,
#                                "lineSet","line=\"show\"")
#                                ]);
#
                     
    #################
#    
#    facetgeometry:=enclosedByTagWithOptions(Concatenation(["\n",pointblock,"\n",facetblock,"\n"]),"geometry","name=\"points and facets\"");                        
#    edgegeometry:=enclosedByTagWithOptions(Concatenation(["\n",pointblock,"\n",edgeblock,"\n"]),"geometry","name=\"points and edges\"");
#                           
##    markgeometry:=enclosedByTagWithOptions(markblock,"geometry","geometry=\"show\" name=\"marks\"");
#                        
#    return Concatenation([facetgeometry,"\n",edgegeometry]);#,"\n",markgeometry]);
    
#end;



    




#############################################################################
#############################################################################


