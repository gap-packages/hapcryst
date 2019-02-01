#############################################################################
##
#W resolutionBieberbach.gi 			 HAPcryst package		 Marc Roeder
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
#O ResolutionBieberbachGroup(<group>)
##
InstallMethod(ResolutionBieberbachGroup,
        [IsGroup],
        function(group)
    return ResolutionBieberbachGroup(group,0*[1..Size(Representative(group))-1]);
end);

#############################################################################
##
#O ResolutionBieberbachGroup(<group>,<center>)
##
InstallMethod(ResolutionBieberbachGroup,"for affine cryst groups on right",
        [IsGroup,IsVector],
        function(group,center)
    local   gram,  poly,  fl;
    
    gram:=GramianOfAverageScalarProductFromFiniteMatrixGroup(PointGroup(group));
    if not Order(gram)=1
       then
        Info(InfoHAPcryst,2,"non standard");
    fi;
    poly:=FundamentalDomainBieberbachGroup(center,group,gram);
    fl:=FaceLatticeAndBoundaryBieberbachGroup(poly,group);
    RemoveFile(FullFilenameOfPolymakeObject(poly));
    return ResolutionFromFLandBoundary(fl, group);
end);


#############################################################################
##
#O ResolutionFromFLandBoundary(<fl>,<group>)
##
InstallMethod(ResolutionFromFLandBoundary,"for affine cryst groups on right",
        [IsRecord,IsGroup],
        function(fl,group)
    local   dimension,  dimension2,  boundary,  elts,  appendToElts,  
            boundary2,  groupring,  resolution,  homotopy,  hasse,  
            properties;
    dimension:=function(k)
        if k<0 or k>Size(fl.hasse)-1
           then
            return 0;
        else
            return Size(fl.hasse[k+1]);
        fi;
    end;
    
    dimension2:=function(resolution,k)
        if k<0 or k>Size(resolution!.hasse)-1
           then
            return 0;
        else
            return Size(resolution!.hasse[k+1]);
        fi;
    end;
    

    
    boundary:=function(k,j)
        local   word,  jsign,  stdword,  pos,  coeffsAndGroupElts,  g,  
                sign,  mult,  entry,  i;

        if k<=0 or k>=Size(fl.hasse)
           then
            return [];
        else            
            word:=fl.hasse[k+1][AbsInt(j)][2];
            jsign:=SignInt(j);
            stdword:=[];
            for pos in [1..Size(word)]
              do
                coeffsAndGroupElts:=CoefficientsAndMagmaElementsAsLists(word[pos][2]);
                for g in [1..Size(coeffsAndGroupElts[1])]
                  do
                    sign:=jsign*SignInt(coeffsAndGroupElts[1][g]);
                    mult:=AbsInt(coeffsAndGroupElts[1][g]);
                    entry:=[sign*word[pos][1],Position(fl.elts,coeffsAndGroupElts[2][g])];
                    for i in [1..mult]
                      do                      
                        Add(stdword,entry);
                    od;
                od;
            od;
        fi;
        return stdword;
    end;
    
    
    ## this is the usual HAP trick. 
    ## After the termination of ResolutionFromFLandBoundary, <elts> will not 
    ## be collected by GASMAN because appendToElts still uses it.
    ## It will just float around as a secret global (to appendToElts) 
    ## variable...
    ##
    ## same with <group>. 
    ##
    elts:=StructuralCopy(fl.elts);
    
    appendToElts:=function(g)
        if not g in group
           then
            Error("not an element of the right group");
        fi;
        Add(elts,g);    
    end;
    

    ##################################################
    ##################################################
    
    
    boundary2:=function(resolution,k,j)
        local   zero,  family,  vector,  term;
        if k<=0 or k>=Size(resolution!.hasse)
           then
            return [];
        else
            zero:=Zero(resolution!.groupring);
            family:=FamilyObj(zero);
            vector:=List([1..Dimension(resolution)(k-1)],i->zero);
            for term in resolution!.hasse[k+1][j][2]
              do
                vector[term[1]]:=vector[term[1]]+
                                 term[2];
            od;
        fi;
        return vector;
    end;
    
    
    if not (IsAffineCrystGroupOnRight(group) and IsStandardSpaceGroup(group))
       then
        Error("group is not a StandardSpaceGroup acting on right");
    fi;
    if not ForAll(fl.elts,i->i in group)
       then
        Error("group does not match face lattice");
    fi;
    
    groupring:=fl.groupring;
    resolution:=Objectify(HapLargeGroupResolution,
                   rec(
                       groupring:=groupring,
                       dimension:=dimension,
                       dimension2:=dimension2,
                       boundary:=boundary,
                       boundary2:=boundary2,
                       homotopy:=fail,
                       elts:=elts,
                       appendToElts:=appendToElts,
                       group:=group,
                       hasse:=fl.hasse,
                       properties:=
                       [["length",Size(fl.hasse)],
                        ["type","resolution"],
                        ["characteristic",0]
                        ]
                       ));
    return resolution;
end);



