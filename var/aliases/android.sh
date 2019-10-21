MTPFS_MOUNT_POINT=~/mnt

export MTPFS_MOUNT_POINT

command -v simple-mtpfs >&- && {

        function android-mount() {
                if [[ $# -eq 0 ]]
                then
                        simple-mtpfs -l || {
                                echo Connect, and unlock your phone!
                        }
                fi
                if [[ $# -eq 1 ]]
                then
                        mkdir -p $MTPFS_MOUNT_POINT >/dev/null
                        simple-mtpfs --device $1 $MTPFS_MOUNT_POINT && {
                                echo Mount to $MTPFS_MOUNT_POINT
                        }
                fi
                if [[ $# -eq 2 ]]
                then
                        simple-mptfs --device $1 $2
                fi
        }

        # unmount with: fusermount -u ~/mnt
}
