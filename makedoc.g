##  this creates the documentation, needs: GAPDoc and AutoDoc packages, pdflatex
##
##  Call this with GAP from within the package directory.
##

if fail = LoadPackage("AutoDoc", ">= 2016.01.21") then
    Error("AutoDoc 2016.01.21 or newer is required");
fi;

# GAP only registers package books that already have a manual.six file when
# LoadPackageDocumentation is called. Since we build the auxiliary HAPprog book
# first and the main manual in the same GAP session, the latter would otherwise
# still see the pre-build state and fail to resolve <Ref BookName="HAPprog">.
# Refreshing the package books here makes the newly written manual.six visible
# to the help system before AutoDoc builds the main manual.
RefreshPackageBooksForHelp := function(pkgname)
    local info, pkgdoc, norm, pos, variants;

    info := PackageInfo(pkgname)[1];
    for pkgdoc in info.PackageDoc do
        variants := [
            SIMPLE_STRING(pkgdoc.BookName),
            SIMPLE_STRING(Concatenation(pkgdoc.BookName, " (not loaded)"))
        ];
        for norm in variants do
            # Remove both the registered book name and any parsed manual.six
            # cache entry. This forces GAP to rescan the rebuilt book from disk.
            pos := Position(HELP_KNOWN_BOOKS[1], norm);
            if pos <> fail then
                HELP_REMOVE_BOOK(HELP_KNOWN_BOOKS[2][pos][1]);
            fi;
            if IsBound(HELP_BOOKS_INFO.(norm)) then
                Unbind(HELP_BOOKS_INFO.(norm));
            fi;
        od;
    od;

    LoadPackageDocumentation(info);
end;

#
# build the HAPProf book first, as the main book / package manual references it
#
MakeGAPDocDoc( "lib/datatypes/doc", # path to the directory containing the main file
               "resolutionAccess",  # the name of the main file (without extension)
                          # list of (probably source code) files relative 
                          # to path which contain pieces of documentation 
                          # which must be included in the document
[ "../contHomBieberbach.gi", "../contractingHomotopy.gd", "../contractingHomotopy.gi", 
  "../contractingHomotopy_GroupRing.gd", "../contractingHomotopy_GroupRing.gi", 
  "../resolutionAccess_GroupRing.gd", "../resolutionAccess_GroupRing.gi", 
  "../resolutionAccess_LargeGroupRep.gd", "../resolutionAccess_LargeGroupRep.gi", 
  "../resolutionAccess_SmallGroupRep.gd", "../resolutionAccess_SmallGroupRep.gi", 
  "../resolutionAccess_generic.gd", "../resolutionAccess_generic.gi" ],
               "resolutionAccess",# the name of the book used by GAP's online help
               "../../../../..", # optional: relative path to the main GAP root 
                           # directory to produce HTML files with relative 
                           # paths to external books.
               "MathJax"  # optional: use "MathJax", "Tth" and/or "MathML"
                          # to produce additional variants of HTML files
               );; 

# Copy the *.css and *.js files from the styles directory of the GAPDoc 
# package into the directory containing the package manual.
CopyHTMLStyleFiles( "lib/datatypes/doc" );

# Re-register both books after HAPprog has been built so the following AutoDoc
# run can resolve cross-references into it in this same GAP session.
RefreshPackageBooksForHelp("hapcryst");

#
# Build the actual package manual
#
old_InfoAutoDoc:=InfoLevel(InfoAutoDoc);
SetInfoLevel(InfoAutoDoc, 0);  # avoid  "WARNING: Package contains multiple books, only using the first one"
AutoDoc(rec(
    scaffold := rec( MainPage := false ),
));
SetInfoLevel(InfoAutoDoc, old_InfoAutoDoc);
