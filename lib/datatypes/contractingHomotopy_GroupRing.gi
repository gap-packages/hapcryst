#############################################################################
##
#W contractingHomotopy_GroupRing.gi 			 HAPcryst package		 Marc Roeder
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
#O MaximalSubspaceOfHomotopy_LargeGroupRep()
##
InstallMethod(MaximalSubspaceOfHomotopy_LargeGroupRep,
        [IsPartialContractingHomotopy,IsInt],
        function(homotopy,term)
    local   resolution;
    resolution:=ResolutionOfContractingHomotopy(homotopy);
    if not IsHapLargeGroupResolutionRep(resolution)
       then
        Error("not implemented yet. Resolution not in large group rep");
    fi;
    return homotopy!.knownPartOfHomotopy[term+1].space;
end);


#############################################################################
##
#O ImageOfContractinghomotopy_LargeGroupRep
##
InstallMethod (ImageOfContractingHomotopy_LargeGroupRep,
        [IsPartialContractingHomotopy,IsInt,IsDenseList],
        function(homotopy,term,word)
    local   resolution,  wordCoeffs,  grpWordUndir,  i,  coeffsgrpels,  
            zero,  zerocoeff,  zerovec,  upzerovec,  family,  
            embedding,  returnword,  g,  image,  letter,  firstimage,  
            upcell,  sign,  bound,  boundi,  pos,  otherimages,  j;
    
    resolution:=ResolutionOfContractingHomotopy(homotopy);
    if not IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        Error("invalid <word>");
    fi;
    
    wordCoeffs:=List([1..Size(word)],i->[]);
    grpWordUndir:=List([1..Size(word)],i->[]);
    for i in [1..Size(word)]
      do
        coeffsgrpels:=CoefficientsAndMagmaElementsAsLists(word[i]);
        wordCoeffs[i]:=coeffsgrpels[1];
        grpWordUndir[i]:=coeffsgrpels[2];
    od;
    
    zero:=Zero(GroupRingOfResolution(resolution));
    zerocoeff:=ZeroCoefficient(zero);
    zerovec:=ListWithIdenticalEntries(Size(word),zero);
    upzerovec:=ListWithIdenticalEntries(Dimension(resolution)(term+1),zero);
    family:=FamilyObj(zero);
    embedding:=Embedding(GroupOfResolution(resolution),GroupRingOfResolution(resolution));
    returnword:=upzerovec;
    for i in [1..Size(word)]
      do
        for g in [1..Size(grpWordUndir[i])]
          do
            image:=PartialContractingHomotopyLookup(homotopy,term,i,grpWordUndir[i][g]);
            if image=fail
               then
                letter:=ShallowCopy(zerovec);
                letter[i]:=Image(embedding,grpWordUndir[i][g]);
                if not IsUndirectedSubWord_LargeGroupRep(resolution,
                           MaximalSubspaceOfHomotopy_LargeGroupRep(homotopy,term),
                           letter
                           )
                   then
                    Error("not implemented yet");
                fi;
            else
                if image[2]<>[]
                   then
                    sign:=SignInt(image[2][1]);
                    firstimage:=sign*Image(embedding,image[2][2]);
                    upcell:=ShallowCopy(upzerovec);
                    upcell[AbsInt(image[2][1])]:=firstimage;
                    bound:=BoundaryOfFreeZGWordNC_LargeGroupRep(resolution,term+1,upcell);
                    ####
                    ## This assumes that there is one and only one <term>+1 face 
                    ## assigned to every <term> face.
                    ## This will not work for any other homotopy!
                    boundi:=CoefficientsAndMagmaElementsAsLists(bound[i]);
                    pos:=Position(boundi[2],grpWordUndir[i][g]);
                    Unbind(boundi[1][pos]);
                    Unbind(boundi[2][pos]);
                    bound[i]:=ElementOfMagmaRing(family,zerocoeff,Compacted(boundi[1]),Compacted(boundi[2]));
                    otherimages:=ImageOfContractingHomotopy_LargeGroupRep(homotopy,term,bound);
                    otherimages:=List(otherimages,x->wordCoeffs[i][g]*x);
                    returnword:=returnword-otherimages;
                    j:=AbsInt(image[2][1]);
                    returnword[j]:=returnword[j]+wordCoeffs[i][g]*firstimage;
                fi;
            fi;
        od;
    od;
    return -returnword;
    ## all those minusses aren't nice. But I don't want to go chasing signs
    ## again...
end);