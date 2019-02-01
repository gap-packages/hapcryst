#############################################################################
##
#W FundamentalDomain.gd 			 HAPcryst package		 Marc Roeder
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
#####################################
###### General functions for crystallographic groups.
###### They decide which of the below functions will be used.
###### If the group is Bieberbach, the Bieberbach method will 
###### be used. In the other cases, the geometric method will 
######################################

DeclareOperation("FundamentalDomainStandardSpaceGroup",
        [IsGroup]);
DeclareOperation("FundamentalDomainStandardSpaceGroup",
        [IsVector,IsGroup]);


#####################################
###### Geometric function for crystallographic groups with
###### standard-orthogonal point group:
######################################
DeclareOperation("FundamentalDomainFromGeneralPointAndOrbitPartGeometric",
        [IsVector,IsMatrix]);

#####################################
###### Functions for Bieberbach groups:
######################################
DeclareOperation("FundamentalDomainBieberbachGroupNC",
        [IsGroup]);
DeclareOperation("FundamentalDomainBieberbachGroupNC",
        [IsVector,IsGroup]);
DeclareOperation("FundamentalDomainBieberbachGroupNC",
        [IsVector,IsGroup,IsMatrix]);

DeclareOperation("FundamentalDomainBieberbachGroup",
        [IsGroup]);
DeclareOperation("FundamentalDomainBieberbachGroup",
        [IsVector,IsGroup]);
DeclareOperation("FundamentalDomainBieberbachGroup",
        [IsVector,IsGroup,IsMatrix]);

#############################################################################
##
#O IsFundamentalDomainStandardSpaceGroup
##
##  tests if a given polyhedron is a fundamental domain of a crystallographic
##  group (not necessarily Bieberbach)
##
DeclareOperation("IsFundamentalDomainStandardSpaceGroup",
        [IsPolymakeObject,IsGroup]);

#############################################################################
##
#O IsFundamentalDomainBieberbachGroup
##
##  Tests if a given polyhedron is a fundamental domain for a group and if the
##  group is Bieberbach.
##  Returns 'true' if group is Bieberbach and polyhedron is fundamental domain
##  Returns 'false' if the polyhedron is not a fundamental domain 
##  (regardless of structure of group).
##  Returns 'fail' if the group is not Bieberbach
##
DeclareOperation("IsFundamentalDomainBieberbachGroup",
        [IsPolymakeObject,IsGroup]);