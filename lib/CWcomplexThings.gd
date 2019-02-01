#############################################################################
##
#W CWcomplexThings.gd 			 HAPcryst package		 Marc Roeder
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
DeclareOperation("UndirectedBoundaryOfFreeZGLetterNC",[IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("UndirectedBoundaryOfFreeZGLetter",[IsHapResolutionRep,IsInt,IsDenseList]);

DeclareOperation("UndirectedBoundaryOfFreeZGWordNC",[IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("UndirectedBoundaryOfFreeZGWord",[IsHapResolutionRep,IsInt,IsDenseList]);


DeclareOperation("SubspaceListFromWordNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("SubspaceListFromWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);


DeclareOperation("IsConnectedWordNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("IsConnectedWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);


DeclareOperation("ConnectingPathNC",
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList]);
DeclareOperation("ConnectingPath",
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList,IsDenseList]);


DeclareOperation("IsContractibleWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("IsContractibleWordNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);


DeclareOperation("SphereContainingCell",
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList]);
DeclareOperation("SphereContainingCellNC",
        [IsHapResolutionRep,IsInt,IsDenseList,IsDenseList]);


DeclareOperation("ChainComplexFromWord",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("ChainComplexFromWordNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);

DeclareOperation("IsContractiblePartialSpace",
        [IsHapResolutionRep,IsInt,IsDenseList]);
DeclareOperation("IsContractiblePartialSpaceNC",
        [IsHapResolutionRep,IsInt,IsDenseList]);


DeclareOperation("ChainComplexFromPartialSpace",
        [IsHapResolutionRep,IsDenseList]);
DeclareOperation("ChainComplexFromPartialSpaceNC",
        [IsHapResolutionRep,IsDenseList]);

