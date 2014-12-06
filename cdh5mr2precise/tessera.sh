#!/bin/bash

export PROTO_BUF_VERSION=2.5.0
export RHIPE_VERSION=Rhipe_0.75.0_cdh5mr2

if [ -f ~/.build_tessera_done ]
then
   echo "Skipping Tessera components installation - already done"
else
   cd /tmp

   ## protobuf
   wget https://protobuf.googlecode.com/files/protobuf-$PROTO_BUF_VERSION.tar.bz2
   tar jxvf protobuf-$PROTO_BUF_VERSION.tar.bz2
   cd protobuf-$PROTO_BUF_VERSION
   ./configure && make -j4
   sudo make install
   cd ..
   rm -rf protobuf-*

   ## RHIPE
   export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
   export PKG_CONFIG_PATH=/usr/local/lib \
   wget http://ml.stat.purdue.edu/rhipebin/$RHIPE_VERSION.tar.gz \
   R CMD INSTALL $RHIPE_VERSION.tar.gz
   rm $RHIPE_VERSION.tar.gz \
   echo "export LD_LIBRARY_PATH=/usr/local/lib" | tee -a /home/$TESSERA_USER/rhRunner.sh \
   echo "exec /usr/bin/R CMD /usr/local/lib/R/site-library/Rhipe/bin/RhipeMapReduce --slave --silent --vanilla" | tee -a /home/$TESSERA_USER/rhRunner.sh \
   chown -R $TESSERA_USER:$TESSERA_USER /home/$TESSERA_USER \
   chmod 755 /home/$TESSERA_USER \
   chmod 755 /home/$TESSERA_USER/rhRunner.sh

   ## do initial downloading of maven artifacts
   git clone --depth=50 --recursive --branch=dev git://github.com/hafen/RHIPE.git
   cd RHIPE
   rm -rf /home/$TESSERA_USER/.m2
   mvn package --fail-never
   cd ..
   rm -rf RHIPE

   sudo -u $TESSERA_USER R -e "options(unzip = 'unzip', repos = 'http://cran.rstudio.com/'); library(devtools); install_github('tesseradata/datadr')"
   sudo -u $TESSERA_USER R -e "options(unzip = 'unzip', repos = 'http://cran.rstudio.com/'); library(devtools); install_github('tesseradata/trelliscope')"

   touch ~/.build_tessera_done
fi