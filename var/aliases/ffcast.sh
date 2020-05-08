##
# Screenshot a window selected by mouse
#
ffcast-screenshot-window() {
        local ofile=$(mktemp -u /tmp/screenshot.XXXX.png)
        ffcast -q -fw png $ofile
        echo $ofile
}
# this is a test

##
# Screenshot a desktop region selected by mouse
ffcast-screenshot-region() {
        local ofile=$(mktemp -u /tmp/screenshot.XXXX.png)
        ffcast -q -s trim png $ofile
        echo $ofile
}

##
# Screenrecord a desktop region slected by mouse
ffcast-screenrecord-region() {
        local ofile=$(mktemp -u /tmp/screenrecord.XXXX.mp4)
        echo 
        ffcast -q -s % ffmpeg \
                -f x11grab \
                -show_region 1 \
                -framerate 25 \
                -video_size %s \
                -i %D+%c \
                -codec:v libx264 \
                -b:v 20000k \
                -vf crop="iw-mod(iw\\,2):ih-mod(ih\\,2)" \
                $ofile 1>
        echo $ofile
}
