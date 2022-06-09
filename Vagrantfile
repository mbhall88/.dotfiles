# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
# Box / OS
VAGRANT_BOX = 'ubuntu/bionic64'

# Memorable name for your VM
VM_NAME = 'dev-vm'

# VM User — 'vagrant' by default
VM_USER = 'vagrant'

# Username on your machine
HOME = ENV['HOME']

# Host folder to sync
HOST_PATH = HOME + '/' + VM_NAME
HOST_PROJ_PATH = HOME + '/' + 'Projects'
# Where to sync to on Guest — 'vagrant' is the default user name
GUEST_PATH = '/home/' + VM_USER + '/' + VM_NAME
GUEST_PROJ_PATH = '/home/' + VM_USER + '/' + 'Projects'
# # VM Port — uncomment this to use NAT instead of DHCP
# VM_PORT = 8080

Vagrant.configure(2) do |config|
  # Vagrant box from Hashicorp
  config.vm.box = VAGRANT_BOX
  config.disksize.size = '40GB'
  # Actual machine name
  config.vm.hostname = VM_NAME
  # allow X-forwarding
  config.ssh.forward_x11 = true
  # setup port-forwarding for port 8888
  config.vm.network "forwarded_port", guest: 8888, host: 8080

  # Set VM name in Virtualbox
  config.vm.provider "virtualbox" do |v|
    v.name = VM_NAME
    v.memory = 6000
    v.cpus = 1
  end

  #DHCP — comment this out if planning on using NAT instead
  config.vm.network "private_network", type: "dhcp"
  # # Port forwarding — uncomment this to use NAT instead of DHCP
  # config.vm.network "forwarded_port", guest: 80, host: VM_PORT
  # Sync folder
  config.vm.synced_folder HOST_PATH, GUEST_PATH
  config.vm.synced_folder HOST_PROJ_PATH, GUEST_PROJ_PATH

  # Disable default Vagrant folder, use a unique path per project
  config.vm.synced_folder '.', '/home/'+VM_USER+'', disabled: true

  # Install required programs
  config.vm.provision "shell", inline: <<-SHELL
    PKGS="language-pack-en git vim make cmake build-essential python3-pip\
        python debootstrap x11-apps zlib1g-dev libgl1-mesa-glx libarchive-dev"
    apt-get update
    pip install --upgrade pip

    for p in $PKGS; do
      apt-get install -y $p
    done

    apt-get update
    apt-get upgrade -y
    apt-get autoremove -y
    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
    dpkg-reconfigure locales

    # ==========================
    # INSTALL SINGULARITY and GO
    # https://github.com/apptainer/singularity/blob/master/INSTALL.md
    # Ensure repositories are up-to-date
    sudo apt-get update
    # Install debian packages for dependencies
    sudo apt-get install -y \
        build-essential \
        libseccomp-dev \
        pkg-config \
        squashfs-tools \
        cryptsetup \
        curl wget git

    # GO
    export VERSION=1.17.3 OS=linux ARCH=amd64
    wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz 
    tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz
    export GOPATH=${HOME}/go
    export PATH=/usr/local/go/bin:$PATH

    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh |
        sh -s -- -b $(go env GOPATH)/bin v1.43.0

    export PATH=$PATH:$(go env GOPATH)/bin

    # SINGULARITY
    mkdir -p ${HOME}/sw && cd ${HOME}/sw
    git clone https://github.com/hpcng/singularity.git  && cd singularity
    export VERSION=3.8.4
    git checkout v${VERSION}
    ./mconfig && cd ./builddir && make && make install
    # ==========================

    # ==========================
    # INSTALL ZSH
    cd ~
    apt-get update
    apt-get -y install zsh
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    chsh -s /bin/zsh vagrant
    # ==========================

    # ==========================
    # INSTALL DOCKER
    apt install -y apt-transport-https
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt install -y docker-ce
    # manage docker as a on-root user https://docs.docker.com/install/linux/linux-postinstall/
    groupadd docker
    usermod -aG docker "$USER"

    # ==========================
    # INSTALL CONDA
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p "${HOME}/miniconda"
    "${HOME}/miniconda"/bin/activate
    "${HOME}/miniconda"/condabin/conda init zsh

    # ==========================
    # INSTALL RUST
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    # ==========================

    # ==========================
    # Install rust utilities
    cargo install exa ripgrep du-dust zoxide fd-find
    # ==========================

    # ==========================
    # INSTALL STARSHIP
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

  SHELL
end
