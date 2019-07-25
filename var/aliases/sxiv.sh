alias sx='sxiv -pb'

function sxt() {
        # default to working directory
        sxiv -rtp ${1:-.}
}
