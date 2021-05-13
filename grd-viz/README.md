# Graph of Rule Dependencies Visualizer

It draws the rule dependencies graph of a TGD set (see Mugnier, Thomazo (2014). An Introduction to Ontology-Based Query Answering with Existential Rules), which is a graph, where nodes are TGDs and there is a edge from r1 to r2 iff we can apply r2 after deriving some facts from an instance using r1. The graph is built using the tools [Kiabora](https://graphik-team.github.io/graal/downloads/kiabora).

It also allows to highlight the descendent or the ancestor of a TGD in the graph. You can also [visit a blog post](http://www.cs.ox.ac.uk/people/maxime.buron/blog/2021-04-28.html), that show an example of the use of this tools on the ontology ISG-00729.

## How to use it

First, you have to download kiabora:
```bash
wget https://graphik-team.github.io/graal/dl/kiabora-1.2.0.jar 
```

You have to run a static server in this directory ([see alternatives](https://gist.github.com/willurd/5720255)): 

```bash
## python 3
python -m http.server 8080
## visit for example: http://localhost:8080?path=analyzes/ISG-guarded_kaon2-bak/00729.txt
```
Then generate the graph of the chosen DLGP file, for example:
```bash
./analyze.sh ../rules/ISG-guarded_kaon2/00729.dlgp
```

