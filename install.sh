#!/bin/bash

ANACONDA_INST_DIR=./anaconda_installer
ANACONDA_INSTALLER_NAME=Anaconda3-2024.06-1-Linux-x86_64.sh

PYVER="python3.12"
REPONAME="msph306"
DESK_ICO=$HOME/Desktop/Anaconda-Navigator.desktop


echo "Starting Anaconda Installation"

# If unavailable, then download the latest Anaconda installer
if ! test -f $ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME; then 
	mkdir -p $ANACONDA_INST_DIR
	curl -o ./$ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME -O https://repo.anaconda.com/archive/$ANACONDA_INSTALLER_NAME
fi

# Install Anaconda silently
bash $ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME -b -p $HOME/anaconda3

# Initialize Anaconda but do not activate on startup
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

echo "Creating Desktop icon @ ${DESK_ICO} and copying MSPH306 git repo to ${HOME}"

# Create a desktop entry for Anaconda Navigator
cat <<EOF > $DESK_ICO
[Desktop Entry]
Name=Anaconda Navigator
Comment=Launch Anaconda Navigator
Exec=$HOME/anaconda3/bin/anaconda-navigator
Icon=$HOME/anaconda3/lib/$PYVER/site-packages/anaconda_navigator/static/images/anaconda-icon-256x256.png
Terminal=false
Type=Application
Categories=Development;Education;
EOF

# Make the desktop entry executable
gio set $DESK_ICO metadata::trusted true
chmod +x $DESK_ICO

#Copy the repository to homedir
mkdir $HOME/$REPONAME
rsync -vra --exclude="${ANACONDA_INSTALLER_NAME}" --progress ./ $HOME/$REPONAME

# Make all files read only
chmod -R 544 $HOME/$REPONAME

echo "Installation and desktop icon creation complete!"
