#!/bin/bash
clear


echo "====================== installeer nginx ====================================="
apt-get update
apt-get -y install nginx

echo "====================== installeer R ====================================="
### installeer R, voeg toe aan trusted lijst
sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'

### add keys
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

### install
apt-get update
apt-get -y install r-base

### installeer dependencies om devtools te kunnen installeren
apt-get -y install libcurl4-gnutls-dev
apt-get -y install libxml2-dev
apt-get -y install libssl-dev

#### installeer veel gebruikte R packages
su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('randomForest', repos='http://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('h2o', repos='http://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('dplyr', repos='http://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('stringr', repos='http://cran.rstudio.com/')\""

echo "====================== installeer R studio server ====================================="
#### Rstudio Server
apt-get -y install libapparmor1 gdebi-core
wget https://download2.rstudio.org/rstudio-server-0.99.902-amd64.deb
gdebi -n rstudio-server-0.99.902-amd64.deb

echo "========================== java voor h20 nodig ==========================================="
sudo apt-get -y install default-jdk

echo "=========================== shiny server ================================================"
su - -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
su - -c "R -e \"install.packages('shinydashboard', repos='https://cran.rstudio.com/')\""

wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.2.786-amd64.deb
gdebi -n shiny-server-1.4.2.786-amd64.deb


echo "=========================== MXNET ======================================================="
apt-get install -y build-essential git libatlas-base-dev libopencv-dev
git clone --recursive https://github.com/dmlc/mxnet
cd mxnet; make -j$(nproc)

cd R-package
Rscript -e "library(devtools); library(methods); options(repos=c(CRAN='https://cran.rstudio.com')); install_deps(dependencies = TRUE)"
cd ..
make rpkg

R CMD INSTALL mxnet_0.7.tar.gz

