agp() { augtool print /files/$@ ; }     
alias ags='augtool -sb'               # modify target an backup to <path>.augsave
alias agn='augtool -n'                # don't modifiy target, but create <path>.augnew 
agdiff() { diff -up $1 $1.augnew ; }  # compare test output with original
