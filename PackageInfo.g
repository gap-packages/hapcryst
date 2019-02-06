SetPackageInfo( rec(

PackageName := "HAPcryst",
Subtitle := "A HAP extension for crytallographic groups",
Version := "0.1.11",
Date := "27/10/2013",

ArchiveURL := "http://csserver.evansville.edu/~mroeder/HAPcryst/HAPcryst0_1_11",

ArchiveFormats := ".tar.gz,.tar.bz2,-win.zip", # the others are generated automatically

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "marc_roeder@web.de",
    WWWHome       := "http://csserver.evansville.edu/~mroeder",
#    PostalAddress := Concatenation( [
#                     "Department of Mathematics\n",
#                     "NUI Galway\n",
#                     "Ireland" ] ),
#     Place         := "Galway",
#     Institution   := "National University of Ireland, Galway"
  ),

],

# Status := "accepted",
Status := "deposited",

README_URL := "http://csserver.evansville.edu/~mroeder/HAPcryst/README.HAPcryst",
PackageInfoURL := "http://csserver.evansville.edu/~mroeder/HAPcryst/PackageInfo.g",

AbstractHTML := "This is an extension to the HAP package by Graham Ellis. It implements geometric methods for the calculation of resolutions of Bieberbach groups.",

PackageWWWHome := "http://csserver.evansville.edu/~mroeder/HAPcryst.html",

PackageDoc := [
rec(
  # use same as in GAP
  BookName  := "HAPcryst",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "The crystallographic group extension to HAP",
  Autoload  := true
),
rec(
  BookName  := "HAPprog",
  ArchiveURLSubset := ["lib/datatypes/doc"],
  HTMLStart := "lib/datatypes/doc/chap0.html",
  PDFFile   := "lib/datatypes/doc/manual.pdf",
  SixFile   := "lib/datatypes/doc/manual.six",
  LongTitle := "An experimental framework for objectifying the data structures of Hap",
  Autoload  := true
)
],


Dependencies := rec(
  GAP := ">=4.4.10",
  NeededOtherPackages := [
                   ["Polycyclic",">=2.8.1"],
                   ["AClib",">=1.1"],
                   ["cryst",">=4.1.5"],
                   ["HAP",">=1.8"],
                   ["polymaking",">=0.7.9"],
                   ],
  SuggestedOtherPackages := [
                   [ "Carat", ">=1.1" ],
                   ["CrystCat",">=1.1.2"],
                   ["GAPDoc", ">= 0.99"]
                   ],
  ExternalConditions := ["polymake (http://www.polymake.org) must be installed to calculate resolutions"]
),

AvailabilityTest := ReturnTrue,
BannerString := Concatenation(
  "----------------------------------------------------------------\n",
  "This is HAPcryst version ", ~.Version, "\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        "\n",
  "----------------------------------------------------------------\n" ),

Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["homological algebra","crystallographic groups","resolution"]

));
