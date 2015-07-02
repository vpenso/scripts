alias m2h="pandoc --standalone --include-in-header=$SCRIPTS/etc/default/pandoc.css --highlight-style pygments --template  $SCRIPTS/var/lib/pandoc.template --read=markdown_github+yaml_metadata_block --number-sections"
alias m2ht="m2h --toc"
