export PANDOC_CSS=light
export PANDOC_OPTS=

function pandoc-md2html() {
        for file in $@
        do
                local ofile=${file%.*}.html
                pandoc --standalone \
                       --self-contained \
                       --highlight pygments \
                       --css $SCRIPTS/var/lib/pandoc/$PANDOC_CSS.css \
                       --output $ofile \
                       $PANDOC_OPTS \
                       $file
                echo $ofile
        done
}
