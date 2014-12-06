#!/bin/bash

cd /tmp
## protobuf
wget https://protobuf.googlecode.com/files/protobuf-$PROTO_BUF_VERSION.tar.bz2
tar jxvf protobuf-$PROTO_BUF_VERSION.tar.bz2
cd protobuf-$PROTO_BUF_VERSION
./configure && make -j4
make install
cd ..
rm -rf protobuf-*

## RHIPE
USER tessera

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
export PKG_CONFIG_PATH=/usr/local/lib \
wget http://ml.stat.purdue.edu/rhipebin/$RHIPE_VERSION.tar.gz \
R CMD INSTALL $RHIPE_VERSION.tar.gz
rm $RHIPE_VERSION.tar.gz \
echo "export LD_LIBRARY_PATH=/usr/local/lib" | tee -a /home/tessera/rhRunner.sh \
echo "exec /usr/bin/R CMD /usr/local/lib/R/site-library/Rhipe/bin/RhipeMapReduce --slave --silent --vanilla" | tee -a /home/tessera/rhRunner.sh \
chown -R tessera:tessera /home/tessera \
chmod 755 /home/tessera \
chmod 755 /home/tessera/rhRunner.sh

## do initial downloading of maven artifacts
cd /home/tessera
git clone --depth=50 --recursive --branch=dev git://github.com/hafen/RHIPE.git
cd RHIPE
rm -rf /home/tessera/.m2
mvn package --fail-never
cd ..
rm -rf RHIPE

sudo -u $TESSERA_USER R -e "options(unzip = 'unzip', repos = 'http://cran.rstudio.com/'); library(devtools); install_github('tesseradata/datadr')"
sudo -u $TESSERA_USER R -e "options(unzip = 'unzip', repos = 'http://cran.rstudio.com/'); library(devtools); install_github('tesseradata/trelliscope')"
