# (C)2007-2008 by Marc Roeder,
#   distribute under the terms of the GPL version 2.0 or later


LoadPackage("hapcryst");
####
# Adjust these variables, if needed:
#
JAVAVIEW_PROGRAM:=Filename(DirectoriesSystemPrograms(),"javaview");
#JAVAVIEW_OUTPUT_DIR:=Directory("~/flatManifolds3d/tmp");
JAVAVIEW_OUTPUT_DIR:=DirectoryTemporary();
PRECISION:=9;   
## PRECISION is the number of digits after the first non- zero digit
## after the comma.
## If your polytope looks too strange, increase this number.

JAVAVIEW_WRAPPER_FILE:=Filename(DirectoriesPackageLibrary("hapcryst","examples"),"javaviewwrapper.txt");
ReadPackage("hapcryst","examples/orbitcoloring.gap");

############
### The following 3-dimensional space groups are Bieberbach.
### So you might try viewFundamentalDomain for those:
bieberbachlist:=[ 1, 4, 7, 9, 19, 33, 34, 76, 142, 165 ];

#############################################################################
##
## PLEASE READ THIS:
##
## to get a picture of a fundamental domain of a 3-dimensional Bieberbach
## group, just type 
## viewFundamentalDomain([a,b,c],n);
## with a,b,c rational numbers and n a number from the bieberbachlist.
## 
## or type
## viewTessellation([a,b,c],n);
## to get a part of the tessellation defined by the fundamental domain.
## The shown geometry contains hidden parts. Look at "Inspector>Display"
## The neighbouring parts are named by the face of the original fundamental
## cell they touch. You can view the names by making the fundamental domain 
## "FD" active and tick the box at "Method>Show>Show Element Names".
##
## Use "Inspector>Camera" to zoom in and out.




#############################################################################
##
## This function takes a fundamental domain and colors the faces. 
## It also calculates a set of images under <maps> and generates a 
## JavaView file containing all that.
##
writeFundamentalDomainAndImages:=function(poly,maps,group,point,groupnr)
    local   startpointstring,  filename,  vertexonlypoly,  abstract,  
            title,  detail,  data,  outputfile;
    
    startpointstring:=ReplacedString(JoinStringsWithSeparator(List(point,String),"_"),"/",".");
    filename:=Concatenation([numberWithLeadingZeros(groupnr,3),
                      "__",
                      startpointstring]);
    vertexonlypoly:=CreatePolymakeObjectFromFile(JAVAVIEW_OUTPUT_DIR,Concatenation(filename,".poly"));
    ClearPolymakeObject(vertexonlypoly);
    AppendVertexlistToPolymakeObject(vertexonlypoly,Polymake(poly,"VERTICES"));
    Unbind(vertexonlypoly);      
    abstract:="Fundamental cell of cystallographic group ";
    Append(abstract,String(groupnr));
    
    title:=Concatenation("FD ",String(groupnr));
    detail:="This is the fundamental cell of the crystallographic group number ";
    Append(detail,String(groupnr));
    Append(detail," from GAPs crystallographic groups library.\n The orbits are colored in each dimension.\n");
    Append(detail,"Starting point for Dirichlet-Voronoi: ");
    Append(detail,String(point));
    Append(detail,".\nOutput precision: ");
    Append(detail,String(PRECISION));
    Append(detail," (this is the number of digits after the first non-zero entry after the point.");
    Append(detail,"\nGenerated using the GAP packages HAPcryst and polymake as well as the computational geometry package polymake.");
    
    data:=javaviewDatastring(poly,maps,group,PRECISION);
    Append(filename,".jvx");
    outputfile:= OutputTextFile(Filename(JAVAVIEW_OUTPUT_DIR,filename), false );
    WriteAll(outputfile,
            javaviewWrappedDatastring(
                    title,
                    abstract,
                    detail,
                    data,
                    JAVAVIEW_WRAPPER_FILE)
            );
    CloseStream(outputfile);
    return Filename(JAVAVIEW_OUTPUT_DIR,filename);
end;

#############################################################################
## 
## This just generates the fundamental domain and writes a JavaView file for it
##

writeFundamentalDomain:=function(poly,group,point,groupnr)            
    return writeFundamentalDomainAndImages(poly,[IdentityMat(4)],group,point,groupnr);
end;

#############################################################################
##
##
generateFundamentalDomain:=function(point,groupnr)
    local   group,  poly,  filename,vo;
    group:=SpaceGroup(3,groupnr);
#    poly:=FundamentalDomainStandardSpaceGroup(point,group);
    poly:=FundamentalDomainBieberbachGroupNC(point,group);
    if not IsFundamentalDomainStandardSpaceGroup(poly,group)
       then
        Error("failed generating fundamental domain");
    fi;        
    filename:=writeFundamentalDomain(poly,group,point,groupnr);
    return filename;
end;


viewFundamentalDomain:=function(point,groupnr)
    local   filename;
    filename:=generateFundamentalDomain(point,groupnr);
    Exec(Concatenation([JAVAVIEW_PROGRAM," ",filename]));
    return filename;
end;


generateTessellationFromPolytope:=function(point,poly,groupnr)
    local   group,  facets,  vertices,  orbitdecomp,  maps,  facet,  
            orbit,  otherfacet,  filename;

    group:=SpaceGroup(3,groupnr);
    Polymake(poly,"FACETS VERTICES_IN_FACETS FACE_LATTICE");
    facets:=Polymake(poly,"VERTICES_IN_FACETS");
    vertices:=Polymake(poly,"VERTICES");
    orbitdecomp:=edgeOrbitDecomposition(facets,vertices,group);
    maps:=[IdentityMat(4)];
    for facet in facets
      do
        orbit:=First(orbitdecomp,o->facet in o);
        otherfacet:=First(orbit,f->f<>facet);
        Add(maps,RepresentativeActionOnRightOnSets(group,Set(otherfacet,i->vertices[i]),Set(facet,i->vertices[i])));
    od;
    filename:=writeFundamentalDomainAndImages(poly,maps,group,point,groupnr);
    return filename;
end;    



generateTessellation:=function(point,groupnr)
    local   group,  poly,  filename;
    
    group:=SpaceGroup(3,groupnr);
    #    poly:=FundamentalDomainStandardSpaceGroup(point,group);
    poly:=FundamentalDomainBieberbachGroupNC(point,group);
    filename:=generateTessellationFromPolytope(point,poly,groupnr);
    return filename;
end;



viewTessellation:=function(point,groupnr)
    local   filename;
    filename:=generateTessellation(point,groupnr);
    Exec(Concatenation([JAVAVIEW_PROGRAM," ",filename]));
    return filename;
end;

