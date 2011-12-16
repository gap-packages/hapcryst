InstallMethod(HasseDiagramAsList,[IsRecord],
        function(hasse)
    local   faceblocks,  facenumber,  nodes,  permlist,  pi,  node,  
            maxnode,  i,  upface,  blockindex,  downshift,  upshift,  
            face;
    
    #
    #make a mutable copies:
    ##
    faceblocks:=List(hasse.faceindices,i->List(i));
    nodes:=List(hasse.hasse,face->[List(face[1]),List(face[2])]); 
    
    facenumber:=Size(hasse.hasse);
    

    if nodes[1][2]=[]
       then
        Info(InfoPolymaking,1,"polymake returned dual Hasse diagram. Recovering original");
        ####
        # if the Hasse diagram ends in a list of points,
        # we do some strange permutation and renumbering to get a Hasse 
        # diagram starting with points (and the dimension of the faces 
        # increases as we proceed down)
        ####
        Apply(faceblocks,i->Reversed(facenumber-i+1));
#        permlist:=[facenumber];
        permlist:=Concatenation(faceblocks);
#        Append(permlist,Concatenation(faceblocks));
#        Add(permlist,1);
        
        pi:=PermList(permlist);
        nodes:=Permuted(nodes,pi);
            # now we have the faces in ascending order. But the second 
            # column is still wrong. So we do some renumbering:
        #permlist[1]:=Size(nodes);
        #pi2:=PermList(permlist); 
        for node in nodes
          do
            node[2]:=OnSets(node[2],pi);
        od;
    fi;
    
    ####
    # now the Hasse <nodes>diagram starts with a list of points (i.e. 
    # the faces are ordered ascendingly wrt dimension), this will work:
    ####
    Remove(nodes,1);
    Apply(nodes,i->Concatenation(i,[[]]));
    maxnode:=Size(nodes);
#    Remove(nodes,maxnode);
    for i in [1..maxnode]#-1]
      do
#        Apply(nodes[i][1],i->i+1);
#        if nodes[i][2]=[maxnode]
#           then
#            nodes[i][2]:=[];
#        else
            for upface in nodes[i][2]
              do
                Add(nodes[upface-1][3],i);
            od;
#        fi;
    od;
    
    for node in nodes
      do
        Apply(node,Set);
    od;
    
    Apply(faceblocks,i->i-1);
    #    Add(faceblocks,[maxnode]);
    #
    # And now we split the nodes of the Hasse diagram according to dimension.
    # This was added when the function was already complete. So this is 
    # probably not the right order of doing things. But I didn't want to 
    # rewrite the renumbering part above...
    #
    faceblocks:=Set(faceblocks);
    RemoveSet(faceblocks,[0]);
    
    for blockindex in [1..Size(faceblocks)]
      do
        nodes[blockindex]:=nodes{faceblocks[blockindex]};
    od;
    while Size(nodes)>Size(faceblocks)
      do
        Remove(nodes);
    od;     
    for blockindex in [1..Size(nodes)]
      do
        if blockindex>1
           then
            downshift:=-faceblocks[blockindex-1][1]+1;
        else
            downshift:=0;
        fi;
        if blockindex<Size(nodes)
           then
            upshift:=-faceblocks[blockindex+1][1];
        else
            upshift:=0;
        fi;
        for face in nodes[blockindex]
          do
            face[2]:=face[2]+upshift;
            face[3]:=face[3]+downshift;
        od;
    od;
    
    #ForAll(faceblocks,IsRange);
#    returnrec:=rec(hasse:=nodes, 
#                   modgens:=List(nodes,n->List(n,i->i[1])),
#                   elts:=[]);    #faceindices:=Set(faceblocks));
#   return returnrec;
    MakeImmutable(nodes);
    return nodes;

end);