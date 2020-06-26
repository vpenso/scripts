
# execute the same command multiple times
#
run() {
    number=$1
    shift
    for i in `seq $number`; do
      $@
    done
}
