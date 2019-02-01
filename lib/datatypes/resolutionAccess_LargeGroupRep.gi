#############################################################################
##
#W resolutionAccess_LargeGroupRep.gi 			 HAPcryst package		 Marc Roeder
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
    return [letter[1],GroupElementFromPosition(resolution,letter[2])];
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

InstallMethod(ConvertStandardWordNC,
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    return List(word,letter->ConvertStandardLetterNC(resolution,term,letter));
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
    return [letter[1],PositionInGroupOfResolution(resolution,letter[2])];
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
    return List(word,letter->ConvertLetterToStandardRepNC(resolution,term,letter));
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
    if not (
            Size(letter)=2
            and IsInt(letter[1])
            and AbsInt(letter[1])<=Dimension(resolution)(term)
            and letter[2] in GroupOfResolution(resolution)
            )
       then
        return false;
    else
        return true;
    fi;
end);        


#############################################################################
##
#O IsFreeZGWord_LargeGroupRep(<resolution>,<term>,<word>)
## 
## Check if <word> is an element of the <term>th module in <resolution>
##
##
InstallMethod(IsFreeZGWord_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,word)
    local   firstEntries,  secondEntries;
    if not ForAll(word,IsDenseList)
       then
        return false;
    fi;
    firstEntries:=List(word,i->AbsInt(i[1]));
    secondEntries:=Set(word,i->i[2]);
    if Maximum(firstEntries)<=Dimension(resolution)(term)
       and IsSubset(GroupOfResolution(resolution),secondEntries)
       then
        return true;
    else
        return false;
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
    local newgroupel;
    return [letter[1],letter[2]*g];
end);


#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupElt_LargeGroupRep(<resolution>,<letter>,<g>)
#O MultiplyFreeZGLetterWithGroupElt(<resolution>,<letter>,<g>)
##
##  Check input for sanity and delegate to NC version
##
InstallMethod(MultiplyFreeZGLetterWithGroupElt_LargeGroupRep,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,letter,g)
    if not (IsSubset(GroupOfResolution(resolution),[g,letter[2]])
            and IsInt(letter[1])
            )
       then
        Error("<letter> or <g> of wrong form");
    fi;
    return MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(resolution,letter,g);
end);


#############################################################################
##
InstallMethod(MultiplyFreeZGLetterWithGroupElt,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,letter,g)
    if not (IsSubset(GroupOfResolution(resolution),[g,letter[2]])
            and IsInt(letter[1])
            )
       then
        TryNextMethod();
    fi;
    return MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(resolution,letter,g);
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
    return List(word,cell->MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(resolution,cell,g));
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
    local   group;
    group:=GroupOfResolution(resolution);
    if not (ForAll(word,i->IsInt(i[1]) and i[2] in group)
            and g in group
            )
       then
        Error("<g> or <word> are not valid");
    fi;
    return MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(resolution,word,g);
end);


#############################################################################
##
InstallMethod(MultiplyFreeZGWordWithGroupElt,"For HapResolution",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject],
        function(resolution,word,g)
    local   group;
    group:=GroupOfResolution(resolution);
    if not (ForAll(word,i->IsInt(i[1]) and i[2] in group)
            and g in group
            )
       then
        TryNextMethod();
    fi;
    return MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(resolution,word,g);
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
InstallMethod(BoundaryOfFreeZGLetterNC,"For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,cell)
    local   cell_LargeGroupRep,  boundary;
    cell_LargeGroupRep:=[cell[1],GroupElementFromPosition(resolution,cell[2])];
    boundary:=BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,cell_LargeGroupRep);
    Apply(boundary,i->[i[1],
            PositionInGroupOfResolutionNC(resolution,i[2])]);
    return boundary;
end);


#############################################################################
##
InstallMethod(BoundaryOfFreeZGLetterNC_LargeGroupRep,
        "For HapResolutions of large groups",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList],
        function(resolution,term,cell)
    local   sign,  boundary;
    sign:=SignInt(cell[1]);
    boundary:=resolution!.boundary2(resolution,term,AbsInt(cell[1]));
    boundary:=MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(resolution,boundary,cell[2]);
    if sign=-1
       then
        return NegateWord(boundary);
    else
        return boundary;
    fi;
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
    local   boundary,  letter,  letterbound;
    boundary:=[];
    for letter in word
      do
        letterbound:=BoundaryOfFreeZGLetterNC_LargeGroupRep(resolution,term,letter);
        boundary:=AddFreeWords(boundary,letterbound);
    od;
    return boundary;
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
        return BoundaryOfFreeZGWordNC_LargeGroupRep(resolution,term,letter);        
    elif IsFreeZGLetter(resolution,term,letter)
      then
        word_large:=ConvertWordToStandardRepNC(resolution,term,letter);
        return ConvertWordToStandardRepNC(resolution,term,BoundaryOfFreeZGWordNC(resolution,term,word_large));
    else
        TryNextMethod();
    fi;
end);
