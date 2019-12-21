export PANDOC_CSS=light
export PANDOC_OPTS=

function md2html() {
        local file=${1:?Specify markdown input file}
        local ofile=${1%.*}.html
        pandoc --standalone \
               --self-contained \
               --highlight pygments \
               --css $SCRIPTS/var/lib/pandoc/$PANDOC_CSS.css \
               --read=markdown_github+yaml_metadata_block \
               --output $ofile \
               $PANDOC_OPTS \
               $file
        echo $ofile
}
