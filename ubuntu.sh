BootStrap: debootstrap
OSVersion: trusty
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%environment
    PATH="/apps/PhiSpy:/apps/miniconda/bin:$PATH"

%runscript
    exec python /apps/PhiSpy.py

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
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
    bash Miniconda2-latest-Linux-x86_64.sh -b -p /apps/miniconda
    rm Miniconda2-latest-Linux-x86_64.sh
    sudo ln -s /apps/miniconda/bin/python2.7 /usr/bin/python
    PATH="/apps/PhiSpy:/apps/miniconda/bin:$PATH"
    conda install -y -c bioconda biopython
    conda install -y -c bioconda R
    conda install -y -c bioconda r-randomforest
    
    git clone https://github.com/linsalrob/PhiSpy.git
    cd PhiSpy
    make
    unzip -q ./Test_Organism.zip

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
    PATH="/apps/PhiSpy:/apps/miniconda/bin:$PATH"
    cd /apps/PhiSpy
    ./PhiSpy.py -i Test_Organism/160490.1/ -o output_directory -t 25
