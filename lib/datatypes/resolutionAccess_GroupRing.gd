#############################################################################
##
#W resolutionAccess_GroupRing.gd 			 HAPcryst package		 Marc Roeder
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
##  This file defines a representation for HapResolutions of lrge groups.
##
##  Elements of the modules in these resolutions are integer- group element 
##  pairs.
##
##
DeclareRepresentation("IsHapLargeGroupResolutionRep",
        IsHapResolutionRep,
        ["dimension2",
         "boundary2"]
        );


#############################################################################
##
#O Dimension(<resolution>,<term>)
##
##  returns the dimension of the <term>th module in <resolution>.
##
DeclareOperation("Dimension",[IsHapLargeGroupResolutionRep,IsInt]);


#############################################################################
##
#O GroupRingOfResolution(<resolution>)
##
## 
DeclareOperation("GroupRingOfResolution",[IsHapLargeGroupResolutionRep]);



#############################################################################
##
#O BoundaryMap(<resolution>)
##
##  overload the Hap function using !.boundary2
##
#DeclareOperation("BoundaryMap",[IsHapLargeGroupResolutionRep]);


#############################################################################
##
#O MultiplyGroupEltsNC(<resolution>,<x>,<y>)
#O MultiplyGroupEltsNC_LargeGroupRep(<resolution>,<x>,<y>)
##
##  catch, convert, delegate, convert
##
DeclareOperation("MultiplyGroupEltsNC",
        [IsHapLargeGroupResolutionRep,IsPosInt,IsPosInt]);
DeclareOperation("MultiplyGroupEltsNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject]);



#############################################################################
##
#O MultiplyGroupElts_LargeGroupRep(<resolution>,<x>,<y>)
##
##  internal method for this representation.
##
DeclareOperation("MultiplyGroupElts_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject]);

#############################################################################
##
#O MultiplyGroupElts(<resolution>,<x>,<y>)
##
##  for x,y in other representations
##
DeclareOperation("MultiplyGroupElts",
        [IsHapLargeGroupResolutionRep,IsObject,IsObject]);


#############################################################################
##
#O ConvertStandardLetterNC(<resolution>,<term>,<letter>)
#O ConvertStandardLetter(<resolution>,<term>,<letter>)
##
DeclareOperation("ConvertStandardLetterNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("ConvertStandardLetter",
        [IsHapResolutionRep,IsInt,IsDenseList]);

#############################################################################
##
#O ConvertStandardWordNC(<resolution>,<term>,<word>)
#O ConvertStandardWord(<resolution>,<term>,<word>)
##
DeclareOperation("ConvertStandardWordNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("ConvertStandardWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);


#############################################################################
##
#O ConvertLetterToStandardRepNC
#O ConvertLetterToStandardRep
##
DeclareOperation("ConvertLetterToStandardRepNC",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);
DeclareOperation("ConvertLetterToStandardRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);

#############################################################################
##
#O ConvertLargeGroupRepWordToStandardRepNC
#O ConvertLargeGroupRepWordToStandardRep
##
DeclareOperation("ConvertWordToStandardRepNC",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);
DeclareOperation("ConvertWordToStandardRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);


#############################################################################
##
#O IsFreeZGLetterNoTermCheck_LargeGroupRep(resoltuion,letter)
## 
## tests if <letter can be a letter of any module of <resolution>.
## It is not checked whether the length of <letter> actually matches up with
## some dimension of a module in <resolution>
##
DeclareOperation("IsFreeZGLetterNoTermCheck_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList]);


#############################################################################
##
#O IsFreeZGLetter_LargeGroupRep(<resolution>,<term>,<letter>)
## 
## check if <letter> is a letter of the <term>th module of <resolution>.
## A letter is a word of length 1.
##
##
DeclareOperation("IsFreeZGLetter_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);



#############################################################################
##
#O IsFreeZGWordNoTermCheck_LargeGroupRep(resoltuion,word)
## 
## tests if <word> can be a word of any module of <resolution>.
## It is not checked whether the length of <word> actually matches up with
## some dimension of a module in <resolution>
##
DeclareOperation("IsFreeZGWordNoTermCheck_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList]);



#############################################################################
##
#O IsFreeZGWord_LargeGroupRep(<resolution>,<term>,<word>)
##
## Check if <word> is an element of the <term>th module in <resolution>
##
##
DeclareOperation("IsFreeZGWord_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);


#############################################################################
##
#O MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep(<resolution>,<letter>,<g>)
##
##  given a pair <letter> of positive integers which represent a generator-
##  group element pair, this returns the letter multiplied with the group
##  element <g>.
##
##
DeclareOperation("MultiplyFreeZGLetterWithGroupEltNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);


#############################################################################
##
#O MultiplyFreeZGLetterWithGroupElt_LargeGroupRep(<resolution>,<letter>,<g>)
#O MultiplyFreeZGLetterWithGroupElt(<resolution>,<letter>,<g>)
##
##  Check input for sanity and delegate to NC version
##
DeclareOperation("MultiplyFreeZGLetterWithGroupElt_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);
DeclareOperation("MultiplyFreeZGLetterWithGroupElt",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);



#############################################################################
##
#O MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep(<resolution>,<word>,<g>)
##
##  multiplies the word <word> with the group element <g>.
##  No checks are performed.
##
DeclareOperation("MultiplyFreeZGWordWithGroupEltNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);
DeclareOperation("MultiplyFreeZGWordWithGroupEltNC",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);


#############################################################################
##
#O MultiplyFreeZGWordWithGroupElt_LargeGroupRep(<resolution>,<word>,<g>)
##
##  Check input and delegate to NC version.
##
DeclareOperation("MultiplyFreeZGWordWithGroupElt_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsDenseList,IsObject]);


#############################################################################
##
##
DeclareOperation("BoundaryOfGenerator_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsPosInt]);
DeclareOperation("BoundaryOfGeneratorNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsPosInt]);



#############################################################################
##
#O BoundaryOfFreeZGLetterNC(<resolution>,<term>,<letter>)
#O BoundaryOfFreeZGLetterNC_LargeGroupRep(<resolution>,<term>,<letter>)
##
##  calculates the boundary of a letter in the <term>th module.
##
## catch, convert, delegate, convert
##
DeclareOperation("BoundaryOfFreeZGLetterNC",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);
DeclareOperation("BoundaryOfFreeZGLetterNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);
DeclareOperation("BoundaryOfFreeZGLetter",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);



#############################################################################
##
#O BoundaryOfFreeZGLetter_LargeGroupRep(<resolution>,<term>,<letter>)
##
##  checks input and delegates to NC version
##
DeclareOperation("BoundaryOfFreeZGLetter_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);



#############################################################################
##
#O BoundaryOfFreeZGWordNC_LargeGroupRep(<resolution>,<term>,<word>)
##
##  calculate the boundary of the element <word> of the <term>th module of the
##  resolution <resolution>.
##  No checks done.
##
DeclareOperation("BoundaryOfFreeZGWordNC_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);



#############################################################################
##
#O BoundaryOfFreeZGWord_LargeGroupRep(<resolution>,<term>,<word>)
#O BoundaryOfFreeZGWord(<resolution>,<term>,<word>)
##
##  Check input and delegate to NC version.
##
DeclareOperation("BoundaryOfFreeZGWord_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);
DeclareOperation("BoundaryOfFreeZGWord",
        [IsHapLargeGroupResolutionRep,IsInt,IsDenseList]);


#############################################################################
##
#O GeneratorsOfModuleOfResolution_LargeGroupRep(resolution,term)
##
##  returns generators of the <term>th module of <resolution> as a list 
##  of vectors of group ring elements.
##
DeclareOperation("GeneratorsOfModuleOfResolution_LargeGroupRep",
        [IsHapLargeGroupResolutionRep,IsInt]);

