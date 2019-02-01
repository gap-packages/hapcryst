#############################################################################
##
#W resolutionAccess_generic.gd 			 HAPcryst package		 Marc Roeder
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
#O PositionInGroupOfResolutionNC(<resolution>,<g>)
## 
##  find the position in <resolution>'s partial list of group elements
##  <resolution!.elts>. If <g> is not contained in <resolution!.elts>, it is
##  added and the length of <resolution!.elts> is returned.
##
DeclareOperation("PositionInGroupOfResolutionNC",
        [IsHapResolution,IsObject]);


#############################################################################
##
#O PositionInGroupOfResolution(<resolution>,<g>)
## 
##  find the position in <resolution>'s partial list of group elements
##  <resolution!.elts>. 
##  This checkes Membership in <resolution>'s group and then delegates
##  to PositionInGroupOfResolutionNC
##
DeclareOperation("PositionInGroupOfResolution",
        [IsHapResolution,IsObject]);



#############################################################################
##
#O IsValidGroupInt(<resolution>,<n>)
## 
##  test if there are <n> elements of the group of <resolution> known to the 
##  (partial) elements list
##
DeclareOperation("IsValidGroupInt",
        [IsHapResolution,IsPosInt]);


#############################################################################
##
#O GroupElementFromPosition(<resolution>,<n>)
##
##  returns the <n>th element of <resolution>'s (partial) list of group 
##  elements.
##
DeclareOperation("GroupElementFromPosition",
        [IsHapResolution,IsPosInt]);
        


#############################################################################
##
#F MultiplyGroupEltsNC(<resolution>,<x>,<y>)
##
##  multiply two elements of the group associated with <resolution>. These
##  elements are represented as integers or group elements. Depending on
##  the kind of resolution they live in.
##  Hence, we have different methods for multiplying them.
##
DeclareOperation("MultiplyGroupEltsNC",
        [IsHapResolution,IsPosInt,IsPosInt]);


#############################################################################
##
#F MultiplyGroupElts(<resolution>,<x>,<y>)
##
##  Test if the input is sane and then delegate to MultiplyGroupEltsNC
##
DeclareOperation("MultiplyGroupElts",
        [IsHapResolution,IsPosInt,IsPosInt]);


#############################################################################
## 
#O StrongtestValidRepresentationForLetter(resolution,term,letter)
##
##  returns the strongest representation in which <letter> is a valid letter
##  for <resolution>
##
DeclareOperation("StrongestValidRepresentationForLetter",
        [IsHapResolutionRep,IsInt,IsDenseList]);


#############################################################################
## 
#O StrongtestValidRepresentationForWord(resolution,term,word)
##
##  returns the strongest representation in which <word> is a valid letter
##  for <word>
##
DeclareOperation("StrongestValidRepresentationForWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);



#############################################################################
##
#O IsFreeZGLetter(<resolution>,<term>,<letter>)
## 
## check if <letter> is a letter of the <term>th module of <resolution>.
## A letter is a word of length 1.
##
DeclareOperation("IsFreeZGLetter",
        [IsHapResolution,IsInt,IsDenseList]);


#############################################################################
##
#O IsFreeZGWord(<resolution>,<term>,<word>)
## 
## Check if <word> is an element of the <term>th module in <resolution>
##
DeclareOperation("IsFreeZGWord",[IsHapResolution,IsInt,IsDenseList]);


  
#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupEltNC(<resolution>,<letter>,<g>)
##
##  given a pair <letter> of positive integers which represent a generator-
##  group element pair, this returns the letter multiplied with the group 
##  element <g>.
## 
DeclareOperation("MultiplyFreeZGLetterWithGroupEltNC",
        [IsHapResolution,IsDenseList,IsPosInt]);


#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupElt(<resolution>,<letter>,<g>)
##
##  Check input for sanity and delegate to NC version
##
DeclareOperation("MultiplyFreeZGLetterWithGroupElt",
        [IsHapResolution,IsDenseList,IsPosInt]);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupEltNC(<resolution>,<word>,<g>)
## 
##  multiplies the word <word> with the group element <g>.
##  No checks are performed.
##
DeclareOperation("MultiplyFreeZGWordWithGroupEltNC",
        [IsHapResolution,IsDenseList,IsPosInt]);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupElt(<resolution>,<word>,<g>)
## 
##  Check input and delegate to NC version.
##
DeclareOperation("MultiplyFreeZGWordWithGroupElt",
        [IsHapResolution,IsDenseList,IsPosInt]);


#############################################################################
##
#O BoundaryOfFreeZGLetterNC(<resolution>,<term>,<letter>)
## 
##  calculates the boundary of a letter in the <term>th module.
##
DeclareOperation("BoundaryOfFreeZGLetterNC",
        [IsHapResolution,IsInt,IsDenseList]);


#############################################################################
##
#O BoundaryOfFreeZGLetter(<resolution>,<term>,<letter>)
## 
##  checks input and delegates to NC version
##
DeclareOperation("BoundaryOfFreeZGLetter",
        [IsHapResolution,IsInt,IsDenseList]);


#############################################################################
##
#O BoundaryOfFreeZGWordNC(<resolution>,<term>,<word>)
##
##  calculate the boundary of the element <word> of the <term>th module of the 
##  resolution <resolution>.
##  No checks done.
##
DeclareOperation("BoundaryOfFreeZGWordNC",
        [IsHapResolution,IsInt,IsDenseList]);


#############################################################################
##
#O BoundaryOfFreeZGWord(<resolution>,<term>,<word>)
##
##  check input and delegate to NC version.
##
DeclareOperation("BoundaryOfFreeZGWord",
        [IsHapResolution,IsInt,IsDenseList]);

