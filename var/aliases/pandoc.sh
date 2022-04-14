export PANDOC_CSS=light
export PANDOC_OPTS=

function pandoc-md2html() {
        local file=${1:?Specify markdown input file}
        local ofile=${1%.*}.html
        pandoc --standalone \
               --toc \
               --self-contained \
               --highlight pygments \
               --css $SCRIPTS/var/lib/pandoc/$PANDOC_CSS.css \
               --output $ofile \
               $PANDOC_OPTS \
               $file
        echo $ofile
}
