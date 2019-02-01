#############################################################################
##
#W translations.gi 			 HAPcryst package		 Marc Roeder
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
#O TranslationsToBox
##
InstallMethod(TranslationsToBox,[IsVector,IsDenseList],
        function(point,box)
    local   nextint,prevint,  difference,  entry,  isinbox,  coord;
    
    nextint:=function(x)
        if IsInt(x) 
           then 
            return x;
        elif x<0
          then
            return Int(x);
        else 
            return Int(x)+1;
        fi;
    end;
    prevint:=function(x)
        if IsInt(x) 
           then 
            return x;
        elif x<0
          then
            return Int(x)-1;
        else 
            return Int(x);
        fi;
    end;
    
    if not ForAll(box, IsVector) and ForAll(box,i->Size(i)=2)
       then
        Error("Box must be given as a list of pairs");
    elif not ForAll(box,i->i[2]>i[1])
      then
        Error("Box must not be empty");
    fi;
    difference:=[];
    for entry in [1..Size(point)]
      do
        coord:=point[entry];
        difference[entry]:=[nextint(box[entry][1]-coord)..prevint(box[entry][2]-coord)];
    od;
    return Iterator(Cartesian(difference));
#    return CartesianIterator(difference);
end);


#############################################################################
##
#O ShiftedOrbitPart
##
InstallMethod(ShiftedOrbitPart,
        [IsVector,IsDenseList],
        function(point,orbitpart)
    local   shiftedPoint;
    
    shiftedPoint:=function(x)
        local   returnpoint,  i,  difference;

        returnpoint:=ShallowCopy(x);
        for i in[1..Size(x)]
          do
            returnpoint[i]:=x[i]-Int(x[i]);
            if AbsoluteValue(returnpoint[i])>1/2
               then
                returnpoint[i]:=returnpoint[i]+SignRat(returnpoint[i]);
            elif returnpoint[i]=-1/2 
              then
                returnpoint[i]:=1/2;
            fi;
        od;
        return returnpoint;
    end;
    
    return Set(orbitpart-point,x->shiftedPoint(x))+point;
end);


#############################################################################
##
#O TranslationsToOneCubeAroundCenter
##
## And here are the translations taking the point <point> to the cube around the point
## <center>
##
InstallMethod(TranslationsToOneCubeAroundCenter,[IsVector,IsVector],
        function(point,center)
    local   returnlist, abs, trans,  difference,  entry;
    
    returnlist:=[];
    trans:=List(center-point,Int);
    difference:=center-(trans+point);
    for entry in [1..Size(difference)]
      do
        abs:=AbsoluteValue(difference[entry]);
        if abs=1/2
           then
            difference[entry]:=[0,SignRat(difference[entry])];
        elif abs>1/2
          then
            difference[entry]:=[SignRat(difference[entry])];
        else
            difference[entry]:=[0];
        fi;
    od;
    return trans+Cartesian(difference);
end);
