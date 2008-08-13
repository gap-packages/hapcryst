libdir:=Directory("../");
docdir:=Directory(".");
docdir2libdir:="../";
lscommand:=Filename(Directory("/bin/"),"ls");

main := "resolutionAccess.xml";  #the main documentation file
bookname := "resolutionAccess";  


files:=[];
stdout:=OutputTextString(files,false);
stdin:=InputTextNone();;
Process( libdir, lscommand , stdin, stdout, [] );
files:=Set(SplitString(files,"\n"));
SubtractSet(files,Filtered(files,f->'~' in f));
Apply(files,f->Concatenation([docdir2libdir,f]));

MakeGAPDocDoc(docdir,main,files,bookname);
QUIT;
