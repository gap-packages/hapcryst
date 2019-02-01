#############################################################################
##
#W GroupRing.gi 			 HAPcryst package		 Marc Roeder
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
#O CoefficientsAndMagmaElementsAsLists
##
##  just a function that behaves as expected...
##
InstallMethod(CoefficientsAndMagmaElementsAsLists,
        [IsElementOfFreeMagmaRing],
        function(elt)
    local   coeffsAndMagmaElts,  length;
    coeffsAndMagmaElts:=CoefficientsAndMagmaElements(elt);
    if coeffsAndMagmaElts=[]
       then
        return [[],[]];
    else
        length:=Size(coeffsAndMagmaElts)/2;
        return [List(2*[1..length],i->coeffsAndMagmaElts[i]),
                List(2*[1..length]-1,i->coeffsAndMagmaElts[i])
                ];
    fi;
end);


InstallMethod(Indicator,"for magma ring with one",
        [IsElementOfFreeMagmaRing],
        function(elm)
    local   zero,  coeffs,  one;
    zero:=ZeroCoefficient(elm);
    if not IsMultiplicativeElementWithOne(zero)
       then
        Error("Ring of magma ring must have a one");
   else
        coeffs:=CoefficientsAndMagmaElementsAsLists(elm);
        if coeffs[1]=[]
           then
            return elm;
        else
            one:=zero^0;
            coeffs[1]:=List(coeffs[1],i->one);
            return ElementOfMagmaRing(FamilyObj(elm),zero,coeffs[1],coeffs[2]);
        fi;
    fi;
end);


      
