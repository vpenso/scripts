

The [gnuplot-timeseries][01] scripts wraps `gnuplot` to enable users the create time series plots easily. 
 
    » gnuplot-timeseries -h
    Create SVG plots from time-series data tables.

    gnuplot-timeseries [--debug] [--version] 
      [--column NAME[:NAME]] [--color RGB[:RGB]] 
      [--size WIDTH,HEIGHT] [TABLE]

      STDIN|TABLE
        Path to a file containing the input data TABLE.
        Alternativly use STDIN, to create a temporary
        file holding the input data table.

    gnuplot-timeseries expects the first column of the 
    input data table with a timestamp (default %Y-%m-%d) 
    and subsequent columns with the data to plot. The 
    frist row is exepceted to containe the names of the 
    columns, to be selected with the option --column.
    […]

The scripts expects a time stamp in the first column of the input data, and prints the SVG plot to _stdout_. 

    » cat /tmp/test.data
    DAY        A    B    C    D    E    F
    2013-11-01 100  25   1525 600  900  10
    2013-11-02 10   300  30   2400 4    425
    2013-11-03 1235 4    200  125  1565 1005
    2013-11-04 655  35   995  255  55   1025
    2013-11-05 25   85   725  95   1254 355
    2013-11-06 65   65   000  85   1154 455
    2013-11-07 195  75   155  75   1054 555
    2013-11-08 1955 125  725  65   954  655
    2013-11-09 15   225  525  55   854  900
    2013-11-10 990  455  525  45   454  950
    2013-11-11 500  955  325  0    254  1300
    » gnuplot-timeseries /tmp/test.data > /tmp/test.svg

Option `--print` will show the commands passed to _gunplot_. Pipe the output to _gnuplot_ for debugging:

    » gnuplot-timeseries /tmp/test.data -p
    set terminal svg size 400,200 enhanced font 'Monaco,8'
    set key below
    set border linewidth 0.8 
    set style line 11 lc rgb '#000000' lt 1
    set border 3 back ls 11
    set tics nomirror out scale 0.75
    set xdata time
    […]
    » gnuplot-timeseries /tmp/test.data -p > /tmp/test.plot
    » gnuplot /tmp/test.plot > /tmp/test.svg

[01]: ../bin/gunplot-timeseries
