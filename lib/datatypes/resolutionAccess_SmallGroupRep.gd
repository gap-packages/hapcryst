#############################################################################
##
#W resolutionAccess_SmallGroupRep.gd 			 HAPcryst package		 Marc Roeder
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
##  This file defines a representation for HapResolutions of small groups.
##  
##  The additional feature of this representation is the multiplication
##  via a multiplication table.
##  Also, the list of group elements R!.elts is a set. So we can do binary
##  search occasionally.
##  
##  Elements of the modules in these resolutions are still pairs of integers.
##
##
#
DeclareRepresentation("IsHapSmallGroupResolutionRep",
        IsHapResolutionRep,
        ["dimension",
         "boundary",
         "homotopy",
         "group",
         "elts",
         "multtable",
         "properties"]);

        
HapSmallGroupResolution:=NewType(HapResolutionFamily,IsHapSmallGroupResolutionRep);




#############################################################################
##
#O PositionInGroupOfResolutionNC(<resolution>,<g>)
#O PositionInGroupOfResolution(<resolution>,<g>)
## 
##  find the position in <resolution>'s partial list of group elements
##  <resolution!.elts>. If <g> is not contained in <resolution!.elts>, it is
##  added and the length of <resolution!.elts> is returned.
##
DeclareOperation("PositionInGroupOfResolutionNC",
        [IsHapSmallGroupResolutionRep,IsObject]);
DeclareOperation("PositionInGroupOfResolution",
        [IsHapSmallGroupResolutionRep,IsObject]);



#############################################################################
##
#O MultiplyGroupEltsNC(<resolution>,<x>,<y>)
#O MultiplyGroupEltsNC_SmallGroupRep(<resolution>,<x>,<y>)
##
##  multiply two elements of the group associated with <resolution>. These
##  elements are represented as integers or group elements. Depending on
##  the kind of resolution they live in.
##  Hence, we have different methods for multiplying them.
##
DeclareOperation("MultiplyGroupEltsNC",
        [IsHapSmallGroupResolutionRep,IsPosInt,IsPosInt]);




#############################################################################
## 
#O MultiplyFreeZGLetterWithGroupEltNC(<resolution>,<letter>,<g>)
##
##  given a pair <letter> of positive integers which represent a generator-
##  group element pair, this returns the letter multiplied with the group 
##  element <g>.
##  This function does not check if the input is sane.
## 
##
DeclareOperation("MultiplyFreeZGLetterWithGroupEltNC",
        [IsHapSmallGroupResolutionRep,IsDenseList,IsPosInt]);
  
        
        
