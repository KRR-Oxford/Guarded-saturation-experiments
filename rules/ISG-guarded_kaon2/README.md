# ISG Ontologies cleaned for GSat and KAON2

It is a [collection of ontologies from the Information Systems Group](http://www.cs.ox.ac.uk/isg/ontologies/).

The file names correspond to the entries on the [readme](http://krr-nas.cs.ox.ac.uk/ontologies/readme.htm), that have been filtered using OWLSanitiser java class. It simplifies the set of OWL axioms into a set of OWL axioms that each represents at most one TGD (see how to  them below in OWL or DLPG format). Then, it filters the axioms that (i) represent guarded TGDs without equality symbols and (ii) that are supported by KAON2 (i.e. in SHIQ DL fragment).

## Get the rules in DLPG format

### By downloading the kept files (not trivial and without redundancy)

download `ISG-guarded_kaon2-kept.7z` in the release

### By downloading the generated files 

```bash
make dlgp
```

### By generating the files

```bash
# download the OWL files in OWL directory
make owl

# build the DLGP files
# may take a long time 
make build
```

## Statistics

The statistics of the ontologies can be found in `stats.csv`. The column names are:
- NAME the file name
- OTHER, the number of other dependencies (should be zero)
- FACT the number of facts,
- EqGD, the number of contraints with equality predicates,
- NEG_TGD, the number of TGD containing bottom in its head,
- FGTGDs, the number of guarded full TGDs,
- FNotGTGDs, the number of not guarded full TGDs,
- ExGTGD, the number of guarded non full TGDs,
- ExNotGTGD, the number of not guarded non full TGDs,
- TGD, the total number of TGDs.
