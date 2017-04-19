export PANDOC_CSS=light

function pandoc-html-article() {
  pandoc \
    --standalone \
    --include-in-header=$SCRIPTS/var/lib/pandoc/${PANDOC_CSS}.css \
    --highlight-style pygments \
    --template  $SCRIPTS/var/lib/pandoc/html-article.template \
    --read=markdown_github+yaml_metadata_block \
    "$@"
}

function pandoc-html-book() {
  pandoc \
    --standalone \
    --toc \
    --include-in-header=$SCRIPTS/var/lib/pandoc/${PANDOC_CSS}.css \
    --highlight-style pygments \
    --template  $SCRIPTS/var/lib/pandoc/html-book.template \
    --read=markdown_github+yaml_metadata_block \
    --number-sections \
    "$@"
}

