#############################################################################
##
#W contHomBieberbach.gi 			 HAPcryst package		 Marc Roeder
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
InequalitiesTimesMatrix:=function(ineqs,mat)
    local   dim,  inverse,  translationPart,  returnlist,  ineq,  
            returnineq,  newv;
    if not IsAffineMatrixOnRight(mat)
       then
        Error("only implemented for matrices on right");
    fi;
    dim:=Size(mat);
    inverse:=Inverse(LinearPartOfAffineMatOnRight(mat));
    translationPart:=mat[dim]{[1..dim-1]};
    if inverse=fail
       then
        Error("matrix not invertible");
    fi;
    returnlist:=[];
    for ineq in ineqs 
      do
        returnineq:=List(ineq);
        newv:=inverse*ineq{[2..dim]};
        returnineq[1]:=ineq[1]-translationPart*newv;
        returnineq{[2..dim]}:=newv;
        Add(returnlist,returnineq);    
    od;
    return returnlist;
end;

#############################################################################

TranslatedInequalities:=function(ineqs,trans)
    local   dim,  returnineqs,  ineq;
    if not IsVector(trans)
       then
        Error("translation must be given as a vector");
    fi;
    dim:=Size(trans);
    if not Set(ineqs,Size)=[dim+1]
       then
        Error("inequalities of wrong size");
    fi;
    returnineqs:=List(ineqs);
    for ineq in [1..Size(ineqs)]
      do
        returnineqs[ineq][1]:=returnineqs[ineq][1]-trans*ineqs[ineq]{[2..Size(trans)+1]};
    od;
    return returnineqs;
end;

#############################################################################

VectorTimesAffineMatNC:=function(v,mat)
    local   returnvector;
    returnvector:=Concatenation(v,[1])*mat;
    return returnvector{[1..Size(v)]};
end;

#############################################################################

VectorsTimesAffineMat:=function(vecs,mat)
    local   dim;
    if not IsAffineMatrixOnRight(mat)
       then
        Error("<mat> is not an affine matrix on right");
    fi;
    dim:=Size(mat);
    if not Set(vecs,Size)=[dim-1]
       then
        Error("vectors of wrong form");
    fi;
    return List(vecs,v->VectorTimesAffineMatNC(v,mat));
end;

#############################################################################

RelativePositionPointAndInequalities:=function(point,ineqs)
    local   facetpositions,  facet,  side;
    facetpositions:=[];
    for facet in ineqs
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
end;

#############################################################################

coveringOfUnitBox:=function(fudom,boxcenter,group)
    local   dim,  vertices,  inequalities,  pgReps,  cover,  
            corner_covered,  smallestCorner,  boxcorners,  cornerbox,  
            g,  image,  translations,  h,  cornerTranslations,  
            imageinequalities,  trans;
    
    Polymake(fudom,"DIM VERTICES FACETS");
    dim:=Polymake(fudom,"DIM");
    vertices:=Polymake(fudom,"VERTICES");
    inequalities:=Polymake(fudom,"FACETS");
    pgReps:=PointGroupRepresentatives(group);
    cover:=[];
    corner_covered:=false;
    
    ## generate the box to be covered:
    smallestCorner:=boxcenter-List([1..dim],i->1/2);
    boxcorners:=Set(smallestCorner+List(Combinations(IdentityMat(dim)),Sum));
    RemoveSet(boxcorners,0);
    AddSet(boxcorners,smallestCorner);
    cornerbox:=fail;
    
    # find all images of the box that intersect with the original one.
    # This is done by looking at the corners of the box
    for g in pgReps
      do
        image:=Set(vertices,v->VectorTimesAffineMatNC(v,g));
        translations:=Union(List(image,v->TranslationsToOneCubeAroundCenter(v,boxcenter)));
        for h in List(translations,t->g*TranslationOnRightFromVector(t))
          do
            Add(cover,h);
            if (not corner_covered) and RelativePositionPointAndInequalities(smallestCorner,
                       InequalitiesTimesMatrix(inequalities,h))<>"OUTSIDE"
               then
                corner_covered:=true;
                cornerbox:=h;
            fi;
        od;
        if not corner_covered
           then
            cornerTranslations:=Union(List(image,v->TranslationsToOneCubeAroundCenter(v,smallestCorner)));
            imageinequalities:=InequalitiesTimesMatrix(inequalities,g);
            while cornerTranslations<>[] and not corner_covered
              do
                trans:=Remove(cornerTranslations);
                if not corner_covered and RelativePositionPointAndInequalities(smallestCorner,TranslatedInequalities(imageinequalities,trans))<>"OUTSIDE"
                   then
                    corner_covered:=true;
                    cornerbox:=g*TranslationOnRightFromVector(trans);
                    Add(cover,cornerbox);
                fi;
            od;
        fi;
    od;
    return Set(cover);
end;

    
#############################################################################
    ##
    # there should be a way to know if a given disc function 
    # works with a given resolution...
    # how do I do this?
    #
discFunction:=function(fudom,resolution,contractionCell_groupel)
    local   group,  dim,  origin,  boxcenter,  cover,  trans,  
            cwSpaceBox,  data,  disc;
    
    group:=GroupOfResolution(resolution);
    if not IsFundamentalDomainStandardSpaceGroup(fudom,group)
       then
        Error("this is not a fundmental domain for this resolution");
    fi;
    Print(".\c");
    dim:=DimensionOfMatrixGroup(group)-1;
    origin:=List([1..dim],i->0);
    boxcenter:=Concatenation(origin,[1])*contractionCell_groupel;
    boxcenter:=boxcenter{[1..dim]};
    cover:=coveringOfUnitBox(fudom,boxcenter,group)[1];
    trans:=TranslationsToOneCubeAroundCenter(origin,boxcenter);
    trans:=TranslationOnRightFromVector(trans);
    cwSpaceBox:=SubspaceListFromWord_LargeGroupRep(resolution,
                     dim,
                     [One(GroupRingOfResolution(resolution))]
                     );;
    
    data:=rec(cwSpaceBox:=cwSpaceBox,cover:=cover);;
    
    
    disc:=function(resolution,term,letter,data)
        local   zero,  gen,  ginv,  dim,  identity,  
                boxcover_thisterm,  c,  t,  transvector,  
                all_translations,  i,  sign,  returnword;
        
        if not IsFreeZGLetter_LargeGroupRep(resolution,term,letter)
           then
            Error("letter is not a valid ZG letter");
        fi;
        zero:=Zero(GroupRingOfResolution(resolution));
        gen:=PositionProperty(letter,i->i<>zero);
        ginv:=Inverse(CoefficientsAndMagmaElementsAsLists(letter[gen])[2][1]);
        dim:=Size(g)-1;
        identity:=IdentityMat(dim);
        boxcover_thisterm:=Union(List(CoefficientsAndMagmaElementsAsLists(data.cwSpaceBox[term+1][gen])[2],g->List(data.cover,c->g*c)));
        for c in boxcover_thisterm
          do
            t:=ginv*c;
            #multiplying from the left is right here,
            # we calculate the inverse translation.
            if t{[1..dim]}{[1..dim]}=identity
               then
                transvector:=-t[dim+1]{[1..dim]};
                break;
            fi;
        od;
        Print(transvector);
        # transvector is a translation which takes <letter> into 
        # the covered box space.
        # This translation may not be unique. But we don't care.
        #
        if not ForAll(transvector,IsInt)
           then
            Error("translation vector not integer");
        fi;
        all_translations:=[];
        for i in [1..dim]
          do
            sign:=SignInt(transvector[i]);
            while transvector[i]<>0
              do
                Add(all_translations,ShallowCopy(transvector));
                transvector[i]:=transvector[i]-sign;
            od;
        od;
        all_translations:=Union(all_translations,[List([1..dim],i->0)]);
        Apply(all_translations,TranslationOnRightFromVector);
        
        returnword:=List(data.cwSpaceBox[term+1],i->Sum(all_translations,g->i*g));;
        return returnword;        
    end;
    return rec(disc:=disc,disc_data:=data);
end;