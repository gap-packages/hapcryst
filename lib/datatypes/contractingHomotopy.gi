#############################################################################
##
#W contractingHomotopy.gi 			 HAPcryst package		 Marc Roeder
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
PartialContractingHomotopyFamily:=NewFamily("PartialContractingHomotopyFamily",
                                          IsPartialContractingHomotopy
                                          );
PartialContractingHomotopy:=NewType(PartialContractingHomotopyFamily,
                                    IsPartialContractingHomotopyRep
                                    );

#############################################################################
##
## Printing homotopies:
##
InstallMethod(ViewObj,
        "for PartialContractingHomotopy",
        [IsPartialContractingHomotopy],
        function(homotopy)
    Print("<partial contracting homotopy>");
end);


InstallMethod(PrintObj,
        "for PartialContractingHomotopy",
        [IsPartialContractingHomotopy],
        function(homotopy)
    Print("<partial contracting homotopy for");
    Print(ResolutionOfContractingHomotopy(homotopy));
    Print(">");
end);



#############################################################################
##
## Accessing private data:
##

#############################################################################
##
#O ResolutionOfContractingHomotopy(<homotopy>)
## 
InstallMethod(ResolutionOfContractingHomotopy,
        [IsPartialContractingHomotopy],
        function(homotopy)
    return homotopy!.resolution;
end);
        
#############################################################################
##
#O PartialContractingHomotopyLookup(<homotopy>,<term>,<generator>,<groupel>)
##
##  lookup the value of the <generator>th generator times <groupel> and
##  return it. If it is unknown, return fail.
##
InstallMethod(PartialContractingHomotopyLookup,
        [IsPartialContractingHomotopy,IsInt,IsPosInt,IsObject],
        function(homotopy,term,generator,groupel)
    local   resolution;
    
    resolution:=ResolutionOfContractingHomotopy(homotopy);
    if term>=EvaluateProperty(resolution,"length")
       then
        Error("resolution too short");
    elif not generator<=Dimension(resolution)(term)
       then
        Error("no such generator");
    fi;
    return PartialContractingHomotopyLookupNC(homotopy,term,generator,groupel);
end);

#############################################################################
##
#O PartialContractingHomotopyLookupNC(<homotopy>,<term>,<generator>,<groupel>)
##
##  lookup the value of the <generator>th generator times <groupel> and
##  return it. If it is unknown, return fail.
##  Input not checked.
##
InstallMethod(PartialContractingHomotopyLookupNC,
        [IsPartialContractingHomotopy,IsInt,IsPosInt,IsObject],
        function(homotopy,term,generator,groupel)
    local   knownMap,  space;
    
    knownMap:=homotopy!.knownPartOfHomotopy;
    if not (IsBound(knownMap[term+2]) and IsBound(knownMap[term+1]))
       then 
        return fail;
    fi;
    space:=knownMap[term+1].space;
    knownMap:=knownMap[term+2].map;
    
    if not IsBound(knownMap[generator]) or knownMap[generator]=[]
      then
        return fail;
    else
        return First(knownMap[generator],x->x[1]=groupel);
    fi;
end);



#############################################################################
##
#E End
##