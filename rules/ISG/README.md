# ISG Ontologies

It is a [collection of ontologies from the Information Systems Group](http://www.cs.ox.ac.uk/isg/ontologies/).

The file names correspond to the entries on the [readme](http://krr-nas.cs.ox.ac.uk/ontologies/readme.htm).

## Get the rules in DLPG format

### By downloading the generated files 

```bash
make dlgp
```

### By generating the files

```bash
# download the OWL files in OWL directory
# may take a long time
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

## Journal 

- In 9/4/2021, we generate the DLGP files using a modified version of [OWL2DLPG tool from Graal](https://graphik-team.github.io/graal/downloads/owl2dlgp). Some of the files may be duplicated, since some axioms are removed during the translation (disjunction, cardinality, etc).

- A "sanitised cleaned safe" version of the collection have been build in the past (as a collection of OWL files), where the axioms that can not be handled by guarded reasoning has been removed. Then, we deleted all the duplicate files (in the collection, there are different versions of the same ontology, and if you remove some axioms, they could become equivalent). We discovered that too many axioms have been removed. You can find the statistics of the corresponding rules in `sanitised_cleaned_safe_stats.csv`.

