command -v mp3info >/dev/null && \
{
        # Set MP3 artist and title from the file name
        #
        mp3info-filename() {
                # loop over all arguments
                for file in "$@"
                do
                        local artist=$(echo $file | cut -d. -f1 | cut -d- -f1)
                        local title=$(echo $file | cut -d. -f1 | cut -d- -f2)
                        mp3info -a $artist -t $title $file
                        mp3info $file
                done
        }
}
