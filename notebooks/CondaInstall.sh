#!/usr/bin/env bash
# Determine OS and download latest Anaconda version, update and install it
# ======================================================
# Author:  Ömer Özak, 2016 (ozak at smu.edu)
# Website: http://omerozak.com
# GitHub:  https://github.com/ozak/
# ======================================================

# Determine Operating System

lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
KERNEL=`uname -r`
MACH=`uname -m`
ENDING="sh"
if [ "$OS" == "windowsnt" ]; then
    OS=windows
elif [ "$OS" == "darwin" ]; then
    OS="MacOSX"
else
    OS=`uname`
    if [ "$OS" = "SunOS" ] ; then
        OS=Solaris
        ARCH=`uname -p`
        OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
    elif [ "${OS}" = "AIX" ] ; then
        OSSTR="${OS} `oslevel` (`oslevel -r`)"
    elif [ "$OS" = "Linux" ] ; then
        if [ -f /etc/redhat-release ] ; then
            DistroBasedOn='RedHat'
            DIST=`cat /etc/redhat-release |sed s/\ release.*//`
            PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/SuSE-release ] ; then
            DistroBasedOn='SuSe'
            PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
            REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
        elif [ -f /etc/mandrake-release ] ; then
            DistroBasedOn='Mandrake'
            PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/debian_version ] ; then
            DistroBasedOn='Debian'
            DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
            PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
            REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
        fi
        OS=`lowercase $OS`
        DistroBasedOn=`lowercase $DistroBasedOn`
        readonly OS
        readonly DIST
        readonly DistroBasedOn
        readonly PSUEDONAME
        readonly REV
        readonly KERNEL
        readonly MACH
    fi
fi

if [ "$OS" == "windows" ]; then
  ENDING="exe"
fi

# Create directory where installer will be downloaded into
{
    mkdir ~/AnacondaInstaller && echo "Anaconda directory created"
}||{
    echo "Anaconda directory exists already"
}

# Download installer
wget http://repo.continuum.io/archive/Anaconda3-2019.07-$OS-x86_64.$ENDING -O ~/AnacondaInstaller/Anaconda3.$ENDING

# Verify Installer
if [ "$OS" == "MacOSX" ]; then
    md5 ~/AnacondaInstaller/Anaconda3.$ENDING
elif [ "$OS" == "Linux" ]; then
    md5sum ~/AnacondaInstaller/Anaconda3.$ENDING
fi

# Install
bash ~/AnacondaInstaller/Anaconda3.$ENDING -b -p $HOME/Anaconda3

# Upgrade
export PATH=$HOME/Anaconda3/bin:$PATH
unset PYTHONPATH
conda update conda
conda update --all -c conda-forge -c mro -c r

echo "Finished Basic Install!"
# Tab completion
conda install argcomplete -c conda-forge -c mro -c r
eval "$(register-python-argcomplete conda)"

# What does your configuration look like?
conda info
conda list

# Make sure to add the PATH change to .profile or .bash_profile or if using iTerm2 create a Profile for it
# export PATH="$HOME/Anaconda3/bin:$PATH"

# Also if you have another Python isntaller (e.g., Homebrew) correct PYTHON PATH
# unset PYTHONPATH
# export PYTHONPATH="$HOME/Dropbox/Python/shared:${PYTHONPATH}"

# Delete installer
rm ~/AnacondaInstaller/Anaconda3.sh
