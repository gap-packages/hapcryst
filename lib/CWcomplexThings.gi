#############################################################################
##
#W CWcomplexThings.gi 			 HAPcryst package		 Marc Roeder
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
#############################################################################
##
## undirectedBoundary calculates just the cells occuring in the boundary.
## signs and multiplicities are ignored.
##
InstallMethod(UndirectedBoundaryOfFreeZGLetter,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,cell)
    if not IsFreeZGLetter(resolution,dim,cell)
       then
        Error("invalid letter");
    fi;
    return UndirectedBoundaryOfFreeZGLetterNC(resolution,dim,cell);
end);

InstallMethod(UndirectedBoundaryOfFreeZGLetterNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,cell)
    return Set(BoundaryOfFreeZGLetterNC(resolution,dim,cell),i->[AbsInt(i[1]),i[2]]);
end);



#############################################################################
##
## undirectedBoundary for words
##
InstallMethod(UndirectedBoundaryOfFreeZGWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    if not IsFreeZGWord(resolution,dim,word)
       then
        Error("invalid word");
    fi;
    return UndirectedBoundaryOfFreeZGWordNC(resolution,dim,word);
end);

InstallMethod(UndirectedBoundaryOfFreeZGWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    return Union(List(word,cell->UndirectedBoundaryOfFreeZGLetterNC(resolution,dim,cell)));
end);



#############################################################################
##
##
InstallMethod(SubspaceListFromWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    if not IsFreeZGWord(resolution,dim,word)
       then
        Error("<word> is not a valid word");
    fi;
    return SubspaceListFromWordNC(resolution,dim,word);
end);

InstallMethod(SubspaceListFromWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   subspaces,  i;
    subspaces:=List([0..dim],i->[]);
    subspaces[dim+1]:=Set(word,i->[AbsInt(i[1]),i[2]]);
    for i in [dim-1,dim-2..0]
      do
        subspaces[i+1]:=Union(List(subspaces[i+2],
                                j->UndirectedBoundaryOfFreeZGLetter(resolution,i+1,j))
                              );
    od;
    return subspaces;
end);





#############################################################################
##
## Tests if a word represents a connected supspace.
##
InstallMethod(IsConnectedWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    if not IsFreeZGWord(resolution,dim,word)
       then
        Error("<word> is not a valid word");    
    fi;    
    return IsConnectedWordNC(resolution,dim,word);
end);


InstallMethod(IsConnectedWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   lettersAndBound,  startblob,  blobbound,  addToBlob,  
            addToBlobBound;
    
    lettersAndBound:=Set(word,letter->
                         [letter,UndirectedBoundaryOfFreeZGLetter(resolution,dim,letter)]
                         );
    # a "blob" is just that. A connected part of word.
    # We don't generate the blob. As we are just interesed in it's size.
    startblob:=Remove(lettersAndBound);
    blobbound:=startblob[2];
    
    repeat
        addToBlob:=Filtered(lettersAndBound,i->Intersection(i[2],blobbound)<>[]);
        if addToBlob<>[]
           then
            SubtractSet(lettersAndBound,addToBlob);
            addToBlobBound:=Union(List(addToBlob,i->i[2]));
            blobbound:=Union(blobbound,addToBlobBound);
        fi;
    until lettersAndBound=[] or addToBlob=[];
    
    if lettersAndBound=[]
       then
        return true;
    elif addToBlob=[]
      then
        return false;
    fi;    
end);





#############################################################################
##
## connect a cell <cell> to the subspace <cellblob>.
##
InstallMethod(ConnectingPath,
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList],
        function(resolution,dim,area,cellblob,cell)
    
    if not (IsFreeZGWord(resolution,dim,area)
            and IsFreeZGWord(resolution,dim,cellblob)
            )
       then
        Error("<area> and <cellblob> must be valid words");
    elif  not IsFreeZGLetter(resolution,dim,cell)
      then
        Error("<cell> is not a valid letter");
    elif not IsSubset(area,cellblob) and cell in area
       then
        Error("<area> does not contain <cellblob> and <cell>");
    fi;
    return ConnectingPathNC(resolution,dim,area,cellblob,cell);
end);


InstallMethod(ConnectingPathNC,
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList],
        function(resolution,dim,area,cellblob,cell)
    local   pathfinder,  sphereAndBounds,  path;
    
    ##################################################
    ##
    ##  The recursive function "pathfinder" assumes that connectTo is not empty.
    ##  It calculates a path from a "disk" that connects a given starting part 
    ##  with the space of known homotopies.
    ##
    pathfinder:=function(resolution, connectTo, sphereAndBounds, startingBit,startingbitboundary)
        local   thingsThatCouldBeAdded,  endpoint,  addface,  
                newSphereAndBounds,  newstartingbitboundary,  
                newstartingBit,  returnpath;
        
        thingsThatCouldBeAdded:=Filtered(sphereAndBounds,i->Intersection(i[2],startingbitboundary)<>[]);
        
        endpoint:=First(thingsThatCouldBeAdded,i->Intersection(i[2],connectTo)<>[]);
        if endpoint<>fail
           then
            return Concatenation(startingBit,[endpoint[1]]);
        else
            newSphereAndBounds:=Difference(sphereAndBounds,thingsThatCouldBeAdded);
            repeat
                if thingsThatCouldBeAdded=[]
                   then
                    return [];
                fi;
                addface:=Remove(thingsThatCouldBeAdded);
                newstartingbitboundary:=Union(startingbitboundary,addface[2]);
                newstartingBit:=Concatenation(startingBit,[addface[1]]);
                returnpath:=pathfinder(resolution,
                                    connectTo,
                                    newSphereAndBounds,
                                    newstartingBit,
                                    newstartingbitboundary
                                    );
            until returnpath<>[];
            return Unique(returnpath);
        fi;
    end;
    
    
    if cell in cellblob
       then
        return [];
    fi;
    sphereAndBounds:=Set(area,i->[i,UndirectedBoundaryOfFreeZGLetter(resolution,dim,i)]);
    path:=pathfinder(resolution,
                  #                  undirectedReducedBoundaryOfWord(resolution,dim,cellblob),
                  UndirectedBoundaryOfFreeZGLetter(resolution,dim,cell),
                  sphereAndBounds,
                  [cell],
                   UndirectedBoundaryOfFreeZGLetter(resolution,dim,cell)
                  );
    if path=[]
       then
        return fail;
    else
        return path;
    fi;
end);


#############################################################################
##
## given a word in the <dim>th term of <resolution>, this returns true
##  if and only if this word represents a contractible subspace.
##
## connectedness is not tested.
## Is this right, anyway?
##
InstallMethod(IsContractibleWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   chaincomplex,  i;
    chaincomplex:=ChainComplexFromWordNC(resolution,dim,subspace);
    return Homology(chaincomplex,dim)=[];
end);

InstallMethod(IsContractibleWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    if not IsFreeZGWord(resolution,dim,subspace)
       then
        Error("subspace is not a valid word");
    fi;
    return IsContractibleWordNC(resolution,dim,subspace);
end);

#############################################################################
##
##
InstallMethod(IsContractiblePartialSpace,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,spacelist)
    if not ForAll(spacelist,subspace->IsFreeZGWord(resolution,dim,subspace))
       then
        Error("subspace is not a valid word");
    fi;
    return IsContractiblePartialSpaceNC(resolution,dim,spacelist);
end);

InstallMethod(IsContractiblePartialSpaceNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,spacelist)
    local   chaincomplex;
    chaincomplex:=ChainComplexFromPartialSpaceNC(resolution,dim,spacelist);
    return Homology(chaincomplex,dim)=[];
end);



#############################################################################
## 
## find the sphere that contains <cell>.
## The list of cells <space> must induce a chain complex with <dim>th
## homology [0]. 
##
#############################################################################
## 
## check the input and delegate...
##
InstallMethod(SphereContainingCell,
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,dim,space,cell)
    local   complex;
    if not IsFreeZGLetter(resolution,dim,cell)
       then
        Error("<cell> is not a valid letter");
    elif not IsFreeZGWord(resolution,dim,space)
      then
        Error("<space> is not a valid word");
    elif not cell in space
       then
        Error("<cell> not in <space>");
    fi;
    complex:=ChainComplexFromPartialSpace(resolution,dim,space);
    if not Homology(complex,dim)=[0]
       then
        Error("<space> does not contain a unique sphere");
    fi;
    return SphereContainingCellNC(resolution,dim,space,cell);
end);

#############################################################################
##
##
InstallMethod(SphereContainingCellNC,
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,dim,space,cell)
    local   space_and_bounds,  sphere,  spherebound,  sphere_done,  
            subspacelist,  complex,  newcells,  new_subspaces,  i;
    
    space_and_bounds:=List(space,i->[i,UndirectedBoundaryOfFreeZGWord(resolution,dim,i)]);
    sphere:=[cell];
    spherebound:=UndirectedBoundaryOfFreeZGWord(resolution,dim,sphere);
    sphere_done:=false;
    subspacelist:=SubspaceListFromWord(resolution,dim,sphere);
    complex:=ChainComplexFromPartialSpace(resolution,
                     dim,
                     subspacelist
                     );
    while not Homology(complex,dim)=[0]
      do
        newcells:=Filtered(space_and_bounds,c->ForAny(c[2],i->i in spherebound));
        SubtractSet(space_and_bounds,newcells);
        UniteSet(sphere,List(newcells,i->i[1]));
        UniteSet(spherebound,Concatenation(List(newcells,i->i[2])));
        new_subspaces:=SubspaceListFromWord(resolution,
                               dim,
                               List(newcells,i->i[1])
                               );
        for i in [1..Size(new_subspaces)]
          do
            UniteSet(subspacelist[i],new_subspaces[i]);
        od;
    od;
    return Set(sphere);
end);






#############################################################################
##
##  Generate a chain complex from a word
##
InstallMethod(ChainComplexFromWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    if not IsFreeZGWord(resolution,dim,subspace)
       then
        Error("<subspace> is not a proper word");
    fi;
    return ChainComplexFromWordNC(resolution,dim,subspace);
end);

InstallMethod(ChainComplexFromWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   spaces;
    spaces:=SubspaceListFromWord(resolution,dim,subspace);
    return ChainComplexFromPartialSpaceNC(resolution,spaces);
end);



#############################################################################
##
## Generate a chain complex from a list of words
##
InstallMethod(ChainComplexFromPartialSpace,
        [IsHapResolutionRep,IsDenseList],
        function(resolution,subspaces)
    if not ForAll([1..Size(subspaces)],dim->
               IsFreeZGWord(resolution,dim-1,subspaces[dim])
               )
       then
        Error("subspace list contains invalid words");
    fi;
    return ChainComplexFromPartialSpaceNC(resolution,subspaces);
end);


#############################################################################
##
InstallMethod(ChainComplexFromPartialSpaceNC,
        [IsHapResolutionRep,IsDenseList],
        function(resolution,subspaces)
    local   undirectedLetter,  word2vec,  boundary,  dimension,  
            complex,  properties;
    
    undirectedLetter:=function(letter)
        return [AbsInt(letter[1]),letter[2]];
    end;
    
    word2vec:=function(generators,word)
        local   vec,  letter,  pos;
        vec:=List([1..Size(generators)],i->0);
        for letter in word
          do
            pos:=Position(generators,undirectedLetter(letter));
            if pos<>fail
               then
                vec[pos]:=vec[pos]+SignInt(letter[1]);
            else
                Error("word-vector conversion error");
            fi;
        od;
        return vec;
    end;
    
    
    boundary:=function(k,j)
        local   letter,  boundaryAsWord;
        if k=Size(subspaces+1)
           then
            return [];
        fi;
        letter:=subspaces[k+1][j];
        boundaryAsWord:=BoundaryOfFreeZGLetterNC(resolution,k,letter);
        return word2vec(subspaces[k],boundaryAsWord);
    end;
    
    
    dimension:=function(k)
        if k<Size(subspaces)
           then
            return Size(subspaces[k+1]);
        elif k=Size(subspaces)
          then
          return 0;
        else
            Error("chain complex too short");
        fi;
    end;
    
    complex:=Objectify(HapChainComplex,
                     rec(dimension:=dimension,
                         boundary:=boundary,
                         subspaces:=List(subspaces),
                         properties:=
                         [["length", Size(subspaces)-1],
                          ["characteristic", 0],
                          ["type", "chainComplex"]
                          ])
                     );
    return complex;
end);




