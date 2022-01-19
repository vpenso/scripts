export PANDOC_CSS=markdown
export PANDOC_OPTS=

function pandoc-md2html() {
        local file=${1:?Specify markdown input file}
        local ofile=${1%.*}.html
        pandoc --standalone \
               --self-contained \
               --highlight pygments \
               --css $SCRIPTS/var/lib/pandoc/$PANDOC_CSS.css \
               --output $ofile \
               $PANDOC_OPTS \
               $file
        echo $ofile
}
