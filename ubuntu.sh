BootStrap: debootstrap
OSVersion: trusty
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%environment
    PATH="/apps:/apps/miniconda/bin:$PATH"

%runscript
    exec echo "ehllo"

%post
    echo "Hello from inside the container"
    sed -i 's/$/ universe/' /etc/apt/sources.list

    #essential stuff
    apt -y --force-yes install git sudo man vim build-essential wget unzip

    #maybe dont need, add later if do:
    #curl autoconf libtool 
    mkdir /apps
    cd /apps
    #Miniconda for cutadapt / trimgalore
    #and if trimgalore works better we might just get rid of solexaqa
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p /apps/miniconda
    PATH="/apps:/apps/miniconda/bin:$PATH"
    conda install -y -f -q -c bioconda biopython
    conda install -y -f -q -c bioconda R
    conda install -y -f -q -c bioconda r-randomforest
    
    git clone https://github.com/linsalrob/PhiSpy.git
    cd PhiSpy
    make
    wget https://github.com/linsalrob/PhiSpy/blob/master/Test_Organism.zip
    gunzip ./Test_Organism.zip

    #cleanup    
    conda clean -y --all

    #create a directory to work in
    mkdir /work

    #so we dont get those stupid perl warnings
    locale-gen en_US.UTF-8

    #so we dont get those stupid worning on hpc/pbs
    mkdir /extra
    mkdir /xdisk

%test
    cd PhiSpy
    ./PhiSpy.py -i Test_Organism/160490.1/ -o output_directory -t 25
