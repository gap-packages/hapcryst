#############################################################################
##
#W contractingHomotopy.gd 			 HAPcryst package		 Marc Roeder
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
##  "knownPartOfHomotopy" is a list of records with components
##   .space : a contractible space 
##   .map   : a list of lists of pairs such that 
##             the (k,i)^th entry contains pairs [g,[j,h]] where g,h are group elts
##             and j refers to a generator in term k+1. 
##             read as: i^th generator in term k times g gets mapped to 
##                      the j^th generator in term k+1 times h.
##
DeclareCategory("IsPartialContractingHomotopy",IsObject);

DeclareRepresentation("IsPartialContractingHomotopyRep",
        IsComponentObjectRep,
        ["resolution",
         "knownPartOfHomotopy"
         ]
        );


#############################################################################

DeclareOperation("ResolutionOfContractingHomotopy",[IsPartialContractingHomotopy]);


DeclareOperation("PartialContractingHomotopyLookup",
        [IsPartialContractingHomotopy,IsInt,IsPosInt,IsObject]);
DeclareOperation("PartialContractingHomotopyLookupNC",
        [IsPartialContractingHomotopy,IsInt,IsPosInt,IsObject]);


