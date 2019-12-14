# Cf. https://github.com/derf/feh
#
# Install on Debian with `apt install -y feh`
#
command -v feh >&- && {

        alias f='feh --conversion-timeout 1'

        # open images in thumbnail mode
        alias ft='feh -t -E 256 -y 256 -H 1200 -W 1920 -xF'

        # set a desktop background
        alias feh-bg='feh --bg-scale'

        # restore the background in the next session
        test -f ~/.fehbg && source ~/.fehbg
}
