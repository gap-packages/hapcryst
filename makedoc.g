##  this creates the documentation, needs: GAPDoc and AutoDoc packages, pdflatex
##
##  Call this with GAP from within the package directory.
##

if fail = LoadPackage("AutoDoc", ">= 2016.01.21") then
    Error("AutoDoc 2016.01.21 or newer is required");
fi;

AutoDoc(rec( scaffold := rec( MainPage := false )));

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

# Create the manual.lab file which is needed if the main manuals or another 
# package is referring to your package
GAPDocManualLab( "HAPcryst" );; 
 
