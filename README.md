# Experiments on Guarded Saturation

The following assumes that its projects have been cloned at the root of the Guarded-saturation project.

## How to run an experiment

0. copy or put your configuration into `./config.properties`,
1. gather or build DLGP files in the rule folder you choose under `rules/`,
2. execute `./run_exp.sh rules/<chosen folder>`,
3. find the log files of the execution in a new experiment folder under `results/`,
4. create the statistics file by executing `./get_stats.sh results/<experiment folder>`.

## Columns meaning of experiment statistics

- `NAME` is the name of the ontology,
- `NFTGD_NB` is the number of non full TGDs in the input after HNF and VNF
transformations,
- `FTGD_NB` is the number of full TGDs in the input after HNF and VNF
transformations,
- `SUBSUMED` is the number of the subsumed TGD during the GSat process,
- `NEW_FTGD_NB` is the number of derived full TGDs during the GSat process,
- `NEW_NFTGD_NB` is the number of derived non full TGDs during the GSat
process,
- `NEW_OUTPUT_SIZE` is the number of TGDs in the output, which are not
contained in the input,
- `OUTPUT_SIZE` is the number of the full TGDs in the output,
- `TIME` is the time of the GSat process in miliseconds.
