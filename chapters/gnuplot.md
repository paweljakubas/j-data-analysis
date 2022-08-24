# Gnuplot from J

Although a number of plotting options are available in J and they are well documented in its wiki
I will pursue calling gnuplot from J. The reason behind this is that I want to have every
option available in gnuplot, and because I work with many languages I prefer to reuse my knowledge of
gnuplot rather than rely on, very often not so sophisticated, many graphical solutions.

Let's say we have the following CSV, toplot.csv:
```bash
$ cat toplot.csv
date,quote,symbol
2000-01-03,6.58,DGS10
2000-01-04,6.49,DGS10
2000-01-05,6.62,DGS10
2000-01-06,6.57,DGS10
2000-01-07,6.52,DGS10
2000-01-10,6.57,DGS10
```
We can use the heredocs feature introduced in gnuplot 5 which allows embedding the data in the same file as
plot's setting and driver. Example, below
```bash
$ cat toplot.gp
$d << EOD
date,quote,symbol
2000-01-03,6.58,DGS10
2000-01-04,6.49,DGS10
2000-01-05,6.62,DGS10
2000-01-06,6.57,DGS10
2000-01-07,6.52,DGS10
2000-01-10,6.57,DGS10
EOD
set datafile separator comma
set xdata time
set timefmt "%y-%m-%d"
set format x "%m/%d"
plot $d skip 1 u (timecolumn(1,"%Y-%m-%d")):2 w lp lw 3 title "DGS10"
```
In order to invoke the above script the following command can be used.
As a result, the gnuplot script will be invoked (of course gnuplot is required to be installed)
in a persistent mode in a separate window, one can look at the plot and optionally save it.
```bash
$ gnuplot -p -c toplot.gp
```
One should see the below figure
![image](../figures/toplot.png)

My way of visual interaction from J will be creating gnuplot file, like toplot.gp, and invoke it.
Afterwards, change the settings, data, and invoke again until I get the desired result.
At some point I will optionally save the figure and corresponding *.gp script if it
is worth documenting.
This is what it is needed to accomplish that.
```j
   NB. we have table
   ]t
┌──────────┬─────┬──────┐
│date      │quote│symbol│
├──────────┼─────┼──────┤
│2000-01-03│6.58 │DGS10 │
│2000-01-04│6.49 │DGS10 │
│2000-01-05│6.62 │DGS10 │
│2000-01-06│6.57 │DGS10 │
│2000-01-07│6.52 │DGS10 │
│2000-01-10│6.57 │DGS10 │
└──────────┴─────┴──────┘

   NB. we can transform it to grid form (see j/analysis.ijs)
   ]g=: toGridFromTable t
┌──────────┬─────┬──────┐
│date      │quote│symbol│
├──────────┼─────┼──────┤
│2000-01-03│6.58 │DGS10 │
├──────────┼─────┼──────┤
│2000-01-04│6.49 │DGS10 │
├──────────┼─────┼──────┤
│2000-01-05│6.62 │DGS10 │
├──────────┼─────┼──────┤
│2000-01-06│6.57 │DGS10 │
├──────────┼─────┼──────┤
│2000-01-07│6.52 │DGS10 │
├──────────┼─────┼──────┤
│2000-01-10│6.57 │DGS10 │
└──────────┴─────┴──────┘

   NB. we can invoke any linux command in J
   NB. here creating file temp.gp with one line
   2!:0 'echo ''$d << EOD'' > temp.gp'

   NB. now we can append the grid
   g appenddsv 'temp.gp';',';''
150

   NB. appending lines
   2!:0 'echo ''EOD'' >> temp.gp'

   2!:0 'echo ''set datafile separator comma'' >> temp.gp'

   2!:0 'echo ''set xdata time'' >> temp.gp'

   2!:0 'echo ''set timefmt "%y-%m-%d"'' >> temp.gp'

   2!:0 'echo ''set format x "%m/%d"'' >> temp.gp'

   2!:0 'echo ''plot $d skip 1 u (timecolumn(1,"%Y-%m-%d")):2 w lp lw 3 title "DGS10"'' >> temp.gp'
```

After that we have toplot.gp file recreated
```bash
$ cat temp.gp
$d << EOD
date,quote,symbol
2000-01-03,6.58,DGS10
2000-01-04,6.49,DGS10
2000-01-05,6.62,DGS10
2000-01-06,6.57,DGS10
2000-01-07,6.52,DGS10
2000-01-10,6.57,DGS10
EOD
set datafile separator comma
set xdata time
set timefmt "%y-%m-%d"
set format x "%m/%d"
plot $d skip 1 u (timecolumn(1,"%Y-%m-%d")):2 w lp lw 3 title "DGS10"
```

We can now invoke it
```j
  2!:0 'gnuplot -p -c temp.gp'
  NB. gnuplot is spawn and we see the same figure
```
