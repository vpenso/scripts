MTPFS_MOUNT_POINT=~/mnt

export MTPFS_MOUNT_POINT

if command -v simple-mtpfs |:
then
        function mtpfs() {
                if [[ $# -eq 0 ]]
                then
                        simple-mtpfs -l
                fi
                if [[ $# -eq 1 ]]
                then
                        simple-mtpfs --device $1 $MTPFS_MOUNT_POINT
                fi
                if [[ $# -eq 2 ]]
                then
                        simple-mptfs --device $1 $2
                fi
        }
        # unmount with: fusermount -u ~/mnt
fi
