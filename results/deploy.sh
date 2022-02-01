#!/bin/bash

rsync -v -ar plots maxron@linux.cs.ox.ac.uk:/fs/website/people/maxime.buron/blog/vldb22/
rsync -v -ar plots-blow maxron@linux.cs.ox.ac.uk:/fs/website/people/maxime.buron/blog/vldb22/
rsync -av analyze.html maxron@linux.cs.ox.ac.uk:/fs/website/people/maxime.buron/blog/vldb22/index.html
rsync -av ISG-guarded_kaon2/*.css maxron@linux.cs.ox.ac.uk:/fs/website/people/maxime.buron/blog/vldb22/
rsync -av ISG-guarded_kaon2/*.js maxron@linux.cs.ox.ac.uk:/fs/website/people/maxime.buron/blog/vldb22/
