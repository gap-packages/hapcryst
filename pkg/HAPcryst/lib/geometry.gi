#############################################################################
##
#W geometry.gi 			 HAPcryst package		 Marc Roeder
##
##  

##
#H @(#)$Id: geometry.gi, v 0.1.10 2012/04/19 20:12:51 gap Exp $
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
Revision.("/Users/roeder/gap/HAPcryst/HAPcryst/lib/geometry_gi"):=
	"@(#)$Id: geometry.gi, v 0.1.10 2012/04/19   20:12:51  gap Exp $";

# for two pairs, generate the inequality of the half-space "bewteen" them.
##############

InstallMethod(BisectorInequalityFromPointPair,
        [IsVector,IsVector,IsMatrix],
        function(center,point,gram)
    local   centergram,  pointgram,  inequality;
    if center=point 
       then 
        return fail;
    fi;              
    centergram:=center*gram; 
    pointgram:=point*gram;   
    inequality:=Concatenation([-centergram*center+pointgram*point],2*(centergram-pointgram));
    return inequality;
end); 

# Again, for the standard scalar product:

InstallMethod(BisectorInequalityFromPointPair,
        [IsVector,IsVector],
        function(center,point)
    local   centergram,  centernorm,  pointgram,  inequality;
    
    if center=point 
       then 
        return fail;
    fi;              
    inequality:=Concatenation([-center^2+point^2],2*(center-point));
    return inequality;
end); 


##############################

InstallMethod(WhichSideOfHyperplane,
        [IsVector,IsVector],
        function(vector,inequality)
    local   size,  eval;
    size:=Size(inequality);
    if not Size(vector)+1=size
       then
        Error("<vector> and <inequality> must be given by a vector.");
    fi;
    if not ForAll(Union(vector,inequality),IsRat)
       then
        Error("This does only work for rational vector spaces");
    fi;
    return WhichSideOfHyperplaneNC(vector,inequality);
end);


InstallMethod(WhichSideOfHyperplaneNC,
        [IsVector,IsVector],
        function(vector,inequality)
    local   eval;
    eval:=vector*inequality{[2..Size(inequality)]}+inequality[1];
    if eval>0
       then
        return 1;
    elif eval<0
      then
        return -1;
    else
        return 0;
    fi;
end);



########################################


InstallMethod(RelativePositionPointAndPolygon,
        [IsVector,IsPolymakeObject],
        function(point,poly)
    local   facetpositions,  facet,  side;
    
    if point in Polymake(poly,"VERTICES")
       then
        return "VERTEX";
    fi;
    if Polymake(poly,"DIM")=0
       then
        return "OUTSIDE";
    fi;
    facetpositions:=[];
    for facet in Polymake(poly,"FACETS")
      do
        side:=WhichSideOfHyperplane(point,facet);
        if side=-1
           then 
            return "OUTSIDE";
        else
            AddSet(facetpositions,side);
        fi;
    od;
    if facetpositions=[1]
       then
        return "INSIDE";
    else        
        return "FACET";
    fi;
end);

