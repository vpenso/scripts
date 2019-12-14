alias sxiv='sxiv -pb'

function sxiv-thumbnail() {
        # default to working directory
        sxiv -rtp ${1:-.}
}
