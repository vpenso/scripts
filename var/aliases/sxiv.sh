alias s='sxiv -pb'

function st() {
        # default to working directory
        sxiv -rtp ${1:-.}
}
