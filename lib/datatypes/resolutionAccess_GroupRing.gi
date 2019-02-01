#############################################################################
##
#W resolutionAccess_GroupRing.gi 			 HAPcryst package		 Marc Roeder
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
##  This file implements a representation for HapResolutions of large groups
##  
##  Elemements of the modules of this resolution are represented by 
##  integer-group element pairs.
##
##  R!.elt must be present, but is not used for internal computations.
##    It is used for conversion to and from the standard representation.
##
##

HapLargeGroupResolution:=NewType(HapResolutionFamily,IsHapLargeGroupResolutionRep);


#############################################################################
##
#O Dimension(<resolution>)
##
##  overload the Hap function using !.diension2
##
InstallOtherMethod(Dimension,
        [IsHapLargeGroupResolutionRep],
        function(resolution)
    return function(k) return resolution!.dimension2(resolution,k);end;
end);

#############################################################################
##
#O Dimension(<resolution>,<term>)
##
##  returns the dimension of the <term>th module in <resolution>.
##
InstallOtherMethod(Dimension,
        [IsHapLargeGroupResolutionRep,IsInt],
        function(resolution,term)
    return resolution!.dimension2(resolution,term);
end);




#############################################################################
##
#O MultiplyGroupEltsNC(<resolution>,<x>,<y>)
#O MultiplyGroupEltsNC_LargeGroupRep(<resolution>,<x>,<y>)
##
##  catch, convert, delegate, convert
##
InstallMethod(MultiplyGroupEltsNC,"for HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsPosInt,IsPosInt],
        function(resolution,x,y)
    local   xgroup,  ygroup,  product;
    xgroup:=GroupElementFromPosition(resolution,x);
    ygroup:=GroupElementFromPosition(resolution,y);
    product:=MultiplyGroupEltsNC_LargeGroupRep(resolution,xgroup,ygroup);
    return PositionInGroupOfResolutionNC(resolution,product);
end);

InstallMethod(MultiplyGroupEltsNC_LargeGroupRep,"for HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject],
        function(resolution,x,y)
    return x*y;
end);




#############################################################################
##
#O MultiplyGroupElts_LargeGroupRep(<resolution>,<x>,<y>)
##
##  interenal method for this representation.
##
InstallMethod(MultiplyGroupElts_LargeGroupRep,"for HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject],
        function(resolution,x,y)    
    if not IsSubset(GroupOfResolution(resolution),[x,y])
       then
        Error("<x> and <y> must belong to <resolution>'s group");
    else
       return MultiplyGroupEltsNC_LargeGroupRep(resolution,x,y); 
    fi;
end);


#############################################################################
##
#O MultiplyGroupElts(<resolution>,<x>,<y>)
##
##  interenal method for this representation.
##
InstallMethod(MultiplyGroupElts,"for HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject],
        function(resolution,x,y)    
    if IsSubset(GroupOfResolution(resolution),[x,y])
       then
        return MultiplyGroupEltsNC_LargeGroupRep(resolution,x,y); 
    elif ForAll([x,y],i->IsValidGroupInt(resolution,i))
      then
        return MultiplyGroupEltsNC(resolution,x,y);
    else
        TryNextMethod();       
    fi;
end);

#############################################################################
##
## things which are used for the group ring things:
##
InstallMethod(GroupRingOfResolution,
        [IsHapLargeGroupResolutionRep],
        function(resolution)
    return resolution!.groupring;
end);



#############################################################################
##
##  No "!"s allowed beyond this point
## 
#############################################################################

#############################################################################
## 
#O StrongtestValidRepresentationForLetter(resolution,term,letter)
##
##  returns the strongest representation in which <letter> is a valid letter
##  for <resolution>
##
InstallMethod(StrongestValidRepresentationForLetter,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term, letter)
    if IsFreeZGLetter_LargeGroupRep(resolution,term,letter)
       then
        return IsHapLargeGroupResolutionRep;
    else
        TryNextMethod();
    fi;
end);

#############################################################################
## 
#O StrongtestValidRepresentationForWord(resolution,term,word)
##
##  returns the strongest representation in which <word> is a valid letter
##  for <word>
##

InstallMethod(StrongestValidRepresentationForWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term, word)
    if IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        return IsHapLargeGroupResolutionRep;
    else
        TryNextMethod();
    fi;
end);
        

#############################################################################
##
#O ConvertStandardLetterToLargeGroupRepNC(<resolution>,<term>,<letter>)
#O ConvertStandardLetterToLargeGroupRep(<resolution>,<term>,<letter>)
##
InstallMethod(ConvertStandardLetter,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    if not IsFreeZGLetter(resolution,term,letter)
       then
        Error("<letter> is not a valid letter");
    fi;
    return ConvertStandardLetterNC(resolution,term,letter);
end);


InstallMethod(ConvertStandardLetterNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    local   position,  zero,  family,  zeroCoeff,  dim,  vector,  i;
    position:=AbsInt(letter[1]);
    zero:=Zero(GroupRingOfResolution(resolution));
    family:=FamilyObj(zero);
    zeroCoeff:=ZeroCoefficient(zero);
    dim:=Dimension(resolution,term);
    vector:=[];
    for i in [dim,dim-1..1]
      do
        if i=position
           then
            vector[i]:=ElementOfMagmaRing(family,
                               zeroCoeff,
                               [SignInt(letter[1])],
                               [GroupElementFromPosition(resolution,letter[2])]
                               );
        else
            vector[i]:=zero;
        fi;
    od;
    return vector;
end);


#############################################################################
##
#O ConvertStandardWordNC(<resolution>,<term>,<letter>)
#O ConvertStandardWord(<resolution>,<term>,<letter>)
##
InstallMethod(ConvertStandardWord,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    if not IsFreeZGWord(resolution,term,word)
       then
        Error("<word> is not a valid word");
    fi;
    return ConvertStandardWordNC(resolution,term,word);
end);


 ### This method needs improvement:
InstallMethod(ConvertStandardWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    return Sum(List(word,letter->ConvertStandardLetterNC(resolution,term,letter)));
end);


#############################################################################
##
#O ConvertLetterToStandardRepNC
#O ConvertLetterToStandardRep
##
InstallMethod(ConvertLetterToStandardRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    if not IsFreeZGLetter_LargeGroupRep(resolution,term,letter)
       then
        Error("<letter> is not a valid letter in large group representation.");
    fi;
    return ConvertLetterToStandardRepNC(resolution,term,letter);
end);

InstallMethod(ConvertLetterToStandardRepNC,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    local   zero,  pos,  coeffsAndGroupElts;
    zero:=Zero(GroupRingOfResolution(resolution));
    pos:=Position(letter,i->i<>zero);
    coeffsAndGroupElts:=CoefficientsAndMagmaElements(letter[pos]);
    return [pos*SignInt(coeffsAndGroupElts[2]),PositionInGroupOfResolution(resolution,coeffsAndGroupElts[1])];
end);



#############################################################################
##
#O ConvertWordToStandardRepNC
#O ConvertWordToStandardRep
##
InstallMethod(ConvertWordToStandardRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    if not IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        Error("<letter> is not a valid letter in large group representation.");
    fi;
    return ConvertWordToStandardRepNC(resolution,term,word);
end);

InstallMethod(ConvertWordToStandardRepNC,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    local   zero,  stdword,  pos,  coeffsAndGroupElts,  g,  sign,  
            mult;
    zero:=Zero(GroupRingOfResolution(resolution));
    stdword:=[];
    for pos in [1..Size(word)]
      do
        if word[pos]<>zero 
           then
            coeffsAndGroupElts:=CoefficientsAndMagmaElements(word[pos]);
            for g in 2*[0..Size(coeffsAndGroupElts)/2-1]+1
              do
                sign:=SignInt(coeffsAndGroupElts[g+1]);
                mult:=AbsInt(coeffsAndGroupElts[g]);
                Add(stdword,[sign*pos,PositionInGroupOfResolutionNC(resolution,coeffsAndGroupElts[g])]);
            od;
        fi;
    od;
    return stdword;
end);


#############################################################################
##
## In this representation, it is easy to check if the letter can be 
## an element of a certain module, if this check is passed.
## As we need this several times, it gets a special function:
##
InstallMethod(IsFreeZGLetterNoTermCheck_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,letter)
    local   checkonly0,  zero,  i,  coeffsAndGroupElts;
    
    checkonly0:=false;
    zero:=Zero(GroupRingOfResolution(resolution));
    for i in letter
      do
        if not i in GroupRingOfResolution(resolution)
           then
            return false;
        elif checkonly0 
          then
            if i<>zero 
               then
                return false;
            fi;
        elif i<>zero
          then
            coeffsAndGroupElts:=CoefficientsAndMagmaElements(i);
            if Size(coeffsAndGroupElts)>2
               then
                return false;
            elif AbsInt(coeffsAndGroupElts[2])<>1
              then
                return false;
            elif not coeffsAndGroupElts[1] in GroupOfResolution(resolution)
              then
                return false;
            else
                checkonly0:=true;
            fi;
        fi;
    od;
    return checkonly0;
end);

#############################################################################
##
#O IsFreeZGLetter_LargeGroupRep(<resolution>,<term>,<letter>)
## 
## check if <letter> is a letter of the <term>th module of <resolution>.
## A letter is a word of length 1.
##
##
InstallMethod(IsFreeZGLetter_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    if Dimension(resolution,term)<>Size(letter)
       then
        return false;
    else
        return IsFreeZGLetterNoTermCheck_LargeGroupRep(resolution,letter);
    fi;
end);        


#############################################################################
##
## In this representation, it is easy to check if the word can be 
## an element of a certain module, if this check is passed.
## As we need this several times, it gets a special function:
##
InstallMethod(IsFreeZGWordNoTermCheck_LargeGroupRep,
        "For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList],
        function(resolution,word)
    local   group,  groupring,  zero,  i,  coeffsAndGroupElts,  j;
    group:=GroupOfResolution(resolution);
    groupring:=GroupRingOfResolution(resolution);
    zero:=Zero(groupring);
    for i in word
      do
        if not i in groupring
           then
            return false;
        else 
            coeffsAndGroupElts:=CoefficientsAndMagmaElements(i);
            if coeffsAndGroupElts<>[]
               then
                for j in [0..Size(coeffsAndGroupElts)/2-1]
                  do
                    if not coeffsAndGroupElts[2*j+1] in group
                       then
                        return false;
                    fi;
                od;
            fi;
        fi;
    od;
    return true;
end);

#############################################################################
##
#O IsFreeZGWord_LargeGroupRep(<resolution>,<term>,<word>)
## 
## Check if <word> is an element of the <term>th module in <resolution>
##
##
InstallMethod(IsFreeZGWord_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    if Size(word)<>Dimension(resolution,term)
       then
        return false;
    else
        return IsFreeZGWordNoTermCheck_LargeGroupRep(resolution,word);
    fi;
end);



#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(<resolution>,<letter>,<g>)
##
##  given a pair <letter> of positive integers which represent a generator-
##  group element pair, this returns the letter multiplied with the group 
##  element <g>.
##
##
InstallMethod(MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,letter,g)
    local   zero,  pos,  returnvector;
    zero:=Zero(GroupRingOfResolution(resolution));
    pos:=PositionProperty(letter,i->i<>zero);
    returnvector:=ShallowCopy(letter);
    returnvector[pos]:=returnvector[pos]*g;
    return returnvector;
end);


#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupElt_LargeGroupRep(<resolution>,<letter>,<g>)
#O MultiplyFreeZGLetterWithGroupElt(<resolution>,<letter>,<g>)
##
##  Check input for sanity and delegate to NC version
##
InstallMethod(MultiplyFreeZGLetterWithGroupElt_LargeGroupRep,
        "For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,letter,g)
    if not IsFreeZGLetterNoTermCheck_LargeGroupRep(resolution,letter)
       then
        Error("<letter> or <g> of wrong form");
    fi;
    return MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(resolution,letter,g);
end);


#############################################################################
##
InstallMethod(MultiplyFreeZGLetterWithGroupElt,
        "For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,letter,g)
    
    if IsFreeZGLetterNoTermCheck_LargeGroupRep(resolution,letter)
       then
        return MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(resolution,letter,g);
    else
        TryNextMethod();
    fi;
end);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(<resolution>,<word>,<g>)
## 
##  multiplies the word <word> with the group element <g>.
##  No checks are performed.
##
InstallMethod(MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,word,g)
    return List(word,i->i*g);
end);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupElt_LargeGroupRep(<resolution>,<word>,<g>)
#O MultiplyFreeZGWordWithGroupElt(<resolution>,<word>,<g>)
## 
##  Check input and delegate to NC version.
##
InstallMethod(MultiplyFreeZGWordWithGroupElt_LargeGroupRep,"For HapResolution",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,word,g)
    if not (g in GroupOfResolution(resolution)
            and IsFreeZGWordNoTermCheck_LargeGroupRep(resolution,word)
            )
       then 
        Error("group element or word do not belong to resolution");
    else
        return MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(resolution,word,g);
    fi;
end);


#############################################################################
##
## BoundaryOfGererator_LargeGroupRep
##
InstallMethod(BoundaryOfGenerator_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsPosInt],
        function(resolution,term,gen)
    if not gen<=Dimension(resolution,term)
       then
        Error("so such generator");
    else
        return BoundaryOfGeneratorNC_LargeGroupRep(resolution,term,gen);
    fi;
end);

#############################################################################
##
InstallMethod(BoundaryOfGeneratorNC_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt,IsPosInt],
        function(resolution,term,gen)
    return resolution!.boundary2(resolution,term,gen);
end);

    
#############################################################################
##
#O BoundaryOfFreeZGLetterNC(<resolution>,<term>,<cell>)
#O BoundaryOfFreeZGLetterNC_LargeGroupRep(<resolution>,<term>,<cell>)
## 
##  calculates the boundary of a cell in the <term>th module.
##
## catch, convert, delegate, convert
##
#InstallMethod(BoundaryOfFreeZGLetterNC,"For HapResolutions of large groups",
#        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
#        function(resolution,term,cell)
#    local   cell_LargeGroupRep,  boundary;
#     cell_LargeGroupRep:=[cell[1],GroupElementFromPosition(resolution,cell[2])];
#    boundary:=BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,cell_LargeGroupRep);
#    Apply(boundary,i->[i[1],
#            PositionInGroupOfResolutionNC(resolution,i[2])]);
#    return boundary;
#end);


#############################################################################
##
InstallMethod(BoundaryOfFreeZGLetterNC_LargeGroupRep,
        "For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,cell)
    local   zero,  pos,  boundary;
    zero:=Zero(GroupRingOfResolution(resolution));
    pos:=PositionProperty(cell,i->i<>zero);
    boundary:=resolution!.boundary2(resolution,term,pos);
    return boundary*cell[pos];
end);



#############################################################################
##
#O BoundaryOfFreeZGLetter_LargeGroupRep(<resolution>,<term>,<letter>)
#O BoundaryOfFreeZGLetter(<resolution>,<term>,<letter>)
## 
##  checks input and delegates to NC version
##
InstallMethod(BoundaryOfFreeZGLetter_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
        
    if not IsFreeZGLetter_LargeGroupRep(resolution,term,letter)
       then
        Error("<letter> is not a proper letter");
    fi;
    return BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,letter);
end);


#############################################################################
##
InstallMethod(BoundaryOfFreeZGLetter,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    local   letter_large;
    if IsFreeZGLetter_LargeGroupRep(resolution,term,letter)
       then
        return BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,letter);        
    elif IsFreeZGLetter(resolution,term,letter)
      then
        letter_large:=ConvertStandardLetterNC(resolution,term,letter);
        return ConvertWordToStandardRepNC(resolution,term,BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,letter_large));
    else
        TryNextMethod();
    fi;

end);




#############################################################################
##
#O BoundaryOfFreeZGWordNC_LargeGroupRep(<resolution>,<term>,<word>)
##
##  calculate the boundary of the element <word> of the <term>th module of the 
##  resolution <resolution>.
##  No checks done.
##
InstallMethod(BoundaryOfFreeZGWordNC_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    local   zero,  one,  zerovec,  returnword,  dim,  getBoundaryFor,  
            boundary;
    zero:=Zero(GroupRingOfResolution(resolution));
    one:=One(GroupRingOfResolution(resolution));
    zerovec:=List([1..Size(word)],i->zero);
    returnword:=List([1..Dimension(resolution,term-1)],i->zero);
    for dim in [1..Size(word)]
      do
        if word[dim]<>zero
           then
            getBoundaryFor:=ShallowCopy(zerovec);
            getBoundaryFor[dim]:=one;
            boundary:=BoundaryOfFreeZGLetter_LargeGroupRep(resolution,term,getBoundaryFor)*word[dim];
            returnword:=returnword+boundary;
        fi;
    od;
    return returnword;
end);


#############################################################################
##
#O BoundaryOfFreeZGWord_LargeGroupRep(<resolution>,<term>,<word>)
#O BoundaryOfFreeZGWord(<resolution>,<term>,<word>)
##
##  Check input and delegate to NC version.
##
InstallMethod(BoundaryOfFreeZGWord_LargeGroupRep,"For HapResolution",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    if not IsFreeZGWord_LargeGroupRep(resolution,term,word)
       then
        Error("<word> is not an element of the <term>th module");
    fi;
    return BoundaryOfFreeZGWordNC_LargeGroupRep(resolution,term,word);
end);


#############################################################################
##
InstallMethod(BoundaryOfFreeZGWord,
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,letter)
    local   word_large;
    if IsFreeZGWord_LargeGroupRep(resolution,term,letter)
       then
        return ConvertWordToStandardRepNC(resolution,term,BoundaryOfFreeZGWordNC_LargeGroupRep(resolution,term,letter)
                       );        
    elif IsFreeZGLetter(resolution,term,letter)
      then
        word_large:=ConvertStandardWordNC(resolution,term,letter);
        return ConvertWordToStandardRepNC(resolution,term,BoundaryOfFreeZGWordNC_LargeGroupRep(resolution,term,word_large));
    else
        TryNextMethod();
    fi;
end);


#############################################################################
##
InstallMethod(GeneratorsOfModuleOfResolution_LargeGroupRep,
        [IsHapLargeGroupResolutionRep,IsInt],
        function(resolution,term)
    local   dim,  zero,  one,  vector,  generators,  i,  generator;
    dim:=Dimension(resolution,term);
    zero:=Zero(GroupRingOfResolution(resolution));
    one:=One(GroupRingOfResolution(resolution));
    vector:=List([1..dim],i->zero);
    generators:=[];
    for i in [1..dim]
      do
        generator:=ShallowCopy(vector);
        generator[i]:=one;
        Add(generators,generator);
    od;
    return generators;
end);
