## Input/Output Redirection 

STDIO (Standard Input/Output):

* Buffered data stream (flow of text data) that originates at some source and may flow to one or more programs as input
* Stream data from the output of one program (file, device) to the input of another program (file, device)
* Infrastructure required to implement **pipes**

STDIO data streams automatically opened as a file at the startup of a program:

* **STDIN** (standard input) - Usually input from the keyboard, can be a redirect from any file
* **STDOUT** (standard output) - Sends the data stream to the display by default, can be redirected to a file/pipe
* **STDERR** (standard error) - Usually sent to the display, can be redirected to a log file

Descriptors stdin 0, stdout 1, stderr 2:

    > f            create empty file f (same as : > f)
    c > f          stdout of command c to file f (same as c 1> f)
    c >> f         append stdout of c to f
    c < f          content of file f to stdin of c (same as c 0< f)
    c 1>&-         close stdout of command c
    c 2> f         stderr of c to file f
    c > f 2>&1     stdout/stderr fo command c to file f
    c &> f         same as above
    c1 <(c2)       stdout of command c2 to stdin of command c1
    c1 >(c2)       stdout of command c1 to stdin of command c2
    c < f1 > f2    content of file f1 to stdin of command c, stdout to file f2  
    (c1 ; c2) > f  redirect stdout of multiple commands to file f (sub-shell)
    {c1 ; c2} > f  same as above in current shell
    c1 | c2        pipe stdout of command c1 to stdin of command c2
    c1 |& c2       pipe stdout and stderr of command c1 to stdin of command c2
    c | tee f      stdout of command c to screen and file f
    c |:           pipeline sink (like >/dev/null)

