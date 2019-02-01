#############################################################################
##
#W misc.gi 			 HAPcryst package		 Marc Roeder
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
# there seems to be not method for rationals, even though SignInt 
# did work in all of the cases I tried.
InstallMethod(SignRat, "for rationals",[IsRat],
        function(rat)
    if rat>0
       then
        return 1;
    elif rat<0
      then
        return -1;
    elif rat=0
      then
        return 0;
    else
        Error("cannot calculate sign of rational");
    fi;
    #return SignInt(rat*DenominatorRat(rat));
end);
  

##############################

InstallMethod(IsSquareMat,"for matrices",[IsMatrix],
        function(mat)
        return Size(Set(mat,Size))=1;
end);


##############################


InstallMethod(DimensionSquareMat,"for matrices",[IsMatrix],
        function(mat)
    if not IsSquareMat(mat)
       then
        Error("Matrix is not square");
    else
        return DimensionsMat(mat)[1];
    fi;
end);


##############################
#
# Return the linear part of an affine matrix. This is sometimes called
# "rotational part" for crystallographic groups.
#

InstallMethod(LinearPartOfAffineMatOnRight,"for affine matrices on right",
        [IsMatrix],
        function(mat)
    local dim;
    if not IsAffineMatrixOnRight(mat)
       then
        Error("matrix must be an affine matrix acting from the right");
    fi;
    dim:=DimensionSquareMat(mat);
    return mat{[1..dim-1]}{[1..dim-1]};
end);


##############################
#
# Calculate what a basis change of $n$ dimensional space does to an affine
# transformation represented by an affine $(n+1)\times(n+1)$ matrix.
#

InstallMethod(BasisChangeAffineMatOnRight,"for affine matrices on right",
        [IsMatrix,IsMatrix],
        function(transform,mat)
    local   dim,  linpart,  transpart,  transformed;
    dim:=DimensionSquareMat(mat);
    if not dim>1 and IsAffineMatrixOnRight(mat)
       then
        Error("This matrix is not affine acting on right");
    fi;
    linpart:=LinearPartOfAffineMatOnRight(mat);
    transpart:=mat[dim]{[1..dim-1]};
    transformed:=IdentityMat(dim);
    transformed{[1..dim-1]}{[1..dim-1]}:=linpart^transform;
    transformed[dim]{[1..dim-1]}:=transpart*transform;
    return transformed;
end);


##############################
#
# Return an affine matrix on right which represents the translation 
# by <vector>
#

InstallMethod(TranslationOnRightFromVector,
        [IsVector],
        function(vector)
    local dim, translation;
    dim:=Size(vector)+1;
    translation:=IdentityMat(dim);
    translation[dim]{[1..dim-1]}:=ShallowCopy(vector);
    return translation;
end);


##############################
#
#
InstallMethod(VectorModOne,
        [IsVector],
        function(vector)
    return List(vector,FractionModOne);
end);
