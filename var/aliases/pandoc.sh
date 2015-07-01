alias m2h="pandoc --standalone --include-in-header=$SCRIPTS/etc/default/pandoc.css --highlight-style pygments --template  $SCRIPTS/var/lib/pandoc.template --read=markdown_github "
alias m2ht="m2h --toc"
