# Experiments on Guarded Saturation

The following assumes that its projects have been cloned at the root of the Guarded-saturation project.

## How to run an experiment

0. copy or put your configuration into `./config.properties`,
1. gather or build DLGP files in the rule folder you choose under `rules/`,
2. execute `./run_exp.sh rules/<chosen folder>`,
3. find the log files of the execution in a new experiment folder under `results/`,
4. create the statistics file by executing `./get_stats.sh results/<experiment folder>`.
