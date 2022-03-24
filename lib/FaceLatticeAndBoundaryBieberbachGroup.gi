#############################################################################
##
#W FaceLatticeAndBoundaryBieberbachGroup.gi 			 HAPcryst package		 Marc Roeder
##
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
InstallMethod(FaceLatticeAndBoundaryBieberbachGroup,
        [IsPolymakeObject,IsGroup],
        function(poly,group)  
    local   removeSomeFaces,  orbitDecompositionAsIndices,  
            changeHasseEntries,  reformatHD,  reformatHD_GroupRing,  
            calculateBoundary,  dim,  starttime,  vertices,  hasse,  
            codim,  initialfacenumber,  timetmp,  faceOrbits,  tmp,  
            k,  j,  groupring,  elts;
    
    removeSomeFaces:=function(upfaces,faces)
        local   upfaceentries,  faceindex,  face;
        upfaceentries:=AsSet(Flat(upfaces));
        for faceindex in [1..Size(faces)]
          do
            face:=faces[faceindex];
            if not (IsSubset(upfaceentries,face) and ForAny(upfaces,f->IsSubset(f,face)))
               then
                Unbind(faces[faceindex]);
            fi;
        od;
    end;
    
    
    
    orbitDecompositionAsIndices:=function(facelist,vertexlist,group)
        local   sortedvertices,  sortperm,  vertexpositionlookup,  
                todolist,  setfacelist,  returnlist,  thissize,  list,  
                orbit,  thisorbit,  fpos,  fpositions;

        if not ForAll(facelist,IsSet)
           then
            Error("face list must be a list of sets");
        fi;
        
        sortedvertices:=ShallowCopy(vertexlist);
        sortperm:=Sortex(sortedvertices);
        vertexpositionlookup:=Permuted([1..Size(sortedvertices)],sortperm);
        
        # convert all faces to vectors:
        todolist:=Set(facelist,i->Set(vertexlist{i}));
        if IsSet(facelist)
           then
            setfacelist:=facelist;
        else
            setfacelist:=AsSet(facelist);
        fi;
        returnlist:=[];

        while todolist<>[]
          do
            thissize:=Size(todolist[1]);
            list:=Filtered(todolist,o->Size(o)=thissize);
            SubtractSet(todolist,list);

            while list<>[]
              do
                orbit:=OrbitPartAndRepresentativesInFacesStandardSpaceGroup(group,list[1],list);
                thisorbit:=[];
                for fpos in [1..Size(orbit)]
                  do
                    fpositions:=Set(orbit[fpos][1],i->vertexpositionlookup[PositionSet(sortedvertices,i)]);
                    if fpositions in setfacelist
                       then
                        Add(thisorbit,[Position(facelist,fpositions),orbit[fpos][2]]);
                    fi;
                od;
                Add(returnlist,thisorbit);
                SubtractSet(list,List(orbit,i->i[1]));
            od;
        od;
        return returnlist;
    end;
    

    
        changeHasseEntries:=function(orbitsandreps,codim,vertices,hasse,group)
        local   genIndices,  faces,  nrupfaces,  upfaces,  
                newhasseentry,  idMat,  orbit,  gen,  genIndex,  
                upindices,  upface,  genvertices,  o,  oface,  entry;

        genIndices:=[];
        faces:=hasse[codim+1];
        nrupfaces:=Size(hasse[codim]);
        upfaces:=hasse[codim]{[1..nrupfaces]}[1];
        newhasseentry:=[];
        idMat:=IdentityMat(Size(hasse));
        for orbit in orbitsandreps 
          do
            gen:=faces[orbit[1][1]];
            Add(newhasseentry,[gen,[]]);
            genIndex:=Size(newhasseentry);
            upindices:=Filtered([1..nrupfaces],
                       i->IsSubset(upfaces[i],gen));
            #update boundary for faces containing new generator:
            for upface in upindices
              do
                AddSet(hasse[codim][upface][2],[genIndex,idMat]);
            od;
            
            #replace all faces in the generator-orbit with representatives:
            if Size(orbit)>1
               then
                genvertices:=Set(vertices{gen});
                for o in orbit{[2..Size(orbit)]}
                  do
                    oface:=faces[o[1]];
                    upindices:=Filtered([1..nrupfaces],
                                       i->IsSubset(upfaces[i],oface));
                    
                    entry:=[genIndex,o[2]];
                    
                    for upface in upindices
                      do
                        AddSet(hasse[codim][upface][2],entry); 
                    od;
                od;
            fi;
        od;
        return newhasseentry;
    end;

    
    
    
    #this replaces the matrices in the partial Hasse diagram with integers and
    # returns a list of matrices. This is done to comply with the structure
    # of a resolution in HAP.
    
    reformatHD:=function(hasse)
        local   elts,  faces,  face,  line;
        
        elts:=[];
        for faces in hasse 
          do
            for face in faces
              do
                for line in face[2]
                  do
                    Add(elts,line[2]);
                od;
            od;
        od;
#        if elts<>[]
#           then
#            elts:=Set(elts);
#            AddSet(elts,IdentityMat(Size(elts[1])));
#            for faces in hasse 
#              do
#                for face in faces
#                  do
#                    for line in face[2]
#                      do
#                        if not IsInt(line[2]) 
#                           then
#                            line[2]:=PositionSet(elts,line[2]);
#                        fi;
#                    od;
#                od;
#            od;
#        fi;

        return elts;
    end;
    
    
    ## This does not generate group ring elements. The group ring is
    ## generated in the resolution generator. So here, we only generate
    ## the coefficient-group element pairs.
    reformatHD_GroupRing:=function(groupring,hasse)
        local   zero,  family,  groupelements,  dim,  face,  term,  
                firstpos,  firstgen,  position,  firspos,  one,  
                onepos;
        zero:=Zero(groupring);
        family:=FamilyObj(zero);
        groupelements:=[];
        for dim in [2..Size(hasse)]
          do
            for face in hasse[dim]
              do
                for term in face[2]
                  do
                    if IsMatrix(term[2])
                       then
                        Add(groupelements,term[2]);
                        term[2]:=SignInt(term[1])*
                                 ElementOfMagmaRing(family,0,[1],[term[2]]);
                        term[1]:=AbsInt(term[1]);
                    fi;
                od;
                Sort(face[2]);
                firstpos:=1;
                firstgen:=face[2][firstpos][1];
                for position in [2..Size(face[2])]
                  do
                    if face[2][position][1]=firstgen
                       then
                        face[2][firstpos][2]:=face[2][firstpos][2]
                                              +face[2][position][2];
                        Unbind(face[2][position]);
                    else
                        firstpos:=position;
                        firstgen:=face[2][position][1];
                    fi;
                od;
                face[2]:=Compacted(face[2]);
                #                face[2]:=vector;
            od;
        od;
        groupelements:=Set(groupelements);
        one:=One(UnderlyingMagma(groupring));
        if groupelements[1]<>one
           then
            onepos:=Position(groupelements,one);
            groupelements[onepos]:=groupelements[1];
            groupelements[1]:=one;
        fi;
        return groupelements;
    end;
    
    
    
######################################################################
######################################################################

    
    
    
    ##################################################
    ## THIS IS JUST FOR BIEBERBACH GROUPS!
    ##
    ## here,  hasse has to be a list contining the generators of 
    ## dimension $k$ in the $k+1$st entry.
    ## each of the genertors already knows it's unoriented boundary.
    ##
    ## Signs are now assigned to the boundary to define a proper 
    ##  boundary homomorphism.
    ##
    
    calculateBoundary:=function(k,j,hasse)
        local   dirLess,  boundaryFromPair,  face,  facebound,  
                linesdone,  linestodo,  linesinpoint,  pointset,  
                idMat,  line,  linemat,  points,  point,  pos,  
                firstlinepos,  firstline,  linesforthisrun,  
                nextlines,  pointsdone,  linebound,  lineboundDirless,  
                dirlessline,  pointsign,  otherline,  otherlinepos,  
                otherlinebound,  orientedOtherLine;
        
        dirLess:=function(face)
            return [AbsInt(face[1]),face[2]];
        end;
        

        boundaryFromPair:=function(dim,pair,hasse)
            local   gen,  bound;
            gen:=hasse[dim+1][AbsInt(pair[1])];
            bound:=gen[2];
            return List(bound,b->[SignInt(pair[1])*b[1],b[2]*pair[2]]);
        end;

        
        face:=hasse[k+1][j];
        
        ################################
        ## face is of the form
        ## [ <verts>, <bound>]
        ## where 
        ##  <verts> is a list of integers enumerating the vertices of the 
        ## fundamental domain
        ## 
        ##  <bound> is a list of pairs [<downfaceindex>,<mapping>]
        ##   with an integer <downfaceindex> denoting the position of a face 
        ##   in the list hasse[k]. <mapping> is an affine matrix taking the ##
        ##   hasse[k][downfaceindex] to the desired face.                   ##
        ##                                                                  ##
        ##                                         ###########################
        
        
        if k=1    # First, define the boundary of 1-faces
           then
            facebound:=face[2];
            if facebound[1]>facebound[2]
               then
                linesdone:=[facebound[1],[-facebound[2][1],facebound[2][2]]];
            else
                linesdone:=[[-facebound[1][1],facebound[1][2]],facebound[2]];
            fi;
        else
            #
            #now the other faces. Note that in an n-face every 
            # n-2 face is contained in exactly 2 n-1 faces.
            ##############################

            linestodo:=Set(face[2],i->dirLess(i));
            #    # the edges which are generators for this module:
            #    GenLinesTodo:=Filtered(linestodo,i->i[2]=idMat);
            #    # edges which are images under generators for this module:
            #    ImLinesTodo:=Filtered(linestodo,i->i[2]<>idMat);  


            # As the group is Bieberbach, each point has a unique name.
            # generate a list to look up the incident lines for each point:
            linesinpoint:=[];
            pointset:=[];
            idMat:=IdentityMat(Size(hasse));
            for line in linestodo  
              # form: line=[<pos>,<mat>]
              # <pos>: generator position
              # <mat>: matrix taking generator to actual line.
              do
                linemat:=line[2];
                points:=List(hasse[k][line[1]][2],p->[AbsInt(p[1]),p[2]*linemat]);
                for point in points
                  #form of point as form of line but one dimension lower
                  do
                    if not point in pointset
                       then
                        Add(linesinpoint,[point,[line]]);
                    else
                        pos:=PositionSet(pointset,point);
                        AddSet(linesinpoint[pos][2],line);
                    fi;
                od;
                UniteSet(pointset,points);
                Sort(linesinpoint);
            od;
            
            firstlinepos:=PositionProperty(linestodo,i->i[2]=idMat);
            if firstlinepos=fail
               then
                firstline:=Remove(linestodo);
            else
                firstline:=linestodo[firstlinepos];
                Remove(linestodo,firstlinepos);
            fi;

            linesforthisrun:=[firstline];
            nextlines:=[];
            pointsdone:=[];
            linesdone:=[];

            repeat
                for line in linesforthisrun
                  do
                    linesdone:=Set(linesdone);
                    if not ([line[1],line[2]] in linesdone 
                            or [-line[1],line[2]] in linesdone)
                       then
                        Add(linesdone,line);
                    fi;
                    linebound:=boundaryFromPair(k-1,line,hasse);
                    lineboundDirless:=List(linebound,dirLess);
                    SortParallel(lineboundDirless,linebound);
                    
                    dirlessline:=dirLess(line);
                    points:=Difference(lineboundDirless,pointsdone);
                    
                    for point in points
                      do
                        Add(pointsdone,point);
                        pointsign:=SignInt(linebound[PositionSet(lineboundDirless,point)][1]);
                                           
                        otherline:=linesinpoint[PositionSet(pointset,point)];
                        otherline:=First(otherline[2],l->l<>dirlessline); 
                                                
                        if otherline in linestodo
                           then
                            RemoveSet(linestodo,otherline);
                            otherlinebound:=boundaryFromPair(k-1,otherline,hasse);
                            if pointsign=SignInt(First(otherlinebound,i->dirLess(i)=point)[1])
                            then 
                                orientedOtherLine:=[-otherline[1],otherline[2]];
                            else
                                orientedOtherLine:=otherline;
                            fi;
                            Add(linesdone,orientedOtherLine);
                            Add(nextlines,orientedOtherLine);
                        fi;
                    od;
                od;
                linesforthisrun:=ShallowCopy(nextlines);
                nextlines:=[];
            until linesforthisrun=[];
        fi;
        ## return new boundary entry:
        return Set(linesdone);
    end;

######################################################################
######################################################################

    if not IsStandardSpaceGroup(group) and IsAffineCrystGroupOnRight(group)
       then
        Error("<group> must be a StandardSpaceGroup acting on right");
    fi;
    dim:=DimensionOfMatrixGroup(group)-1;
    starttime:=Runtime();
    
    Polymake(poly,"VERTICES");
    vertices:=Polymake(poly,"VERTICES");
    MakeImmutable(vertices);
    if not dim=Size(vertices[1]-1)
       then
        Error("group and polyhedron do not match");
    fi;
    ##
    # Add initial (top) node:
    # Note that the face lattice is generated top- down. So the 
    # order has to be reversed to be ascending in dimension.
    ##
    hasse:=Concatenation([[[[1..Size(vertices)],[]]]],
                   #StructuralCopy(Polymake(poly,"FACE_LATTICE"){[1..dim]}));
                   StructuralCopy(PolymakeFaceLattice(poly){[1..dim]}));
    #moduleGenerators:=List([1..dim+1],i->[]);

    #moduleGenerators is a list of list. The i^{th} entry contains the 
    # positions of the module generators of dimension i in the Hasse diagram.
    #    moduleGenerators[1]:=[1];# so this means [hasse[1][1]];

    #Now the next nodes:
    for codim in [1..dim]
      do
        #At this stage, hasse[codim+1] is a list of faces.
        initialfacenumber:=Size(hasse[codim+1]);##########
        timetmp:=Runtime();########
        removeSomeFaces(List(hasse[codim],i->i[1]),hasse[codim+1]);
        hasse[codim+1]:=Set(hasse[codim+1]);
        faceOrbits:=orbitDecompositionAsIndices(hasse[codim+1],vertices,group);
        hasse[codim+1]:=changeHasseEntries(faceOrbits,codim,vertices,hasse,group);
        Info(InfoHAPcryst,3,codim,"(",Size(hasse[codim+1]),"/",initialfacenumber,"):",StringTime(Runtime()-timetmp));
    od;
    
    for codim in [1..Int((dim+1)/2)]
      do
        tmp:=hasse[codim];
        hasse[codim]:=hasse[dim+2-codim];
        hasse[dim+2-codim]:=tmp;
    od;
    Info(InfoHAPcryst,3,"Face lattice done (",StringTime(Runtime()-starttime),"). Calculating boundary ");
    for k in [1..dim]
      do
        for j in [1..Size(hasse[k+1])]
          do
            hasse[k+1][j][2]:=calculateBoundary(k,j,hasse);
        od;
    od;
    if fail in Flat(hasse)
       then
        Error("boundary generation failed");
    fi;

    Info(InfoHAPcryst,3,"done (",StringTime(Runtime()-timetmp),") Reformating...\c");
    #    elts:=reformatHD(hasse);
    groupring:=GroupRing(Integers,group);
    elts:=reformatHD_GroupRing(groupring,hasse);
#    elts:=[IdentityMat(dim+1)];
    return rec(hasse:=hasse,elts:=elts,groupring:=groupring);
end);
