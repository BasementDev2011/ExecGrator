#!/bin/bash

ExecGrator="v1.1.1 [QUICK PATCH]"

if [ "$1" = "version" ]
then
{
    echo "ExecGrator version $ExecGrator"
    exit 1
}
fi

if [ "$1" = "help" ]
then
{
    echo "ExecGrator version $ExecGrator"

    echo "ExecGrator usage:"
    echo "bash execgrator install /path/to/folder /path/to/executable/file/executable_example.x86_64"
    echo "Options:"
    echo "install-single : install only a single executable"
    echo "Usage: bash execgrator install-single /home/path/to/executable"
    echo "install : Installs an entire folder + executable"
    echo "Usage example: "
    echo "bash execgrator install /path/to/folder /path/to/executable/file/executable_example.x86_64"

    exit 1
}
fi

if [ "$1" = "install-single" ]
then
{
    executable_location="$2"
    executable_location="${executable_location%/}"
    if [ ! -e "$executable_location" ]
    then
    {
        echo "ERROR: Incomplete parameters"
        echo "File not found"
        echo "Usage example:"
        echo "bash execgrator install-single /home/path/to/executable"
        exit 1
    }
    fi
    read -p "Provide Application category (Game,Accessories,Development,Internet, etc..): " executable_category
    read -p "Provide Application icon location (optional, press ENTER to skip): " executable_icon
    echo "Executable located."
    executable_name="${executable_location##*/}"
    executable_name_no_extension="${executable_name%.*}"

    echo "Executable name: $executable_name"
    echo "Folder name $executable_name_no_extension"
    echo "Executable Location $executable_location"
    mkdir -p "$HOME/Applications"
    mkdir -p "$HOME/Applications/$executable_name_no_extension"
    cp "$executable_location" "$HOME/Applications/$executable_name_no_extension"
    cd "$HOME/Applications/$executable_name_no_extension"
    pwd
    touch "$executable_name_no_extension.desktop"
cat <<EOF > "$executable_name_no_extension.desktop"
[Desktop Entry]
Name=$executable_name_no_extension
Exec=$HOME/Applications/$executable_name_no_extension/$executable_name
Type=Application
Categories=$executable_category;
Terminal=false
Icon=$executable_icon
EOF
    cp "$HOME/Applications/$executable_name_no_extension/$executable_name_no_extension.desktop" "$HOME/.local/share/applications/"
    echo "Successfully installed executable"
    exit 1
}
fi

if [ "$1" = "install" ]
then
    mkdir -p "$HOME/Applications/"
    folder_location="$2"
    executable_location="$3"
    if [ ! -f "$executable_location" ] || [ ! -d "$folder_location" ]
    then
        echo "ERROR: Incomplete parameters"
        echo "Usage example: "
        echo "bash execgrator install /path/to/folder /path/to/executable/file/executable_example.x86_64"
        exit 1
    fi
    folder_name="${folder_location##*/}"
    folder_location="${folder_location%/}"
    folder_name="${folder_location##*/}"
    echo "$folder_location"
    read -p "Provide Application category (Game,Accessories,Development,Internet, etc..): " executable_category
    read -p "Provide Application icon location (optional, press ENTER to skip): " executable_icon
    cp -R "$folder_location" "$HOME/Applications"
    touch "$folder_name.desktop"
cat <<EOF > "$folder_name.desktop"
[Desktop Entry]
Name=$folder_name
Exec=$executable_location
Type=Application
Categories=$executable_category;
Terminal=false
Icon=$executable_icon
EOF
    cp "$folder_name.desktop" "$HOME/.local/share/applications/"
    echo "Successfully installed folder to $HOME/Applications/$folder_name"
    exit 1
fi

if [ "$1" = "remove" ]
then
    folder_location="$2"
    folder_name="${folder_location##*/}"
    if [ ! -d "$folder_location" ]
    then
        echo "ERROR: Folder location missing"
        echo "Usage example: bash execgrator.sh remove /path/to/folder"
        exit 1
    fi
    rm -rf "$folder_location"
    rm "$HOME/.local/share/applications/$folder_name.desktop"
    echo "Successfully removed folder"
fi
