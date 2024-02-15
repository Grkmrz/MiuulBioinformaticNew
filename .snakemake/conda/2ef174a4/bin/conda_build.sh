if [ -z ${CONDA_BUILD+x} ]; then
    source /usr/local/miniconda/envs/bioconda/conda-bld/entrez-direct_1654551364503/work/build_env_setup.sh
fi
#!/bin/bash

# Keep track of the process
set -uex

mkdir -p $PREFIX/bin
mv * $PREFIX/bin
mkdir -p "$PREFIX/home"
export HOME="$PREFIX/home"

# Needs to run in the install folder
cd ${PREFIX}/bin

sh install.sh

# clean up
rm -rf eutils cmd 
rm -rf *.log *.go *.yaml setup.sh install.sh *.gz *.pdf 
rm -rf idx-* index-*  pm-*  custom* xy-* CA.pm cacert.pem

