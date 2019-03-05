
function slideshow() {

        if command -v gromit-mpx |:
        then
                ds gromit-mpx
                echo Screen Annotation with gromit-mpx...F9 toggle painting, Shift-F9 clear screen, Alt-F9 quit
        fi

        if command -v key-mon |:
        then
                ds key-mon
                echo Highlight the mouse cursor and key combinations with key-mon
        fi

        if command -v surf |:
        then
                ds surf $1
        else
                $BROWSER $1
        fi
}

