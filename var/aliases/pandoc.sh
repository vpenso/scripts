
function pandoc-html-article() {
  pandoc \
    --standalone \
    --toc \
    --include-in-header=$SCRIPTS/var/lib/pandoc/light.css \
    --highlight-style pygments \
    --template  $SCRIPTS/var/lib/pandoc/html-article.template \
    --read=markdown_github+yaml_metadata_block \
    "$@"
}

function pandoc-html-book() {
  pandoc \
    --standalone \
    --toc \
    --include-in-header=$SCRIPTS/etc/default/pandoc.css \
    --highlight-style pygments \
    --template  $SCRIPTS/var/lib/pandoc/html-book.template \
    --read=markdown_github+yaml_metadata_block \
    --number-sections \
    "$@"
}

