#############################################################################
##
#W FundamentalDomainBieberbach.gi 			 HAPcryst package		 Marc Roeder
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
#O FundamentalDomainBieberbachGroupNC(<group>)
##
InstallMethod(FundamentalDomainBieberbachGroupNC,
        [IsGroup],
        function(group)
    local center;
    center:=0*[1..Size(Representative(group))-1];
    return FundamentalDomainBieberbachGroupNC(center,group);
end);

#############################################################################
##
#O FundamentalDomainBieberbachGroup(<group>)
##
InstallMethod(FundamentalDomainBieberbachGroup,
        [IsGroup],
        function(group)
    local center;
    center:=0*[1..Size(Representative(group))-1];
    return FundamentalDomainBieberbachGroup(center,group);
end);


#############################################################################
##
#O FundamentalDomainBieberbachGroupNC(<center>, <group>)
##
InstallMethod(FundamentalDomainBieberbachGroupNC,
        [IsVector,IsGroup],
        function(center,group)
    local gram;

    gram:=GramianOfAverageScalarProductFromFiniteMatrixGroup(PointGroup(group));
    return FundamentalDomainBieberbachGroupNC(center,group,gram);
end);


#############################################################################
##
#O FundamentalDomainBieberbachGroup(<center>, <group>)
##
InstallMethod(FundamentalDomainBieberbachGroup,
        [IsVector,IsGroup],
        function(center,group)
    local gram;

    gram:=GramianOfAverageScalarProductFromFiniteMatrixGroup(PointGroup(group));
    return FundamentalDomainBieberbachGroup(center,group,gram);
end);


#############################################################################
##
#O FundamentalDomainBieberbachGroup(<center>, <group>, <gram>)
##
InstallMethod(FundamentalDomainBieberbachGroup,
        [IsVector,IsGroup,IsMatrix],
        function(center,group,gram)
    local   needBieberbachTest,  phi,  dim,  fd;
    
    needBieberbachTest:=false;
    if not (IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group))
       then
        Error("group must be a StandardSpaceGroup acting on right");
    else 
        phi:=IsomorphismPcpGroup(group);
        if phi=fail
           then
            Info(InfoHAPcryst,1,"Couldn't calculate pcp representation. Testing tortion freeness later");
            needBieberbachTest:=true;
        elif not IsAlmostBieberbachGroup(Image(phi))
          then
            Error("group must be a Bieberbach group");
        fi;
    fi;
    dim:=Size(center);
    if not (dim=Size(gram) and DimensionOfMatrixGroup(group)=dim+1)
       then
        Error("dimensions don't match");
    fi;
    if not IsTrivial(StabilizerOnSetsStandardSpaceGroup(group,[center]))
       then
        Error("group must be a Bieberbach group");
    fi;
    fd:=FundamentalDomainBieberbachGroupNC(center,group,gram);
    if not needBieberbachTest or IsFundamentalDomainBieberbachGroup(fd,group)
       then
        return fd;
    else
        Error("group must be a Bieberbach group");
    fi;
end);
    
    

#############################################################################
##
#O FundamentalDomainBieberbachGroupNC(<center>, <group>, <gram>)
##
InstallMethod(FundamentalDomainBieberbachGroupNC,
        [IsVector,IsGroup,IsMatrix],
        function(center,group,gram)
    local   initialInequalities,  satisfiesAllInequalities,  
            newInequalitiesEuclidean,  newInequalities,  shuffledList,  
            dim,  fdVol,  ineqThreshold,  isEuclidean,  orbitpart,  
            partialFD,  newinequalities,  oldinequalities,  
            donevertices,  allvertices,  vertices,  box,  i,  ilist,  
            inequalities,  v,  new;
    
    ###################
    ##  A lot of helper functions:
    ###################

    
    # This calculates the inequalities for the unit box around
    initialInequalities:=function(center,gram)
        local   dim,  directions,  points,  ineqs;

        dim:=Size(center);
        directions:=Union(IdentityMat(dim),-IdentityMat(dim));
        points:=[];
        points:=center+directions;
        #points:=Set(ShiftedOrbitPart(center,orbitpart));
        #UniteSet(points,center+directions);
        #    UniteSet(points,Union(List(directions,d->d+points)));
        if gram<>IdentityMat(dim)
           then
            ineqs:=Set(points,
                       i->BisectorInequalityFromPointPair(center,i,gram));
        else
            ineqs:=Set(points,
                       i->BisectorInequalityFromPointPair(center,i));
        fi;
        RemoveSet(ineqs,fail);
        return ineqs;
    end;
    
 
   satisfiesAllInequalities:=function(point,ineqs)
        return ForAll(ineqs,i->WhichSideOfHyperplaneNC(point,i) in [0,1]);
    end;



    newInequalitiesEuclidean:=function(vertex,center,ineqs,vertices,box,group)
        local   dim,   affinevertex,  returnlist,  g,  
                affimage,  image,  trans,  t,  gl,  gli,  gt;

        dim:=Size(vertex);
        affinevertex:=Concatenation(vertex,[1]);
        returnlist:=[];
        for g in PointGroupRepresentatives(group)
          do
            gl:=LinearPartOfAffineMatOnRight(g);
            gli:=Inverse(gl);
            gt:=g[dim+1]{[1..dim]};
            affimage:=affinevertex*g;
            image:=affimage{[1..dim]};
            ###
            trans:=TranslationsToBox(image,box);
            for t in trans 
              do
                if not image+t in vertices 
                   then
                    if satisfiesAllInequalities(image+t,ineqs)
                       then
                        Add(returnlist,center*gl+gt+t);
                        Add(returnlist,(center-gt-t)*gli);
                    fi;
                fi;
            od;
        od;
        if returnlist=[]
           then
            return [];
        fi;
        returnlist:=Set(returnlist);
        RemoveSet(returnlist,center);
        returnlist:=Set(returnlist,i->BisectorInequalityFromPointPair(center,i));
        SubtractSet(returnlist,ineqs);
        return Filtered(returnlist,i->ForAny(vertices,v->WhichSideOfHyperplaneNC(v,i)=-1));
    end;


    newInequalities:=function(vertex,center,ineqs,vertices,box,group,gram)
        local   dim,  affinevertex,  returnlist,  g,  gl,  gli,  gt,  
                affimage,  image,  trans,  t;

        dim:=Size(vertex);
        affinevertex:=Concatenation(vertex,[1]);
        returnlist:=[];
        for g in PointGroupRepresentatives(group)
          do
            gl:=LinearPartOfAffineMatOnRight(g);
            gli:=Inverse(gl);
            gt:=g[dim+1]{[1..dim]};
            affimage:=affinevertex*g;
            image:=affimage{[1..dim]};
            ###
            trans:=TranslationsToBox(image,box);
            for t in trans 
              do
                if not image+t in vertices 
                   then
                    if satisfiesAllInequalities(image+t,ineqs)
                       then
                        Add(returnlist,center*gl+gt+t);
                        Add(returnlist,(center-gt-t)*gli);
                    fi;
                fi;
            od;
        od;
        if returnlist=[]
           then
            return [];
        fi;
        returnlist:=Set(returnlist);
        RemoveSet(returnlist,center);
        returnlist:=Set(returnlist,i->BisectorInequalityFromPointPair(center,i,gram));
        SubtractSet(returnlist,ineqs);
        return Filtered(returnlist,i->ForAny(vertices,v->WhichSideOfHyperplaneNC(v,i)=-1));
    end;
    
    
    shuffledList:=function(list)
        local   positionlist,  indexlist,  i,  nextpos;
        if Size(list)=1
           then return list;
       fi;
       positionlist:=EmptyPlist(Size(list));
       indexlist:=[1..Size(list)];
       for i in [Size(list),Size(list)-1..1]
         do
           nextpos:=Random(1,i);
           Add(positionlist,indexlist[nextpos]);
           Remove(indexlist,nextpos);
       od;
       return list{positionlist};
    end;
              
    ###################
    ##  helper functions done. Let's go:
    ###################
    
    dim:=Size(center);
    ## The volume of a fundamental domain is seemingly
    ## well-known:
    #fdVol:=1/Order(PointGroup(group));
    
    ## This is only used in the first step.
    ## Polymake calculates a triangulation using the beneath-beyond
    ## algorithm for this.
    ## This seams to be inefficient in high dimensions, especially
    ## with complicated polyhedrae.
    ##
    
    ineqThreshold:=ValueOption("ineqThreshold");
    if ineqThreshold=fail
       then
        ineqThreshold:=200;
    fi;
    isEuclidean:=(gram=IdentityMat(dim));
    orbitpart:=OrbitStabilizerInUnitCubeOnRight(group,center).orbit;;
    
    newinequalities:=initialInequalities(center,gram);;
    partialFD:=CreatePolymakeObject("partialFD",
                       POLYMAKE_DATA_DIR,
                       ["polytope","2.3","RationalPolytope"]
                       );
    AppendToPolymakeObject(partialFD,
            ConvertMatrixToPolymakeString("FACETS",newinequalities)
            );
#    AppendInequalitiesToPolymakeObject(partialFD,newinequalities);
## slightly experimental: remove if this causes trouble:
    Polymake(partialFD,"VERTICES FACETS");
    
    
    
    newinequalities:=[];
    oldinequalities:=[];
    donevertices:=[];
    allvertices:=[];
    
    repeat
        allvertices:=AsSet(Polymake(partialFD,"VERTICES"));
        donevertices:=Set(donevertices);
        vertices:=Difference(allvertices,donevertices);
        
        ##
        box:=[1..dim];
        for i in [1..dim]
          do
            ilist:=allvertices{[1..Size(allvertices)]}[i];
            box[i]:=[Minimum(ilist),Maximum(ilist)];
        od;
            
#        Sort(donevertices);
#        vertices:=(Filtered(Polymake(partialFD,"VERTICES"),v->not v in donevertices));
#        vertices:=Difference(allvertices,donevertices);
        if vertices=[] 
           then 
            Info(InfoHAPcryst,2,"out of vertices");
            return partialFD;
        fi;
        inequalities:=Set(Polymake(partialFD,"FACETS"));
        Info(InfoHAPcryst,3,"v: ",Size(allvertices),"/",Size(vertices)," f:", Size(inequalities),"  \c");
        newinequalities:=[];
        repeat
            v:=Remove(vertices,Random(1,Size(vertices)));
#            v:=Remove(vertices);
            Add(donevertices,v);
            if satisfiesAllInequalities(v,newinequalities)
               then
                if isEuclidean 
                   then
                    new:= newInequalitiesEuclidean(v,center,inequalities,
                                  allvertices,box,group);
                else
                    new:= newInequalities(v,center,inequalities,
                                  allvertices,box,group,gram);
                fi;
                UniteSet(inequalities,new);
                Append(newinequalities,new);
            fi;
        until vertices=[] or Size(newinequalities)>ineqThreshold;

        Info(InfoHAPcryst,3,"new: ",Size(newinequalities));
        if newinequalities<>[]
           then
            ClearPolymakeObject(partialFD,["polytope","2.3","RationalPolytope"]);
#            AppendInequalitiesToPolymakeObject(partialFD,shuffledList(inequalities));;
            AppendInequalitiesToPolymakeObject(partialFD,inequalities);;
            Polymake(partialFD,"VERTICES FACETS");
        fi;
    until newinequalities=[];
    Info(InfoHAPcryst,2,"out of inequalities");
    return partialFD;
end);

