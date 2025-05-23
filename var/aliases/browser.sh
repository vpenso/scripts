command -v firefox >/dev/null \
    && export BROWSER=${BROWSER:-firefox} \
    || echo 'warn: $BROWSER not set'
