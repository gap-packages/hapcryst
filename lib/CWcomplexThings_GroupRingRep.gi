#############################################################################
##
#W CWcomplexThings_GroupRingRep.gi 			 HAPcryst package		 Marc Roeder
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
##
InstallMethod(UndirectedWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,word)
    if not IsFreeZGWordNoTermCheck_LargeGroupRep(resolution,word)
       then
        Error("<word> is not a valid word");
    fi;
    return UndirectedWordNC_LargeGroupRep(resolution,word);
end);

#############################################################################
##
InstallMethod(UndirectedWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,word)
    local   fam,  returnword,  term,  coeffs,  i;
    fam:=FamilyObj(Zero(GroupRingOfResolution(resolution)));
    returnword:=[];
    for term in [1..Size(word)]
      do
        coeffs:=CoefficientsAndMagmaElementsAsLists(word[term]);
       for i in [1..Size(coeffs[1])]
          do
            if coeffs[1][i]<>0
               then
               coeffs[1][i]:=1;
           fi;
        od;
        returnword[term]:=ElementOfMagmaRing(fam,0,coeffs[1],coeffs[2]);
   od;
   return returnword;
end);


#############################################################################
##
InstallMethod(IsUndirectedWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,word)
    local   zero,  term;
    if not IsFreeZGWordNoTermCheck_LargeGroupRep(resolution,word)
       then
        return false;
    fi;
    zero:=Zero(GroupRingOfResolution(resolution));
    for term in word
      do
        if term<>zero
           then
            if not Set(CoefficientsAndMagmaElementsAsLists(term)[1])=[1]
               then
                return false;
            fi;
        fi;
    od;
    return true;
end);

#############################################################################
##
InstallMethod(IsUndirectedWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    local   zero;
    if not IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        return false;
    fi;
    zero:=Zero(GroupRingOfResolution(resolution));
    for term in word
      do
        if term<>zero
           then
            if not Set(CoefficientsAndMagmaElementsAsLists(term)[1])=[1]
               then
                return false;
            fi;
        fi;
    od;
    return true;
end);


#############################################################################
##
#O OneCoefficientPartOfWord
## 
##  just the parts parts of the ZG elements with coefficient=1.
##  This can be used to calculate "intersections" of undirected words.
##
InstallMethod(OneCoefficientPartOfWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsVector],
        function(resolution,word)
    if not IsFreeZGWordNoTermCheck_LargeGroupRep(resolution,word)
       then
        Error("<word> is not valid");
    fi;
    return OneCoefficientPartOfWordNC_LargeGroupRep(resolution,word);
end);

############################################################

InstallMethod(OneCoefficientPartOfWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsVector],
        function(resolution,word)
    local   returnword,  zero,  one,  fam,  term,  coeffs,  i;
    returnword:=ShallowCopy(word);
    zero:=Zero(GroupRingOfResolution(resolution));
    one:=ZeroCoefficient(zero)^0;
    fam:=FamilyObj(zero);
    for term in [1..Size(word)]
      do
        if word[term]<>zero
           then
            coeffs:=CoefficientsAndMagmaElementsAsLists(word[term]);
            for i in [1..Size(coeffs[1])]
              do
                if coeffs[1][i]<>one
                   then
                    Unbind(coeffs[1][i]);
                    Unbind(coeffs[2][i]);
                fi;
            od;
            returnword[term]:=ElementOfMagmaRing(fam,0,Compacted(coeffs[1]),Compacted(coeffs[2]));
        fi;
    od;
    return returnword;
end);



#############################################################################
##
#O IntersectingUndirectedWords_LargeGroupRep
## 
##  returns true if <word1> and <word2> have a non-trivial intersection.
##  The words have to be undirected. Otherwise the intersection is not defined.
##
InstallMethod(IntersectingUndirectedWords_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList,IsDenseList],
        function(resolution,word1,word2)
    
    if not Size(word1)=Size(word2)
       then
        Error("words of different length");
    elif not (IsUndirectedWord_LargeGroupRep(resolution,word1) 
            and IsUndirectedWord_LargeGroupRep(resolution,word2)
            )
       then
        Error("<word1>  and <word2> must be valid words");
    fi;
    return IntersectingUndirectedWordsNC_LargeGroupRep(resolution,word1,word2);
end);


#############################################################################
##
InstallMethod(IntersectingUndirectedWordsNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList,IsDenseList],
        function(resolution,word1,word2)
    local   zero,  term,  gElts1,  gElts2;
    zero:=Zero(GroupRingOfResolution(resolution));
    for term in [1..Size(word1)]
      do
        if word1[term]<>zero and word2[term]<>zero
           then
            gElts1:=CoefficientsAndMagmaElementsAsLists(word1[term])[2];
            gElts2:=Set(CoefficientsAndMagmaElementsAsLists(word2[term])[2]);
            if ForAny(gElts1,i->i in gElts2)
               then
                return true;
            fi;
        fi;
    od;
    return false;
end);



#############################################################################
##
InstallMethod(IsUndirectedSubWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList,IsDenseList],
        function(resolution,word1,word2)
    if IsUndirectedWord_LargeGroupRep(resolution,word1)
            and IsUndirectedWord_LargeGroupRep(resolution,word2)
       then
        return IsUndirectedSubWordNC_LargeGroupRep(resolution,word1,word2);
    else
        Error("words must be undirected words of <resolution>");
    fi;
end);

#############################################################################
##
InstallMethod(IsUndirectedSubWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList,IsDenseList],
        function(resolution,word1,word2)
    local   term,  groupelts1,  groupelts2;
    if Size(word1)<>Size(word2)
       then
        return false;
    else
        for term in [1..Size(word1)]
          do
            groupelts1:=CoefficientsAndMagmaElementsAsLists(word1[term])[2];
            groupelts2:=CoefficientsAndMagmaElementsAsLists(word2[term])[2];
            if not IsSubset(groupelts1,groupelts2)
               then
                return false;
            fi;
        od;
    fi;
    return true;
end);

        
#############################################################################
##
## undirectedBoundary calculates just the cells occuring in the boundary.
## signs and multiplicities are ignored.
##
InstallMethod(UndirectedBoundaryOfFreeZGLetter_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,cell)
    if not IsFreeZGLetter_LargeGroupRep(resolution,dim,cell)
       then
        Error("invalid letter");
    fi;
    return UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,cell);
end);

#############################################################################
##
InstallMethod(UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,cell)
    local   zero,  fam,  boundary,  term,  coeffsAndGroupElts,  
            coeffs;
    
    zero:=Zero(GroupRingOfResolution(resolution));
    fam:=FamilyObj(zero);
    boundary:=BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,cell);
    return UndirectedWord_LargeGroupRep(resolution,boundary);
#    for term in [1..Size(boundary)]
#      do
#        if term<>zero
#           then
#            coeffsAndGroupElts:=CoefficientsAndMagmaElementsAsLists(boundary[term]);
#            coeffs:=coeffsAndGroupElts[1];
#            Apply(coeffs,function(i) if i<>0 then return 1; else return 0; fi; end);
#            boundary[term]:=ElementOfMagmaRing(fam,0,coeffs,coeffsAndGroupElts[2]);
#        fi;
#    od;
#    return boundary;
end);



#############################################################################
##
## undirectedBoundary for words.
##  This does NOT calculate the boundary and then kills all the multiplicities.
##  It calculates all dim-1 faces which touch the word <word>.
##
InstallMethod(UndirectedBoundaryOfFreeZGWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   boundary_large;
    if IsFreeZGWord_LargeGroupRep(resolution,dim,word)
       then
        return UndirectedBoundaryOfFreeZGWordNC_LargeGroupRep(resolution,dim,word);
    elif IsFreeZGWord(resolution,dim,word)
      then
        boundary_large:=UndirectedBoundaryOfFreeZGWordNC_LargeGroupRep(resolution,dim,ConvertStandardWord(resolution,dim,word));
        return ConvertWordToStandardRep(resolution,dim-1,boundary_large);
    else
        Error("invalid word");
    fi;
end);

#############################################################################
##
InstallMethod(UndirectedBoundaryOfFreeZGWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    if not IsFreeZGWord_LargeGroupRep(resolution,dim,word)
       then
        Error("invalid word");
    fi;
    return UndirectedBoundaryOfFreeZGWordNC_LargeGroupRep(resolution,dim,word);
end);

#############################################################################
##
InstallMethod(UndirectedBoundaryOfFreeZGWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   zero,  fam,  boundary,  term,  thistermbound;
    
    zero:=Zero(GroupRingOfResolution(resolution));
    fam:=FamilyObj(zero);
    boundary:=[];
    for term in [1..Size(word)]
      do
        if word[term]<>zero
           then
            thistermbound:=BoundaryOfGenerator_LargeGroupRep(resolution,dim,term);
            boundary:=boundary+UndirectedWord_LargeGroupRep(resolution,thistermbound)*word[term];
        fi;
    od;
    return UndirectedWord_LargeGroupRep(resolution,boundary);
end);


#############################################################################
##
InstallMethod(LowerSpaceFromWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,term,word,lowerterms)
    local   lowerspaceparts,  zero,  one,  zerovec,  thisterm,  i,  
            lowerspace,  position,  returnspaces,  lsp,  returnspace,  
            thispart;
    
    if not (IsSet(lowerterms) and ForAll(lowerterms,i->IsInt(i) and i>=0)) 
       then
        Error("<lowerterms> must be a set of non-negative integers");
    fi;
    if term<Maximum(lowerterms)
       then
        Error("term<Maximum(lowerterm)");
    fi;
    if not IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        Error("word not valid");
    fi;
    if lowerterms=[term]
       then
        return [word];
    fi;
    
    lowerspaceparts:=List(lowerterms,term->List([1..Size(word)],i->[]));
    zero:=Zero(GroupRingOfResolution(resolution));
    one:=zero^0;
    zerovec:=ListWithIdenticalEntries(Size(word),zero);
    thisterm:=term;
    for i in [1..Size(word)]
      do
        lowerspace:=ShallowCopy(zerovec);
        lowerspace[i]:=one;
        while thisterm>Minimum(lowerterms)
          do
            lowerspace:=UndirectedBoundaryOfFreeZGWord_LargeGroupRep(resolution,thisterm,lowerspace);
            thisterm:=thisterm-1;
            if thisterm in lowerterms
               then
                position:=Position(lowerterms,thisterm);
                lowerspaceparts[position][i]:=lowerspace;
            fi;
        od;
    od;
    Info(InfoHAPcryst,2,"template done");
    
    returnspaces:=[];
    for lsp in [1..Size(lowerterms)]
      do
        Info(InfoHAPcryst,2,"dimension ",lowerterms[lsp]);
        if lowerterms[lsp]=term
           then
            returnspace:=word;
        else
            returnspace:=ListWithIdenticalEntries(Size(lowerspaceparts[lsp]),zero);
            for i in [1..Size(word)]
              do
                thispart:=lowerspaceparts[lsp][i];
                returnspace:=returnspace+List(thispart,x->x*word[i]);
            od;
        fi;
        returnspace:=UndirectedWord_LargeGroupRep(resolution,returnspace);
        Add(returnspaces,returnspace);
    od;
  return returnspaces;
end);

#############################################################################
##
##
InstallMethod(SubspaceListFromWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   spaces_large;
    if IsFreeZGWord_LargeGroupRep(resolution,dim,word)
       then
        spaces_large:=SubspaceListFromWordNC_LargeGroupRep(resolution,dim,word);
        return spaces_large;
    elif IsFreeZGWord(resolution,dim,word)
      then
        spaces_large:=SubspaceListFromWordNC_LargeGroupRep(resolution,
                              dim,
                              ConvertStandardWord(resolution,dim,word)
                              );
        return List([0..Size(spaces_large)-1],
                i->ConvertWordToStandardRep(resolution,i,spaces_large[i+1]));
    else
        Error("<word> is not a valid word");
    fi;
end);


#############################################################################
##
InstallMethod(SubspaceListFromWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    if IsFreeZGWord_LargeGroupRep(resolution,dim,word)
       then
        return SubspaceListFromWordNC_LargeGroupRep(resolution,dim,word);
    else
        Error("<word> is not a valid word in large group representation");
    fi;
end);


#############################################################################
##
InstallMethod(SubspaceListFromWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   subspaces,  i;
    subspaces:=List([0..dim],i->[]);
    subspaces[dim+1]:=UndirectedWord_LargeGroupRep(resolution,word);
    for i in [dim-1,dim-2..0]
      do
        subspaces[i+1]:=UndirectedBoundaryOfFreeZGWordNC_LargeGroupRep(resolution,i+1,subspaces[i+2]);
    od;
    return subspaces;
end);




#############################################################################
##
## Tests if a word represents a connected supspace.
##
InstallMethod(IsConnectedWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   converted_word;
    if IsFreeZGWord_LargeGroupRep(resolution,dim,word)
       then
        return IsConnectedWordNC_LargeGroupRep(resolution,dim,word);
    elif IsFreeZGWord(resolution,dim,word)
      then
        converted_word:=ConvertStandardWord(resolution,dim,word);
        return IsConnectedWordNC_LargeGroupRep(resolution,dim,converted_word);
    else
        Error("invalid input");    
    fi;    

end);

#############################################################################
##
InstallMethod(IsConnectedWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,word)
    local   zero,  fam,  zerovec,  lettersAndBound,  term,  groupels,  
            g,  letter,  startblob,  blobbound,  addToBlob,  
            addToBlobBound;
    zero:=Zero(GroupRingOfResolution(resolution));
    fam:=FamilyObj(zero);
    zerovec:=List([1..Size(word)],i->zero);
    lettersAndBound:=[];
    for term in [1..Size(word)]
      do
        if word[term]<>zero
           then
            groupels:=CoefficientsAndMagmaElementsAsLists(word[term])[2];
            for g in groupels
              do
                letter:=ShallowCopy(zerovec);
                letter[term]:=ElementOfMagmaRing(fam,0,[1],[g]);
                Add(lettersAndBound,[letter,
                        UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,letter)]
                    );
            od;
        fi;
    od;
    lettersAndBound:=Set(lettersAndBound);
    
    # a "blob" is just that. A connected part of <word>.
    # We don't generate the blob. As we are just interesed in it's size.
    startblob:=Remove(lettersAndBound);
    blobbound:=startblob[2];
    repeat
        addToBlob:=Filtered(lettersAndBound,i->
                           IntersectingUndirectedWordsNC_LargeGroupRep(resolution,i[2],blobbound)
                           );
        if addToBlob<>[]
           then
            SubtractSet(lettersAndBound,addToBlob);
            addToBlobBound:=Sum(List(addToBlob,i->i[2]));
            blobbound:=UndirectedWord_LargeGroupRep(resolution,blobbound+addToBlobBound);
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
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList],
        function(resolution,dim,area,cellblob,cell)
    local   cell_large,  cellblob_large,  area_large,  path_large;
    if IsFreeZGLetter(resolution,dim,cell)
       then
        cell_large:=ConvertStandardLetter(resolution,dim,cell);
        cellblob_large:=ConvertStandardWord(resolution,dim,cellblob);
        area_large:=ConvertStandardWord(resolution,dim,area);
        path_large:=ConnectingPathNC_LargeGroupRep(resolution,
                            dim,
                            area_large,
                            cellblob_large,
                            cell_large
                            );
        if path_large=fail
           then
            return fail;
        else
            return ConvertWordToStandardRep(resolution,dim,path_large);
        fi;
    elif IsFreeZGLetter_LargeGroupRep(resolution,dim,cell)
      then
        path_large:=ConnectingPath_LargeGroupRep(resolution,
                            dim,
                            area,
                            cellblob,
                            cell
                            );
        return path_large;
    else
        TryNextMethod();
    fi;
end);


#############################################################################
##
InstallMethod(ConnectingPath_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList],
        function(resolution,dim,area,cellblob,cell)
    
    if not (IsUndirectedWord_LargeGroupRep(resolution,area)
            and IsFreeZGWord_LargeGroupRep(resolution,dim,cellblob)
            )
       then
        Error("<area> and <cellblob> must be undirected words");
    elif  not (IsFreeZGLetter_LargeGroupRep(resolution,dim,cell)
            and IsUndirectedWord_LargeGroupRep(resolution,cell)
            )
      then
        Error("<cell> is not a valid undirected letter");
    elif not IsUndirectedSubWordNC_LargeGroupRep(resolution,area,cellblob) and cell in area
       then
        Error("<area> does not contain <cellblob> and <cell>");
    fi;
    return ConnectingPathNC_LargeGroupRep(resolution,dim,area,cellblob,cell);
end);


#############################################################################
##
InstallMethod(ConnectingPathNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList],
        function(resolution,dim,area,cellblob,cell)
    local   pathfinder,  zero,  fam,  zerovec,  sphereAndBounds,  
            term,  groupels,  g,  letter,  path;
    
    ##################################################
    ##
    ##  The recursive function "pathfinder" assumes that connectTo is not empty.
    ##  It calculates a path from a "disk" that connects a given starting part 
    ##  with the space of known homotopies.
    ##
    pathfinder:=function(resolution, connectTo, sphereAndBounds, startingBit,startingbitboundary)
        local   thingsThatCouldBeAdded,  endpoint,  
                newSphereAndBounds,  addface,  newstartingbitboundary,  
                newstartingBit,  returnpath;
        thingsThatCouldBeAdded:=Filtered(sphereAndBounds,i->
                                        IntersectingUndirectedWords_LargeGroupRep(resolution,i[2],startingbitboundary)
                                        );
        
        endpoint:=First(thingsThatCouldBeAdded,i->
                        IntersectingUndirectedWords_LargeGroupRep(resolution,i[2],connectTo)
                        );
        if endpoint<>fail
           then
            return UndirectedWord_LargeGroupRep(resolution,startingBit+endpoint[1]);
        else
            newSphereAndBounds:=Difference(sphereAndBounds,thingsThatCouldBeAdded);
            repeat
                if thingsThatCouldBeAdded=[]
                   then
                    return [];
                fi;
                addface:=Remove(thingsThatCouldBeAdded);
                newstartingbitboundary:=UndirectedWord_LargeGroupRep(resolution,startingbitboundary+addface[2]);
                newstartingBit:=UndirectedWord_LargeGroupRep(resolution,startingBit+addface[1]);
                returnpath:=pathfinder(resolution,
                                    connectTo,
                                    newSphereAndBounds,
                                    newstartingBit,
                                    newstartingbitboundary
                                    );
            until returnpath<>[];
            return UndirectedWord_LargeGroupRep(resolution,returnpath);
        fi;
    end;
    
    
    zero:=Zero(GroupRingOfResolution(resolution));
    fam:=FamilyObj(zero);
    zerovec:=List([1..Size(area)],i->zero);
    sphereAndBounds:=[];
    for term in [1..Size(area)]
      do
        if area[term]<>zero
           then
            groupels:=CoefficientsAndMagmaElementsAsLists(area[term])[2];
            for g in groupels
              do
                letter:=ShallowCopy(zerovec);
                letter[term]:=ElementOfMagmaRing(fam,0,[1],[g]);
                Add(sphereAndBounds,[letter,
                        UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,letter)]
                    );
            od;
        fi;
    od;

    if cell in cellblob
       then
        return List(cell,i->zero);
    fi;
    
    path:=pathfinder(resolution,
                  UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,cell),
                  sphereAndBounds,
                  cell,
                  UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,cell)
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
InstallMethod(IsContractibleWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   chaincomplex,  i;
    chaincomplex:=ChainComplexFromWordNC_LargeGroupRep(resolution,dim,subspace);
    return HomologyPb(chaincomplex,dim)=[];
end);


#############################################################################
##
InstallMethod(IsContractibleWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   converted_subspace;
    if IsFreeZGWord_LargeGroupRep(resolution,dim,subspace)
       then
        return IsContractibleWordNC_LargeGroupRep(resolution,dim,subspace);
    elif IsFreeZGWord(resolution,dim,subspace)
       then
        converted_subspace:=ConvertWordToStandardRep(resolution,dim,subspace);
        return IsContractibleWordNC_LargeGroupRep(resolution,dim,converted_subspace);
    else
        Error("invalid input");                    
    fi;
end);

#############################################################################
##
##
InstallMethod(IsContractiblePartialSpace,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,spacelist)
    local   spacelist_large;
    if ForAll([1..Size(spacelist)],subspace->
               IsFreeZGWord_LargeGroupRep(resolution,subspace-1,spacelist[subspace]))
       then
        return IsContractiblePartialSpaceNC_LargeGroupRep(resolution,dim,spacelist);
    elif ForAll([1..Size(spacelist)],subspace->
            IsFreeZGWord(resolution,subspace-1,spacelist[subspace]))
      then
        spacelist_large:=List(spacelist,space->ConvertStandardWord(resolution,dim,space));
        return IsContractiblePartialSpaceNC_LargeGroupRep(resolution,dim,spacelist_large);
    else
        Error("subspacelist does not consist of valid words");
    fi;

end);

#############################################################################
##
InstallMethod(IsContractiblePartialSpaceNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,spacelist)
    local   chaincomplex;
    chaincomplex:=ChainComplexFromPartialSpaceNC_LargeGroupRep(resolution,spacelist{[1..dim+1]});
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
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,dim,space,cell)
    local   complex;
    if not IsFreeZGLetter_LargeGroupRep(resolution,dim,cell)
       then
        Error("<cell> is not a valid letter");
    elif not IsFreeZGWord_LargeGroupRep(resolution,dim,space)
      then
        Error("<space> is not a valid word");
    elif not IsUndirectedSubWord_LargeGroupRep(resolution,space,cell)
       then
        Error("<cell> not in <space>");
    fi;
    complex:=ChainComplexFromWordNC_LargeGroupRep(resolution,dim,space);
    if not Homology(complex,dim)=[0]
       then
        Error("<space> does not contain a unique sphere");
    fi;
    return SphereContainingCellNC_LargeGroupRep(resolution,dim,space,cell);
end);


#############################################################################
##
InstallMethod(SphereContainingCell_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,dim,space,cell)
    local   complex;
    if not IsFreeZGLetter_LargeGroupRep(resolution,dim,cell)
       then
        Error("<cell> is not a valid letter");
    elif not IsFreeZGWord_LargeGroupRep(resolution,dim,space)
      then
        Error("<space> is not a valid word");
    elif not IsUndirectedSubWord_LargeGroupRep(resolution,space,cell)
       then
        Error("<cell> not in <space>");
    fi;
    complex:=ChainComplexFromWordNC_LargeGroupRep(resolution,dim,space);
    if not Homology(complex,dim)=[0]
       then
        Error("<space> does not contain a unique sphere");
    fi;
    return SphereContainingCellNC_LargeGroupRep(resolution,dim,space,cell);
end);



#############################################################################
##
##
InstallMethod(SphereContainingCellNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList,IsDenseList],
        function(resolution,dim,space,cell)
    local   zero,  fam,  zerovec,  space_and_bounds,  term,  groupels,  
            g,  letter,  sphere,  spherebound,  sphere_done,  
            subspacelist,  complex,  newcells,  new_subspaces,  i;

    zero:=Zero(GroupRingOfResolution(resolution));
    fam:=FamilyObj(zero);
    zerovec:=List([1..Size(space)],i->zero);
    space_and_bounds:=[];
    for term in [1..Size(space)]
      do
        if space[term]<>zero
           then
            groupels:=CoefficientsAndMagmaElementsAsLists(space[term])[2];
            for g in groupels
              do
                letter:=ShallowCopy(zerovec);
                letter[term]:=ElementOfMagmaRing(fam,0,[1],[g]);
                Add(space_and_bounds,[letter,
                        UndirectedBoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,dim,letter)]
                    );
            od;
        fi;
    od;
    Sort(space_and_bounds);
    
    sphere:=cell;
    sphere_done:=false;
    subspacelist:=SubspaceListFromWord_LargeGroupRep(resolution,dim,sphere);
    spherebound:=subspacelist[dim];
    complex:=ChainComplexFromPartialSpaceNC_LargeGroupRep(resolution,
                     subspacelist
                     );
    while Homology(complex,dim)<>[0]
      do
        newcells:=Filtered(space_and_bounds,c->
                          IntersectingUndirectedWordsNC_LargeGroupRep(resolution,c[2],spherebound)
                          );
        SubtractSet(space_and_bounds,newcells);
        sphere:=UndirectedWordNC_LargeGroupRep(resolution,sphere+Sum(List(newcells,i->i[1])));
        new_subspaces:=SubspaceListFromWordNC_LargeGroupRep(resolution,
                               dim,
                               Sum(List(newcells,i->i[1]))
                               );
        for i in [1..Size(new_subspaces)]
          do
           subspacelist[i]:=UndirectedWordNC_LargeGroupRep(resolution,subspacelist[i]+new_subspaces[i]);
       od;
       spherebound:=subspacelist[dim];
       complex:=ChainComplexFromPartialSpaceNC_LargeGroupRep(resolution,subspacelist);
    od;
    return sphere;
end);




#############################################################################
##
##  Generate a chain complex from a word
##
InstallMethod(ChainComplexFromWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   converted_subspace;
    if IsFreeZGWord_LargeGroupRep(resolution,dim,subspace)
       then
        return ChainComplexFromWordNC_LargeGroupRep(resolution,dim,subspace);
    elif IsFreeZGWord(resolution,dim,subspace)
      then
        converted_subspace:=ConvertStandardWord(resolution,dim,subspace);
        return ChainComplexFromWordNC_LargeGroupRep(resolution,dim,subspace);
    else
        Error("invalid input");
    fi;
end);


InstallMethod(ChainComplexFromWordNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,dim,subspace)
    local   spaces;
    spaces:=SubspaceListFromWordNC_LargeGroupRep(resolution,dim,subspace);
    return ChainComplexFromPartialSpaceNC_LargeGroupRep(resolution,spaces);
end);



#############################################################################
##
## Generate a chain complex from a list of words
##
InstallMethod(ChainComplexFromPartialSpace_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,subspaces)
    if not ForAll([1..Size(subspaces)],dim->
               IsFreeZGWord_LargeGroupRep(resolution,dim-1,subspaces[dim])
               )
       then
        Error("subspace list contains invalid words");
    fi;
    return ChainComplexFromPartialSpaceNC_LargeGroupRep(resolution,subspaces);
end);

InstallMethod(ChainComplexFromPartialSpaceNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,subspaces)
    local   word2vec,  boundary,  dimension,  zero,  zeroCoeff,  
            oneCoeff,  fam,  generatorGroupEltsList,  ccGenerators,  
            term,  thistermdimension,  zerovec,  dim,  g,  generator,  
            complex,  properties;

    ##################################################
    # /begin functions/
    
    ## assuming that <generators> is a list of length <word>
    ## where each entry is a list of group elements,
    ## we calculate the representation in the chain complex
    ## by just concatenating the coefficients.
    word2vec:=function(generators,word)
        local   vec,  term,  coeffsAndGroupElts,  termgenerators,  g,  
                pos;
        if Size(generators)<>Size(word)
           then
            Error("dimension mismatch");
        fi;
        vec:=List(generators,i->0*[1..Size(i)]);
        for term in [1..Size(word)]
          do
            coeffsAndGroupElts:=CoefficientsAndMagmaElementsAsLists(word[term]);
            termgenerators:=generators[term];
            for g in [1..Size(coeffsAndGroupElts[2])]
              do
                pos:=Position(termgenerators,coeffsAndGroupElts[2][g]);
                if pos<>fail
                   then
                    vec[term][pos]:=coeffsAndGroupElts[1][g];
                else
                    Error("word-vector conversion error");
                fi;
            od;
        od;
        return Concatenation(vec);
    end;    
    
    
    boundary:=function(k,j)
        local   letter,  boundaryAsWord;
        if k=Size(subspaces)+1
           then
            return [];
        fi;
        boundaryAsWord:=BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,k,ccGenerators[k+1][j]);
        if boundaryAsWord=[]
           then
            return [];
        else
            return word2vec(generatorGroupEltsList[k],boundaryAsWord);
        fi;
    end;
    
    
    dimension:=function(k)
        if k<Size(subspaces)
           then
            return Size(ccGenerators[k+1]);
        elif k=Size(subspaces)
          then
          return 0;
        else
            Error("chain complex too short");
        fi;
    end;
    
    # / end functions/
    #############################################
    # / begin program/
    zero:=Zero(GroupRingOfResolution(resolution));
    zeroCoeff:=ZeroCoefficient(zero);
    oneCoeff:=zeroCoeff^0;
    fam:=FamilyObj(zero);
    generatorGroupEltsList:=List(subspaces,s->
                                 List(s,i->Set(CoefficientsAndMagmaElementsAsLists(i)[2]))
                                 );;
    ccGenerators:=List(generatorGroupEltsList,i->[]);
    for term in [1..Size(generatorGroupEltsList)]
      do
        thistermdimension:=Size(generatorGroupEltsList[term]);
        zerovec:=List([1..thistermdimension],i->zero);
        for dim in [1..thistermdimension]
          do
            for g in [1..Size(generatorGroupEltsList[term][dim])]
              do
                generator:=ShallowCopy(zerovec);
                generator[dim]:=ElementOfMagmaRing(fam,zeroCoeff,[oneCoeff],[generatorGroupEltsList[term][dim][g]]);
                Add(ccGenerators[term],generator);
            od;
        od;
    od;
    
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




