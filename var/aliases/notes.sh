notes() {
        local notes=$SCRIPTS/var/notes.txt
        echo -e "## $(date)\n" >> $notes
        if [[ $# -ne 0 ]]
        then
                echo "$@" >> $notes
        else
                vim "+normal Go" +startinsert $notes
        fi
}
