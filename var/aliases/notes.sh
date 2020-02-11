notes() {
        local notes=$SCRIPTS/var/notes.txt
        date >> $notes
        echo >> $notes
        if [[ $# -ne 0 ]]
        then
                echo "$@" >> $notes
        else
                vim "+normal Go" +startinsert $notes
        fi
}
