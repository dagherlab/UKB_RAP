# Assume folder_path is passed as a string input
echo "Looking in folder: connectome/$folder_path"
ls
ls /mnt/project/
ls /mnt/project/connectome
if [ ! -d "/mnt/project/connectome/$folder_path" ]; then
    echo "Error: Folder does not exist"
    exit 1
fi

# Tar it
name=$(basename $folder_path)
tar -czf ${name}.tar.gz -C "/mnt/project/connectome/$folder_path" .
