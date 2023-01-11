

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

##
# Convert a video (e.g. a screen cap) to a gif
#
ffmpeg-video2gif() {
        local input_video_path="$1"
        local output_gif_path="$2"
        local fps="${3:-10}"
        local scale="${4:-1080}"
        local loop="${5:-0}"

        ffmpeg -i "${input_video_path}" \
               -vf "setpts=PTS/1,fps=${fps},scale=${scale}:-2:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
               -loop $loop "${output_gif_path}"
}
