#############################################################################
##
#W resolutionAccess_generic.gi 			 HAPcryst package		 Marc Roeder
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
##  README:
## 
##  This file contains the basic methods for accessing resolutions in Hap
##  (fulfilling true=HapResolution(R) ).
##
##  Every representation of a HapResolution that differs in the way 
##  module elements are written, must have special methods for treating them.
##  This should be done in a catch-convert-delegate-convert way:
##
##  First implement a method having the same name <fname> as one of the below 
##  but applying to resolutions in the special representation (replacing the 
##  "[IsHapResolution" bit with "[IsMyNewHapResolutionRep")
##  This method should then call a function like <fname>_myRep doing all the
##  calculations in the new representation (probably calling more of the 
##  _myRep functions).
##  The output of <fname>_myRep should be converted into HapResolutionRep
##  notation and returned.
##
##  Even though it might be tempting not to, please obay the following rule:
## 
##  THERE MUST NOT BE A FUNCTION WHICH RETURNS DIFFERENT TYPES OF OUTPUT
##  DEPENDING ON THE INPUT.
##  


#############################################################################
##
##     First, some access functions for resolutions <R>
##
##  - The position of a group element in <R>'s enumeration
##  - The <n>th group element in <R>'s enumeration
##  - Check if the <n>th element of the group of <R> is known
##
##
#############################################################################


#############################################################################
##
#O PositionInGroupOfResolutionNC(<resolution>,<g>)
## 
##  find the position in <resolution>'s partial list of group elements
##  <resolution!.elts>. If <g> is not contained in <resolution!.elts>, it is
##  added and the length of <resolution!.elts> is returned.
##
InstallMethod(PositionInGroupOfResolutionNC, "For HapResolutions",
        [IsHapResolution,IsObject],
        function(resolution,g)
    local   pos;
    pos:=Position(resolution!.elts,g);
    if pos=fail
       then
        Add(resolution!.elts,g);
        pos:=Size(resolution!.elts);
    fi;
    return pos;
end);



#############################################################################
##
#O PositionInGroupOfResolution(<resolution>,<g>)
## 
##  find the position in <resolution>'s partial list of group elements
##  <resolution!.elts>. 
##  This checkes Membership in <resolution>'s group and then delegates
##  to PositionInGroupOfResolutionNC
##
InstallMethod(PositionInGroupOfResolution, "For HapResolutions",
        [IsHapResolution,IsObject],
        function(resolution,g)
    local   pos;
    if not g in GroupOfResolution(resolution)
       then
        return fail;
    fi;
    return PositionInGroupOfResolutionNC(resolution,g);
end);



#############################################################################
##
#O IsValidGroupInt(<resolution>,<n>)
## 
##  test if there are <n> elements of the group of <resolution> known to the 
##  (partial) elements list
##
InstallMethod(IsValidGroupInt,"for HapResolutions",
        [IsHapResolution,IsPosInt],
        function(resolution,n)
    return Size(resolution!.elts)>=n;
end);


#############################################################################
##
#O GroupElementFromPosition(<resolution>,<n>)
##
##  returns the <n>th element of <resolution>'s (partial) list of group 
##  elements.
##
InstallMethod(GroupElementFromPosition,"for HapResolutions",
        [IsHapResolution,IsPosInt],
        function(resolution,n)
    return resolution!.elts[n];
end);


#############################################################################
##
#O MultiplyGroupEltsNC(<resolution>,<x>,<y>)
##
##
InstallMethod(MultiplyGroupEltsNC,"for HapResolutions",
        [IsHapResolution,IsPosInt,IsPosInt],
        function(resolution,x,y)
    local   xgroup,  ygroup;
    xgroup:=GroupElementFromPosition(resolution,x);
    ygroup:=GroupElementFromPosition(resolution,y);
    return PositionInGroupOfResolutionNC(resolution,xgroup*ygroup);
end);


#############################################################################
##
#O MultiplyGroupElts(<resolution>,<x>,<y>)
##
##
InstallMethod(MultiplyGroupElts,"for HapResolutions",
        [IsHapResolution,IsPosInt,IsPosInt],
        function(resolution,x,y)    
    if not (IsValidGroupInt(resolution,x)
            and IsValidGroupInt(resolution,y)
            )
       then
        Error("<x> and <y> must represent elements of <resolution>'s group");
    else
       return MultiplyGroupEltsNC(resolution,x,y); 
    fi;
end);



#############################################################################
##
##  This was it. From here on, ther will be no "!"s.
## 
##  Now, some functions for manipulating elements of the free modules
##  of a resolution <R>
##
##   - Check if something really is a <term>-letter
##   - Check if something really is a an element of the <term>th module
##   - Multiply a letter with a group element
##   - Multiply a module element (word) with a group element
##
##  note that group elements are represented by their index in the enumeration
##  of the group.
##   
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
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term, letter)
    if IsFreeZGLetter(resolution,term,letter)
       then
        return IsHapResolutionRep;
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
        [IsHapResolutionRep,IsInt,IsDenseList],
        function(resolution,term, word)
    if IsFreeZGWord(resolution,term,word)
       then
        return IsHapResolutionRep;
    else
        TryNextMethod();
    fi;
end);


#############################################################################
##
#O IsFreeZGLetter(<resolution>,<term>,<letter>)
## 
## check if <letter> is a letter of the <term>th module of <resolution>.
## A letter is a word of length 1.
##
InstallMethod(IsFreeZGLetter,"For HapResolutions",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,letter)
    if not (
            Size(letter)=2
            and ForAll(letter,IsInt)
            and AbsInt(letter[1])<=Dimension(resolution)(term)
            and IsValidGroupInt(resolution,letter[2])
            )
       then
        return false;
    else
        return true;
    fi;
end);



#############################################################################
##
#O IsFreeZGWord(<resolution>,<term>,<word>)
## 
## Check if <word> is an element of the <term>th module in <resolution>
##
InstallMethod(IsFreeZGWord,"For HapResolutions",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,word)
    if not ForAll(word,IsDenseList)
       then
        return false;
    else
        return IsDenseList(word) and ForAll(word,c->IsFreeZGLetter(resolution,term,c));
    fi;
end);



#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupEltNC(<resolution>,<letter>,<g>)
##
##  given a pair <letter> of positive integers which represent a generator-
##  group element pair, this returns the letter multiplied with the group 
##  element <g>.
## 
InstallMethod(MultiplyFreeZGLetterWithGroupEltNC,"For HapResolution",
        [IsHapResolution,IsDenseList,IsPosInt],
        function(resolution,letter,g)
    local newgroupel;
    newgroupel:=MultiplyGroupEltsNC(resolution,letter[2],g);
    return [letter[1],newgroupel];
end);


#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupElt(<resolution>,<letter>,<g>)
##
##  Check input for sanity and delegate to NC version
##
InstallMethod(MultiplyFreeZGLetterWithGroupElt,"For HapResolution",
        [IsHapResolution,IsDenseList,IsPosInt],
        function(resolution,letter,g)
    if not (IsValidGroupInt(resolution,letter[2])
            and IsValidGroupInt(resolution,g)
            )
       then
        Error("invalid group element indices");
    fi;
    if not IsInt(letter[1])
       then
        Error("first entry in letter must be an integer");
    fi;
    return MultiplyFreeZGLetterWithGroupEltNC(resolution,letter,g);
end);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupEltNC(<resolution>,<word>,<g>)
## 
##  multiplies the word <word> with the group element <g>.
##  No checks are performed.
##
InstallMethod(MultiplyFreeZGWordWithGroupEltNC,"For HapResolution",
        [IsHapResolution,IsDenseList,IsPosInt],
        function(resolution,word,g)
    return List(word,letter->MultiplyFreeZGLetterWithGroupEltNC(resolution,letter,g));
end);


#############################################################################
##
#O MultiplyFreeZGWordWithGroupElt(<resolution>,<word>,<g>)
## 
##  Check input and delegate to NC version.
##
InstallMethod(MultiplyFreeZGWordWithGroupElt,"For HapResolution",
        [IsHapResolution,IsDenseList,IsPosInt],
        function(resolution,word,g)
    if not IsFreeZGWord(resolution,word)
       then
        Error("<word> must be a valid ZG word");
    fi;
    if not IsValidGroupInt(resolution,g)
       then
        Error("<g> is not a valid group element index");
    fi;
    return MultiplyFreeZGWordWithGroupEltNC(resolution,word,g);
end);



    
#############################################################################
##
#O BoundaryOfFreeZGLetterNC(<resolution>,<term>,<letter>)
## 
##  calculates the boundary of a letter in the <term>th module.
##
InstallMethod(BoundaryOfFreeZGLetterNC,"For HapResolution",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,letter)
    local   sign,  boundary;
    sign:=SignInt(letter[1]);
    boundary:=BoundaryMap(resolution)(term,AbsInt(letter[1]));
    boundary:=MultiplyFreeZGWordWithGroupEltNC(resolution,boundary,letter[2]);
    if sign=-1
       then
        return NegateWord(boundary);
    else
        return boundary;
    fi;
end);



#############################################################################
##
#O BoundaryOfFreeZGLetter(<resolution>,<term>,<letter>)
## 
##  checks input and delegates to NC version
##
InstallMethod(BoundaryOfFreeZGLetter,"For HapResolution",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,letter)
        
    if not IsFreeZGLetter(resolution,term,letter)
       then
        Error("<letter> is not a proper letter");
    fi;
    return BoundaryOfFreeZGLetterNC(resolution,term,letter);
end);



#############################################################################
##
#O BoundaryOfFreeZGWordNC(<resolution>,<term>,<word>)
##
##  calculate the boundary of the element <word> of the <term>th module of the 
##  resolution <resolution>.
##  No checks done.
##
InstallMethod(BoundaryOfFreeZGWordNC,"For HapResolution",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,word)
    local   boundary,  letter,  letterbound;
    boundary:=[];
    for letter in word
      do
        letterbound:=BoundaryOfFreeZGLetterNC(resolution,term,letter);
        boundary:=AddFreeWords(boundary,letterbound);
    od;
    return boundary;
end);


#############################################################################
##
#O BoundaryOfFreeZGWord(<resolution>,<term>,<word>)
##
##  Check input and delegate to NC version.
##
InstallMethod(BoundaryOfFreeZGWord,"For HapResolution",
        [IsHapResolution,IsInt,IsDenseList],
        function(resolution,term,word)
    if not IsFreeZGWord(resolution,term,word)
       then
        Error("<word> is not an element of the <term>th module");
    fi;
    return BoundaryOfFreeZGWordNC(resolution,term,word);
end);

