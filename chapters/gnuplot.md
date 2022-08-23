# Gnuplot from J

Although a number of plotting options are available in J and they are well documented in its wiki
I will pursue calling gnuplot from J. The reason behind this is that I want to have every
option available in gnuplot, and because I work with many languages I prefer to reuse my knowledge of
gnuplot rather than rely on, very often not so sophisticated, many graphical solutions.

Let's say we have the following CSV:
```bash
date,quote,symbol
2000-01-03,6.58,DGS10
2000-01-04,6.49,DGS10
2000-01-05,6.62,DGS10
2000-01-06,6.57,DGS10
2000-01-07,6.52,DGS10
2000-01-10,6.57,DGS10
```
We can use the heredocs feature introduced in gnuplot 5 which allows embedding the data in the same file as
plot driver. Example, below
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
In order to invoke the above script the following command an be used.
```bash
$ gnuplot -p -c toplot.gp
```
One should see the figure ![image](../figures/toplot.png)
