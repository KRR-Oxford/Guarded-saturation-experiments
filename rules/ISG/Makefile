
dlgp:
	wget https://github.com/mburon/guarded-saturation-experiments/releases/download/0.0.1/ISG.DLPGs.zip -O ISG.DLPGs.zip
	unzip ISG.DLPGs.zip

owl:
	mkdir OWL;
	wget -A owl -m -p -E -K -np http://krr-nas.cs.ox.ac.uk/ontologies/UID/
	mv krr-nas.cs.ox.ac.uk/ontologies/UID/* OWL/
	rm -r krr-nas.cs.ox.ac.uk

build:
	../OWL2DLGP.sh ISG
