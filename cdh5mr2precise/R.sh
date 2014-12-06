#!/bin/bash

if [ -f ~/.build_r_done ]
then
   echo "Skipping R installation - already done"
else
   ## build/install R
   sudo apt-get -y install pkg-config unzip libcairo2-dev libcurl4-openssl-dev screen libssl0.9.8 gdebi-core firefox libapparmor1 psmisc supervisor

   echo "deb http://cran.rstudio.com/bin/linux/ubuntu precise/" | sudo tee -a /etc/apt/sources.list
   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
   sudo apt-get -y update
   sudo apt-get install -y r-base-dev
   sudo chmod -R aou=rwx /usr/local/lib/R/site-library

   sudo R CMD javareconf

   ## rJava package
   sudo -u $TESSERA_USER R -e "install.packages('rJava', repos='http://www.rforge.net/')"

   ## shiny package
   sudo -u $TESSERA_USER R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"

   ## more packages
   sudo -u $TESSERA_USER R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
   sudo -u $TESSERA_USER R -e "install.packages('testthat', repos='http://cran.rstudio.com/')"
   sudo -u $TESSERA_USER R -e "install.packages('roxygen2', repos='http://cran.rstudio.com/')"

   touch ~/.build_r_done
fi