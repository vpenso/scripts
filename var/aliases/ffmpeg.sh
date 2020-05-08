

##
# Record vidoe from X11 primary output and audio from Pulse
# Select audio input with pavucontrol
ffmpeg-screen-recording() {
        local dimension=$(xdpyinfo | grep dimensions | awk '{print $2;}')
        local output_file=${1:-$(mktemp /tmp/ffmpeg-screen-recording.XXXXXX.mkv)}
        ffmpeg -y \
               -f x11grab \
               -s $dimension \
               -i :0.0 \
               -f pulse \
               -i default \
               -c:v libx264 -r 30 \
               -c:a flac \
               $output_file
        echo Recording stored to $output_file
}
