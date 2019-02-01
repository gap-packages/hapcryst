#############################################################################
##
#W FundamentalDomain.gi 			 HAPcryst package		 Marc Roeder
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
#O FundamentalDomainStandardSpaceGroup
##
InstallMethod(FundamentalDomainStandardSpaceGroup,
        [IsGroup],
        function(group)
    local   dim;
    if not (IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group))
       then
        Error("group must be a StandardSpaceGroup acting on right");
    fi;
    dim:=DimensionOfMatrixGroup(group)-1;
    return FundamentalDomainStandardSpaceGroup(0*[1..dim],group);
end);


#############################################################################
##
#O FundamentalDomainStandardSpaceGroup
##
InstallMethod(FundamentalDomainStandardSpaceGroup,
        [IsVector,IsGroup],
        function(center,group)
    local   dim,  gram,  orbitstab;
    if not (IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group))
       then
        Error("group must be a StandardSpaceGroup acting on right");
    fi;

    dim:=Size(Representative(group))-1;
        gram:=GramianOfAverageScalarProductFromFiniteMatrixGroup(
                   PointGroup(group));

    if not IsTrivial(StabilizerOnSetsStandardSpaceGroup(group,[center]))
       then
        Error("center point not in general position");
    fi;
        return FundamentalDomainBieberbachGroupNC(center,group,gram);
end);


#############################################################################
##
#O IsFundamentalDomainStandardSpaceGroup
##
InstallMethod(IsFundamentalDomainStandardSpaceGroup,
        [IsPolymakeObject,IsGroup],
        function(poly,group)
    local   vertices,  vertexset,  dim,  box,  vertex,  orbitstab,  
            orbitpart,  i,  j,  facets,  polystab,  facet,  orbit,  
            facetstab,  staborbit;
    
    if not (IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group))
       then
        Error("group must be a StandardSpaceGroup acting on right");
    fi;
    
    vertices:=Polymake(poly,"VERTICES");
    vertexset:=Set(vertices);
    dim:=Size(Representative(vertices));
    
    ### First check that the images of <poly> do not overlap:
        
    box:=List([1..dim],i->[Minimum(List(vertices,v->v[i])),Maximum(List(vertices,v->v[i]))]);
    while vertexset<>[]
      do
        vertex:=Remove(vertexset);
        orbitstab:=OrbitStabilizerInUnitCubeOnRight(group,VectorModOne(vertex));
        #        orbitpart:=Concatenation(List(orbitstab.orbit,i->List(TranslationsToBox(i,box),j->i+j)));
        orbitpart:=[];
        for i in orbitstab.orbit
          do
            for j in TranslationsToBox(i,box)
              do
                Add(orbitpart,i+j);
            od;
        od;

        if ForAny(orbitpart,v->RelativePositionPointAndPolygon(v,poly) in ["INSIDE","FACET"])
           then
            return false;
        else
            SubtractSet(vertexset,orbitpart);
        fi;
    od;
    
    ### Now find out if the orbit covers the whole space.
    ### For this, we check whether every facet "has an image of the fundamental domain
    ### on either side":
    
    vertexset:=Set(vertices);
    facets:=Set(Polymake(poly,"VERTICES_IN_FACETS"),i->Set(i,j->vertices[j]));
    polystab:=StabilizerOnSetsStandardSpaceGroup(group,Set(vertices));
    while facets<>[]
      do
        facet:=facets[1];
        orbit:=OrbitPartInVertexSetsStandardSpaceGroup(group,facet,vertexset);
        if not ForAll(orbit,i-> i in facets)
           then
            return false;
        fi;
        
        if Size(polystab)=1
           then
            if Size(orbit)=1
               then
                facetstab:=StabilizerOnSetsStandardSpaceGroup(group,facet);
                if Size(facetstab)=1
                   then
                    #no image of <poly> can be on the other side of <facet>.
                    # If <facetstab> <>1, it contains an element flipping 
                    # <poly> to the other side of <facet>.
                    return false;
                fi;
                #If |orbit|>1, there must be another facet f' which gets mapped to
                # <facet>. As polystab=1, this maps <poly> tho the opposite side of
                # <facet>. So we are done in this case.
            fi;
        else
            staborbit:=Orbit(polystab,Set(facet,i->Concatenation(i,[1])),OnSets);
                # now there are two kinds of facets in <orbit>:
                # 1. those which are images under polystab
                # 2. the other ones.
                ## The second ones are ok. For the other ones, we have to 
                ## check if there  is an element of the facet stabilizer
                ## swapping <poly> to the other side of <facet>.
            if Size(staborbit)<Size(orbit)
               then
                facetstab:=StabilizerOnSetsStandardSpaceGroup(group,facet);
                if IsSubgroup(polystab,facetstab)
                   then
                   return false; 
                fi;
            fi;
        ## OK. This should be it.    
        fi;
        SubtractSet(facets,orbit);
    od;
    return true;
end);

#############################################################################
##
#O IsFundamentalDomainBieberbachGroup
##
InstallMethod(IsFundamentalDomainBieberbachGroup,
        [IsPolymakeObject,IsGroup],
        function(poly,group)
    local   isfd,  phi,  vertices,  facelattice,  faces,  face,  stab;
    
    isfd:=IsFundamentalDomainStandardSpaceGroup(poly,group);
    if not isfd
       then
        return false;
    elif IsPolycyclicGroup(group)
      then
        phi:=IsomorphismPcpGroup(group);
        if IsTorsionFree(Image(phi))
           then
            return true;
        else
            return fail;
        fi;
    else
        vertices:=Polymake(poly,"VERTICES");
        facelattice:=Polymake(poly,"FACE_LATTICE");
        for faces in facelattice
          do
            for face in faces
              do
                stab:=StabilizerOnSetsStandardSpaceGroup(group,Set(vertices{face}));
                if not IsTrivial(stab)
                   then
                    return fail;
                fi;
            od;
        od;
    fi;
    return true;
end);
        