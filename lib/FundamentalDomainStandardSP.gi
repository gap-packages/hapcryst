#############################################################################
##
#W FundamentalDomainStandardSP.gi 			 HAPcryst package		 Marc Roeder
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
########################################################################
########################################################################
####                                                                ####
####   ALL THIS DOES ONLY WORK FOR THE STANDARD SCALAR  PRODUCT!    ####
####                                                                ####
########################################################################
########################################################################

InstallMethod(FundamentalDomainFromGeneralPointAndOrbitPartGeometric,
        [IsVector,IsMatrix],
        function(center,orbitpart)
    local   smallestPointOfOneCubeAroundCenter,  NextLargerInteger,  
            inequalitiesFromVertices,  needsConsideration,  
            reducePolytope,  initialPolytope,  
            radiussquareMaxentryMaxsum,  dim,  centersquare,  
            partialFD,  radmax,  orbitpartAroundCenter,  polyChanged,  
            sums,  currentsum,  nrNon0,  signs,  signvectors,  
            non0entries,  offsetvector,  non0part,  issmall,  offset,  
            non0indices,  index;

# for a point <center> find the edge of the cube <center>+{-1/2,1/2}^n
# with minimal euclidian norm.
#
smallestPointOfOneCubeAroundCenter:=function(center)
    local   edge,  i,  entry,  sign,  minusentry,  plusentry;

#    middle:=List(center,i->0);
    edge:=List(center);
    for i in [1..Size(center)]
      do
        entry:=edge[i];
        sign:=SignRat(entry);
        if sign=0 then sign:=1; fi;
        minusentry:=-sign/2+entry;
        plusentry:=sign/2+entry;
        if AbsoluteValue(minusentry)<AbsoluteValue(plusentry)
           then
            edge[i]:=minusentry;
        elif AbsoluteValue(minusentry)=AbsoluteValue(plusentry)
          then
            edge[i]:=(minusentry+plusentry)/2;            
#            middle[i]:=(minusentry+plusentry)/2;
#            edge[i]:=plusentry;
        else
            edge[i]:=plusentry;
#            middle[i]:=plusentry;
        fi;
    od;
    return edge;
#    return rec(edge:=edge,middle:=middle);
end;


NextLargerInteger:=function(rat)
    if IsInt(rat) 
       then 
        return rat;
    else
        return Int(rat+1);
    fi;
end;


#given a point <center> and an offset vector <offset> as well as the part of 
# the orbit around <center>, the interesting inequalities induced by 
# <orbitpart>+offset are calculated, assuming that only points nearer 
# than <radius> can induce something interesting.
#
inequalitiesFromVertices:=function(center,offset,signvectors,orbitpart,vertices,radiussquare)
    local   ineqs,  inequalities,  sign,  off;
    
    ineqs:=function(center,points,vertices,rsquare)
        local   returnlist,  point,  ineq;
        returnlist:=[];
        for point in points
          do
            if (point-center)^2<=rsquare 
               then
                ineq:=BisectorInequalityFromPointPair(center,point);
                if ineq<>fail and ForAny(vertices,thiscorner->WhichSideOfHyperplane(thiscorner,ineq)=-1)
#                  if ForAny(vertices,thiscorner->WhichSideOfHyperplane(thiscorner,ineq)=-1)
                   then
                    Add(returnlist,ineq);
                fi;
            fi;
        od;
        return returnlist;
    end;
        
    inequalities:=[];
    for sign in signvectors
      do
        off:=List([1..Size(sign)],i->sign[i]*offset[i])+orbitpart;
        Append(inequalities,ineqs(center,off,vertices,radiussquare));
    od;
    return Set(inequalities);
end;



needsConsideration:=function(offset,radiussquare)
    
#    edgeAndMiddle:=smallestPointOfOneCubeAroundCenter(offset);
 #   if edgeAndMiddle.edge^2<radiussquare or 
    #      edgeAndMiddle.middle^2<=radiussquare
    if smallestPointOfOneCubeAroundCenter(offset)^2<=radiussquare
       then
        return true; 
    else
        return false;
    fi;
end;





reducePolytope:=function(poly,center,offset,signvectors,radiussquare,orbitpart)
    local   vertices,  inequalities;
    
    vertices:=Polymake(poly,"VERTICES");
    inequalities:=inequalitiesFromVertices(center,offset,signvectors,orbitpart,vertices,radiussquare);
    if inequalities <> []
       then
        UniteSet(inequalities,Polymake(poly,"FACETS"));
        ClearPolymakeObject(poly,["polytope","2.3","RationalPolytope"]);
        AppendInequalitiesToPolymakeObject(poly,inequalities);
        Polymake(poly,"VERTICES FACETS");
        if InfoLevel(InfoHAPcryst)>1
           then
            Print("|",Size(Polymake(poly,"VERTICES")),":",Size(Polymake(poly,"FACETS")),">\c");
        fi;
        return true;
    else 
        return false;
    fi;
end;


initialPolytope:=function(center)
    local   dim,  poly,  signvectors,  cubevertices;
    
    dim:=Size(center);
    poly:=CreatePolymakeObject("partialFD",
                  POLYMAKE_DATA_DIR,
                  ["polytope","2.3","RationalPolytope"]
                  );
    signvectors:=Tuples([-1,1],dim);
    cubevertices:=(1/2*signvectors)+center;
    
    AppendVertexlistToPolymakeObject(poly,cubevertices);
    AppendToPolymakeObject(poly, 
            ConvertMatrixToPolymakeString("FACETS",
                    List(Union(IdentityMat(dim),-IdentityMat(dim)),
                     i->BisectorInequalityFromPointPair(center,center+i))));
    Polymake(poly,"VERTICES FACETS");
    return poly;
end;
      

# this calculates the radius of the ball to be covered and the maximal
# entry (and the maximal entry sum) in the offset vectors needed to cover 
# the ball. The maximum distance for offset vectors is 3*radius.
radiussquareMaxentryMaxsum:=function(poly,center,dim)
    local    x,  vertices,  radiussquare,  outerradiussquare,  
            maxentry,  maxsum,  offsetradiussquare;

    x:=Indeterminate(Rationals);
    vertices:=Polymake(poly,"VERTICES");
        # this is the radius of the smallest circle around the polygon:
    radiussquare:=Maximum(List(vertices-center,v->v^2));
    
    #now, we look at the offset vectors.
    #radius of the ball we want to cover (twice the radius of the polygon):
    outerradiussquare:=4*radiussquare;
    #maximal entry of an offset vector (\infty - norm):
    # 1/2+2*radius(poly)  (1/2=half the side length of the offset cube):
    maxentry:=NextLargerInteger(1/2+ContinuedFractionApproximationOfRoot(
                      DenominatorRat(outerradiussquare)*x^2
                      -NumeratorRat(outerradiussquare),
                      10)
                      );
    #maximum sum of entries of offset vectors (1-norm):
    #=dim*((2*radius(poly))^2/dim+1/2)
    maxsum:=NextLargerInteger(dim*(outerradiussquare/dim+1/2));
    
    return rec(radiussquare:=outerradiussquare,maxsum:=maxsum,maxentry:=maxentry);
end;

######################################################################
######################################################################
## Los gehts!
######################################################################
######################################################################

      
dim:=Size(center);

# First, generate the initial (translation) cube.
partialFD:=initialPolytope(center);
radmax:=radiussquareMaxentryMaxsum(partialFD,center,dim);
orbitpartAroundCenter:=Set(ShiftedOrbitPart(center,orbitpart));

polyChanged:=reducePolytope(partialFD,
                     center,
                     List([1..dim],i->0),
                     [List([1..dim],i->1)],
                     radmax.radiussquare,
                     orbitpartAroundCenter);

radmax:=radiussquareMaxentryMaxsum(partialFD,center,dim);
sums:=Iterator([1..radmax.maxsum]);
currentsum:=1;
if InfoLevel(InfoHAPcryst)>1
   then
    Print(radmax,"\n");
fi;      

while currentsum<radmax.maxsum
  do
    currentsum:=NextIterator(sums);
    if InfoLevel(InfoHAPcryst)>1
       then
        Print("\n",currentsum,"(",Int(radmax.radiussquare),"-",radmax.maxsum,"-",radmax.maxentry,")\n");
    fi;
    for nrNon0 in [1..Minimum(currentsum,dim)]
      do
        signs:=Tuples([1,-1],nrNon0);
        signvectors:=NullMat(Size(signs),dim);
        non0entries:=Iterator(RestrictedPartitions(currentsum,[1..radmax.maxentry],nrNon0));
        offsetvector:=List(center,i->0);
        for non0part in non0entries
          do
            offsetvector{[1..nrNon0]}:=non0part;
            issmall:=(non0part^2<=radmax.radiussquare);
            for offset in PermutationsList(offsetvector)
              do
                if issmall or needsConsideration(offset,radmax.radiussquare)
                   then
                    non0indices:=Positions(List(offset,i->i<>0),true);
                    Apply(signvectors,i->List(i,j->1));
                    for index in [1..Size(signs)]
                      do
                        signvectors[index]{non0indices}:=signs[index];
                    od;
                    polyChanged:=reducePolytope(partialFD,
                                         center,
                                         offset,
                                         signvectors,
                                         radmax.radiussquare,
                                         orbitpartAroundCenter);
                    if polyChanged 
                       then
                        radmax:=radiussquareMaxentryMaxsum(partialFD,center,dim);
                    fi;
                    if radmax.maxsum<currentsum
                       then
                        return partialFD;   ## We found it!
                    fi;
                fi;
            od;
        od;
    od;
od;
return partialFD;
end);