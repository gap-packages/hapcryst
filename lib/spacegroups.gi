#############################################################################
##
#W spacegroups.gi 			 HAPcryst package		 Marc Roeder
##
##  

##
##
#Y	 Copyright (C) 2006 Marc Roeder 
#Y 
#Y This program is free software; you can redistribute it and/or 
#Y modify it under the terms of the GNU General Public License 
#Y as published by the Free Software Foundation; either version 2 
#Y of the License, or (at your option) any later version. 
#Y 
#Y This program is distributed in the hope that it will be useful, 
#Y but WITHOUT ANY WARRANTY; without even the implied warranty of 
#Y MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#Y GNU General Public License for more details. 
#Y 
#Y You should have received a copy of the GNU General Public License 
#Y along with this program; if not, write to the Free Software 
#Y Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
##
InstallMethod(PointGroupRepresentatives,"for crystallographic groups on right",
        [IsAffineCrystGroupOnLeftOrRight],
        function(group)
    local   linearPart,  walkthetreeright,  walkthetreeleft,  
            generators,  dim,  affinepointgroupels,  pointgroupels;
    
    ##########
    # local methods for fast access to translational and linear part:
    #
    linearPart:=function(mat)
        return mat{[1..dim-1]}{[1..dim-1]};
    end;
    
    ##########
    # A recursive method to generate representatives for the point group.
    # This also finds a translation basis.
    # Note that the results are stored in global (not belonging to 
    # "walkthetree") variables.
    #
    walkthetreeright:=function(element,gens)
        local   g,  endofbranch,  newel,  newellin,  differences,
                newtrans;
        for g in gens
          do
            newel:=element*g;
            newellin:=linearPart(newel);
            if not (newellin in pointgroupels)
               then
                AddSet(affinepointgroupels,newel);
                AddSet(pointgroupels,newellin);
                walkthetreeright(newel,gens);
            fi;
        od;
    end;
    
    walkthetreeleft:=function(element,gens)
        local   g,  endofbranch,  newel,  newellin,  differences,
                newtrans;
        for g in gens
          do
            newel:=g*element;
            newellin:=linearPart(newel);
            if not (newellin in pointgroupels)
               then
                AddSet(affinepointgroupels,newel);
                AddSet(pointgroupels,newellin);
                walkthetreeleft(newel,gens);
            fi;
        od;
    end;

    
    ##########
    #And here is the main program:
    #
    
    
    generators:=GeneratorsOfGroup(group);
    dim:=DimensionOfMatrixGroup(group);
    
    ##########
    # Now generate the pointgroup and representatives for it.
    #
    affinepointgroupels:=[IdentityMat(dim)];
    pointgroupels:=[IdentityMat(dim-1)];
    if IsAffineCrystGroupOnRight(group)
       then
        walkthetreeright(generators[1]^0,generators);
        if not Size(PointGroup(AffineCrystGroupOnRight(generators)))=Size(affinepointgroupels)
           then
            Error("generation of point group failed!");
        fi;
    else
        walkthetreeleft(generators[1]^0,generators);
        if not Size(PointGroup(AffineCrystGroupOnLeft(generators)))=Size(affinepointgroupels)
           then
            Error("generation of point group failed!");
        fi;
    fi;
    
    return Set(affinepointgroupels);
end);



#############################################################################
#
# Let $S$ be an $n$-dimensional crystallographic group in standard form. 
# For a given point $x$ in $[0,1]^n$, we determine the stabilizer in $S$
# and the part of the orbit which lies inside $[0,1]^n$. 
#
# If the linear part of the group elements are orthogonal with respect to
# the euclidian scalar product, all elements of the orbit lying in $[-1,1]^n$ 
# (and a few more) are returned. In all other cases, this is not guaranteed.
#

InstallMethod(OrbitStabilizerInUnitCubeOnRight,"for space groups on right",
        [IsGroup,IsVector],
        function(group,x)
    local   orbitpart,  stabilizer,  xaff,  pointgroupreps,  g,  
            imageaff,  image,  translation;

    if not IsAffineCrystGroupOnRight(group) and IsStandardSpaceGroup(group)
       then
        Error("Group must be an AffineCrystGroupOnRight in standard form");
    fi;
    orbitpart:=[];
    stabilizer:=[];
    if not VectorModOne(x)=x
       then
        Error("please choose a vector from [0,1)^n");
    fi;
    xaff:=Concatenation(x,[1]);
    Add(orbitpart,x);
    pointgroupreps:=PointGroupRepresentatives(group);
    for g in pointgroupreps
      do
        imageaff:=xaff*g;
        image:=VectorModOne(imageaff){[1..Size(imageaff)-1]};
        if not image in orbitpart
           then
            AddSet(orbitpart,image);
        elif imageaff=xaff
          then
            Add(stabilizer,g);
        elif image=x
          then
            translation:=IdentityMat(Size(xaff));
            translation[Size(translation)]:=-imageaff+xaff;
            translation[Size(translation)][Size(translation)]:=1;
            Add(stabilizer,g*translation);
        fi;
    od;
    return rec(orbit:=orbitpart,stabilizer:=Subgroup(group,stabilizer));
end);



#############################################################################
##
#O OrbitStabilzerInUniCubeOnRightOnSets(group,set)
## 
InstallMethod(OrbitStabilizerInUnitCubeOnRightOnSets,
        "for space groups on right",
        [IsGroup,IsDenseList],
        function(group,set)
    local   dim,  stepsFromZeroOne,  orbitpart,  stabilizer,  setaff,  
            pointgroupreps,  g,  imageaff,  point,  transvector,  
            image;
    
    if not IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group)
       then
        Error("group must be a StandardSpaceGroup acting on right");
    fi;
    dim:=DimensionOfMatrixGroup(group);
    if not Set(set,VectorModOne)=set or not Set(set,Size)=[dim-1]
       then
        Error("please choose a set of vectors from [0,1)^n");
    fi;
    
    if not IsSet(set) and ForAll(set,IsVector)
       then
        Error("set must be a Set of Vectors");
    fi;
    
    stepsFromZeroOne:=function(q)
        local   r;
        r:=Int(q);
        if q<0
           then
            return r-1;
        else
            return r;
        fi;
    end;
    
    
    orbitpart:=[];
    stabilizer:=[];
    setaff:=Set(set,x->Concatenation(x,[1]));
    Add(orbitpart,set);
    pointgroupreps:=PointGroupRepresentatives(group);
    for g in pointgroupreps
      do
        imageaff:=Set(setaff,s->s*g);
        if imageaff=setaff
           then
            Add(stabilizer,g);
        fi;
        for point in imageaff
          do
            transvector:=List(point{[1..Size(point)-1]},
                              i->stepsFromZeroOne(i));
            image:=Set(imageaff,i->i{[1..Size(point)-1]}-transvector);
            if not image in orbitpart
               then
                AddSet(orbitpart,image);
            elif image=set
              then
                Add(stabilizer,g*TranslationOnRightFromVector(-transvector));
            fi;
        od;
    od;
    return rec(orbit:=orbitpart,stabilizer:=Group(stabilizer));
end);



#############################################################################
##
#O OrbitPartInVertexSetsStandardSpaceGroup
##
# And a special function not only for polyhedrae:
#this takes a list of vertices (vectors) and returns the part of the 
# orbit which consists of vertex sets.
#
# This doesn't even use that the vertices are all in [-1,1].
# It just works for arbitray polyhedra.
#
# works better for small <vertexset> than for large.
#
InstallMethod(OrbitPartInVertexSetsStandardSpaceGroup,
        [IsGroup,IsDenseList,IsDenseList],
        function(group,vertexset,allvertices)
    local   orbit,  dim,  pointGroupReps,  setaff,  newimagesize,  
            newimage,  g,  image,  point,  trans,  index,  
            stillinvertices;
    
    if not IsStandardSpaceGroup(group) or not IsAffineCrystGroupOnRight(group)
       then
        TryNextMethod();
    fi;
    if not (IsSet(vertexset) 
            and IsMatrix(vertexset)
            and IsSet(allvertices)
            and IsSubset(allvertices,vertexset))
       then
        Error("<vertexset> must be a subset of <allvertices> which must be a set of vectors");
    fi;
    dim:=Size(allvertices[1]);
    orbit:=[vertexset];
    
    pointGroupReps:=PointGroupRepresentatives(group);
    
    setaff:=Set(vertexset,x->Concatenation(x,[1]));
    newimagesize:=Size(setaff);
    newimage:=[1..newimagesize];
    for g in pointGroupReps
      do
#        imageaff:=Set(setaff,s->s*g);
        image:=Set(setaff*g,i->i{[1..dim]});
        point:=image[1];#{[1..dim]};
        for trans in allvertices-point
          do
            if ForAll(trans,IsInt)
               then
                index:=1;
                stillinvertices:=true;
                while index<=newimagesize and stillinvertices
                  do
                    newimage[index]:=image[index]+trans;
                    if not newimage[index] in allvertices
                       then
                        stillinvertices:=false;
                    fi;
                    index:=index+1;
                od;
                if stillinvertices
                   then
                    Add(orbit,Set(newimage));
                fi;
            fi;
        od;
    od;
    return Set(orbit);
end);



#############################################################################
##
#O OrbitPartInFacesStandardSpaceGroup
##
# And a special function not only for polyhedrae:
# this takes a set of vertices (vectors) and returns the part of the 
# part of the orrbit lying inside a set of sets of vectors.
# This works like OnSets, but does only return a part of the orbit.
# <vertexset> has to be an element of <faceset>
#
# This doesn't even use that the vertices are all in [-1,1].
# It just works for arbitray polyhedra.
#
# works better for small <vertexset> than for large.
#
InstallMethod(OrbitPartInFacesStandardSpaceGroup,
        [IsGroup,IsDenseList,IsDenseList],
        function(group,vertexset,faceset)
    local   allvertices,  currentfirst,  facesbyfirstvertex,  
            currentfirstposition,  face,  i,  dim,  orbit,  
            pointGroupReps,  setaff,  newimagesize,  g,  image,  
            point,  targetbatch,  trans,  index,  thereisaface,  
            candidatefaces,  newimage,  newentry;
    
    if not IsStandardSpaceGroup(group) or not IsAffineCrystGroupOnRight(group)
       then
        TryNextMethod();
    fi;
    if not (IsSet(vertexset) 
            and IsSet(faceset)
            and ForAll(faceset,IsSet)
            and vertexset in faceset
            and IsMatrix(vertexset))
       then
        Error("<vertexset> must be an element of <faceset> which must be a set of sets of vectors");
    fi;
    
        # all vertices that turn up in a given position in any face:
    # and all faces partitioned by there first element.
    #
    allvertices:=List([1..Maximum(List(faceset,Size))],i->[]);
    currentfirst:=[];
    facesbyfirstvertex:=[];
    currentfirstposition:=0;    
    for face in faceset
      do
        for i in [1..Size(face)]
          do
            Add(allvertices[i],face[i]);
            if i=1
               then
                if currentfirst=face[1]
                   then
                    Add(facesbyfirstvertex[currentfirstposition],face);
                else
                    currentfirst:=face[1];
                    currentfirstposition:=currentfirstposition+1;
                    facesbyfirstvertex[currentfirstposition]:=[face];
                fi;
            fi;
        od;
    od;
    Apply(allvertices,Set);
    MakeImmutable(allvertices);           
    
    dim:=Size(faceset[1][1]);
    orbit:=[];
    
    pointGroupReps:=Set(PointGroupRepresentatives(group));
    
    setaff:=List(vertexset,x->Concatenation(x,[1]));
    newimagesize:=Size(setaff);

    for g in pointGroupReps
      do
        image:=Set(setaff*g,i->i{[1..dim]});
        point:=image[1];
        
            #<point>+trans has to be the smallest vector in the image set:
        for targetbatch in facesbyfirstvertex
          do
            trans:=targetbatch[1][1]-point;
            if ForAll(trans,IsInt)
               then
                index:=1;
                thereisaface:=true;
                candidatefaces:=targetbatch;
                newimage:=[targetbatch[1][1]];
                while index<=newimagesize and thereisaface
                  do
                    newentry:=image[index]+trans;
                    newimage[index]:=newentry;
                    if not newentry in allvertices[index]
                       then
                        thereisaface:=false;
                    else
                        candidatefaces:=Filtered(candidatefaces,c->c[index]=newentry);
                        index:=index+1;
                    fi;
                    if candidatefaces=[]
                       then
                        thereisaface:=false;
                    fi;
                od;
                if thereisaface 
                   then
                    Add(orbit,newimage);
                    
                fi;
            fi;
            
        od;
    od;
    return Set(orbit);
end);



#############################################################################
##
#O OrbitPartAndRepresentativesInFacesStandardSpaceGroup
##
# And a special function not only for polyhedrae:
# this takes a set of vertices (vectors) and returns the part of the 
# part of the orrbit lying inside a set of sets of vectors.
# This works like OnSets, but does only return a part of the orbit.
# <vertexset> has to be an element of <faceset>.
#
# This doesn't even use that the vertices are all in [-1,1].
# It just works for arbitray polyhedra.
#
# works better for small <vertexset> than for large.
#
# the output is a list of pairs, the first entry of each pair is an orbit
# element and the second one a representative taking <vertexset> to that 
# orbit element.
#
InstallMethod(OrbitPartAndRepresentativesInFacesStandardSpaceGroup,
        [IsGroup,IsDenseList,IsDenseList],
        function(group,vertexset,faceset)
    local   allvertices,  currentfirst,  facesbyfirstvertex,  
            currentfirstposition,  face,  i,  dim,  orbit,  reps,  
            pointGroupReps,  setaff,  newimagesize,  g,  image,  
            point,  targetbatch,  trans,  index,  thereisaface,  
            candidatefaces,  newimage,  newentry,  representative;
    
    if not IsStandardSpaceGroup(group) or not IsAffineCrystGroupOnRight(group)
       then
        TryNextMethod();
    fi;
    if not (IsSet(vertexset) 
            and IsSet(faceset)
            and ForAll(faceset,IsSet)
            and vertexset in faceset
            and IsMatrix(vertexset))
       then
        Error("<vertexset> must be an element of <faceset> which must be a set of sets of vectors");
    fi;
    
    # all vertices that turn up in a given position in any face:
    # and all faces partitioned by there first element.
    #
    allvertices:=List([1..Maximum(List(faceset,Size))],i->[]);
    currentfirst:=[];
    facesbyfirstvertex:=[];
    currentfirstposition:=0;    
    for face in faceset
      do
        for i in [1..Size(face)]
          do
            Add(allvertices[i],face[i]);
            if i=1
               then
                if currentfirst=face[1]
                   then
                    Add(facesbyfirstvertex[currentfirstposition],face);
                else
                    currentfirst:=face[1];
                    currentfirstposition:=currentfirstposition+1;
                    facesbyfirstvertex[currentfirstposition]:=[face];
                fi;
            fi;
        od;
    od;
    Apply(allvertices,Set);
    MakeImmutable(allvertices);           
                 
    
    dim:=Size(faceset[1][1]);
    orbit:=[];
    reps:=[];
    
    pointGroupReps:=Set(PointGroupRepresentatives(group));
    setaff:=List(vertexset,x->Concatenation(x,[1]));
    
    newimagesize:=Size(setaff);
    
    for g in pointGroupReps
      do
        image:=Set(setaff*g,i->i{[1..dim]});
        point:=image[1];
        
            #<point>+trans has to be the smallest vector in the image set:
        for targetbatch in facesbyfirstvertex
          do
            trans:=targetbatch[1][1]-point;
            if ForAll(trans,IsInt)
               then
                index:=2;
                thereisaface:=true;
                candidatefaces:=targetbatch;
                newimage:=[targetbatch[1][1]];
                while index<=newimagesize and thereisaface
                  do
                    newentry:=image[index]+trans;
                    newimage[index]:=newentry;
                    if not newentry in allvertices[index]
                       then
                        thereisaface:=false;
                    else
                        candidatefaces:=Filtered(candidatefaces,c->c[index]=newentry);
                        index:=index+1;
                    fi;
                    if candidatefaces=[]
                       then
                        thereisaface:=false;
                    fi;
                od;
                if thereisaface 
                   then
                    if not newimage in orbit
                       then
                        representative:=ShallowCopy(g);
                        representative[dim+1]:=representative[dim+1]+trans;
                        Add(orbit,newimage);
                        Add(reps,representative);
                        SortParallel(orbit,reps);
                    fi;
                fi;
            fi;
        od;
    od;
    return List([1..Size(orbit)],i->[orbit[i],reps[i]]);
end);





#############################################################################
##
#O StabilizerOnSetsStandardSpaceGroup
##
##
InstallMethod(StabilizerOnSetsStandardSpaceGroup,
        [IsGroup,IsDenseList],
        function(group,set)
    local   pointGroupReps,  dim,  stabgens,  setaff,  representative,  
            alpha,  image,  trans,  addel;
    
    if not (IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group))
       then
        TryNextMethod();
    fi;
    pointGroupReps:=PointGroupRepresentatives(group);
    
    if not IsSet(set) and IsMatrix(set)
      then
        Error("<set> must be a set of vectors");
    fi;
    dim:=Size(set[1]);
    if not dim=DimensionOfMatrixGroup(group)-1
       then
        Error("group and vectors don't fit");
    fi;
    
    stabgens:=[];
    setaff:=List(set,x->Concatenation(x,[1]));
    representative:=setaff[1];
    for alpha in pointGroupReps
      do
        image:=Set(setaff,i->i*alpha);
        trans:=image[1]-representative;
        if ForAll(trans,IsInt)
           then
            if image=setaff+trans
               then
                addel:=MutableCopyMat(alpha);
                addel[dim+1]:=addel[dim+1]-trans;
                Add(stabgens,addel);
            fi;
        fi;
    od;
    return Group(Set(stabgens));
end);


#############################################################################
##
#O RepresentativeActionOnRightOnSets(group,set,imageset) for StandardSpaceGroups
##
InstallMethod(RepresentativeActionOnRightOnSets,"for crystallographic groups on right",
        [IsGroup,IsDenseList,IsDenseList],
        function(group,set, imageset)
    local   dim,  pointgroupreps,  setaff,  imagesetaff,  imagepoint,  
            g,  setaffimage,  point,  difference,  candidate;
    
    if not IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group)
       then
        Error("group must be a StandardSpaceGroup acting on right");
    fi;
    dim:=DimensionOfMatrixGroup(group)-1;
    if not ForAll([set,imageset],IsSet) or set=[] or imageset=[] or Size(set)<>Size(imageset)
       then
        Error("set and imageset must be propper non empty sets of the same size");
    fi;
    if not Set(set,Size)=[dim] 
       or not Size(set)=Size(imageset)
       or not Set(imageset,Size)=[dim]
       or not ForAll(set,IsVector)
       or not ForAll(imageset,IsVector)
       then
        Error("<set> and <imageset> must be sets of vectors of the right length");
    fi;
    
    pointgroupreps:=PointGroupRepresentatives(group);
    
    setaff:=List(set,x->Concatenation(x,[1]));
    imagesetaff:=List(imageset,x->Concatenation(x,[1])); 
    imagepoint:=imagesetaff[1];

    for g in pointgroupreps
      do
        setaffimage:=List(setaff,s->s*g);
        difference:=imagepoint-Minimum(setaffimage);
        if ForAll(difference,IsInt)
           then
            if ForAll(setaffimage,i->i+difference in imagesetaff)
               then
                candidate:=ShallowCopy(g);
                candidate[dim+1]:=candidate[dim+1]+difference;
                return candidate;
            fi;
        fi;
    od;
    return fail;
end);


#############################################################################
##
#O GramianOfAverageScalarProductFiniteMatrixGroup
##
# Suppose $G$ is a finite group of matrices. Suppose further, that you
# know they are orthogonal with respect to (some) euclidian scalar product.
# This method finds a Gramian matrix describing a positive definite symmetric
# bilinear form.
# This form isn't necessrily normed. But the gramian matrix has only
# rational entries.
#
# The returned gramian matrix is that of the average scalar product induced
# by $G$.
#
InstallMethod(GramianOfAverageScalarProductFromFiniteMatrixGroup,
        [IsGroup],
        function(group)
    local   dim,  basis,  summands,  g,  gramian,  i,  j,  denom;
    
    if not IsFinite(group)
       then
        Error("this only works for finite groups");
    fi;
    dim:=Size(Representative(group));
    basis:=IdentityMat(dim);
    if ForAll(GeneratorsOfGroup(group),g->TransposedMat(g)=Inverse(g))
       then
        gramian:=basis;
    else
        summands:=Set(group,i->i*TransposedMat(i));
        gramian:=Sum(summands);
    fi;
    return gramian;
end);

