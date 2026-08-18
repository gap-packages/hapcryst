[![CI](https://github.com/gap-packages/hapcryst/actions/workflows/CI.yml/badge.svg)](https://github.com/gap-packages/hapcryst/actions/workflows/CI.yml)
[![Code Coverage](https://codecov.io/github/gap-packages/hapcryst/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/hapcryst)

# HAPcryst

A GAP4 extension for HAP calculating resolutions for Bieberbach groups.

Copyright (C) Marc Roeder 2007-2008

Marc Roeder  
NUI Galway, Ireland

This package is an add-on for Graham Ellis' HAP package. HAPcryst
implements some functions for crystallographic groups, namely
OrbitStabilizer-type methods. It is also capable of calculating free
resolutions for Bieberbach groups.

HAPcryst is distributed under the terms of the GNU General Public
License version 2.0 or later. See [LICENSE](LICENSE) for the text of
version 2, or visit <https://gnu.org/copyleft/gpl.html>.

Please send bug reports to
<https://github.com/gap-packages/hapcryst/issues>.

## Installation

HAPcryst depends on the following packages:

- `hap` (as HAPcryst is an extension of HAP)
- `polymaking` (which in turn depends on external software)
- `Cryst`

HAPcryst will not load if you do not have a recent version of those
packages installed.

The following packages are not required but suggested:

- `Carat`
- `CrystCat`
- `GAPDoc`

1. Download the package archive `HAPcryst<ver>.tar.bz2`,
   `HAPcryst<ver>.tar.gz`, or `HAPcryst<ver>-win.zip` (where `<ver>` is
   some version number) to the `pkg/` directory of the GAP home
   directory. If you do not have permission to do so, create a
   directory called `gap/pkg` in your home directory.
2. Change directory to `pkg/` and unpack the archive using the
   corresponding command:

   ```sh
   tar -xjf HAPcryst<ver>.tar.bz2
   tar -xzf HAPcryst<ver>.tar.gz
   unzip HAPcryst<ver>-win.zip
   ```

   Replace `<ver>` with the version number.
3. Start GAP. If you have created the directory `gap/pkg` in your home
   directory, use `gap -l '<homedir>/gap;'` where `<homedir>` is the
   path of your home directory. Use `pwd` to find out what it is if you
   do not know.
4. Call GAP and type `LoadPackage("hapcryst");` to load HAPcryst. If GAP
   returns some error messages, load `hap`.
5. Run the test file by calling
   `ReadPackage("hapcryst","tst/testall.g");`.

## Recommendation

Calculating resolutions of Bieberbach groups involves convex hull
computations. `polymake` by default uses `cdd` to compute convex hulls.
Experiments suggest that `lrs` is the more suitable algorithm for the
convex hull computations done in HAPcryst than the standard `cdd`. You
can change the behaviour of `polymake` by editing the file
`<homedir>/.polymake/prefer.pl`. It should contain a section like this;
just make sure `lrs` is before `cdd`. The position of `beneath_beyond`
does not matter.

```text
application polytope;

prefer "*.convex_hull  lrs, beneath_beyond, cdd";
```

## Documentation

The documentation of the package can be found in the `doc/`
subdirectory.

A second part of the documentation describes datatypes used in
HAPcryst. This can be found in the `lib/datatypes/doc` subdirectory of
the HAPcryst main directory.

## Examples

The `examples` directory contains code that generates pictures
(JavaView applets) of Dirichlet domains of 3-dimensional Bieberbach
groups with coloured orbits of the group acting on the faces of the
tessellation of `R^3`.

```text
gap> ReadPackage("hapcryst","examples/3dimBieberbachFD.gap");
gap> viewFundamentalDomain([0,0,0],1);
```

For instructions, see `examples/3dimBieberbacFD.gap` in the hapcryst
package tree. The functions will also generate pictures of Dirichlet
domains for non-Bieberbach groups, but the orientation of the shown
edges does not necessarily make sense any more.
