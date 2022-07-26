SetPackageInfo( rec(

PackageName := "HAPcryst",
Subtitle := "A HAP extension for crystallographic groups",
Version := "0.1.15",
Date := "26/07/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "roeder.marc@gmail.com",
  ),
  rec(
    LastName      := "GAP Team",
    FirstNames    := "The",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "support@gap-system.org",
  ),
],

# Status := "accepted",
Status := "deposited",

PackageWWWHome  := "https://gap-packages.github.io/hapcryst/",
README_URL      := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/hapcryst",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/hapcryst-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "This is an extension to the HAP package by Graham Ellis. It implements geometric methods for the calculation of resolutions of Bieberbach groups.",

PackageDoc := [
rec(
  # use same as in GAP
  BookName  := "HAPcryst",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
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
  GAP := ">=4.9",
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
  ExternalConditions := ["polymake (https://polymake.org) must be installed to calculate resolutions"]
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := ["homological algebra","crystallographic groups","resolution"],

AutoDoc := rec(
    TitlePage := rec(
        Acknowledgements := """
          This work was supported by Marie Curie Grant No. MTKD-CT-2006-042685
        """,
        Copyright := """
            &copyright; 2007 Marc Röder. <P/>

            This package is distributed under the terms of the GNU General
            Public License version 2 or later (at your convenience). See the
            file <File>LICENSE</File> or
            <URL>https://www.gnu.org/copyleft/gpl.html</URL>
        """,
        Version := Concatenation( "Version ", ~.Version ),
    )
),

));
