NB. --------------------------------
NB. -- Data analysis - useful functions --
NB. --------------------------------

NB. How to load the script - an example
NB. ]scriptdir=: 'PATH-TO-REPO/j-data-analysis/j/'
NB. 0!:1 < scriptdir,'analysis.ijs'

NB. Let's define dataframe's views:
NB. (a) grid view, ie., every field is boxed
NB. ┌──────────┬─────┬──────┐
NB. │date      │quote│symbol│
NB. ├──────────┼─────┼──────┤
NB. │2000-01-03│6.58 │DGS10 │
NB. ├──────────┼─────┼──────┤
NB. │2000-01-04│6.49 │DGS10 │
NB. ├──────────┼─────┼──────┤
NB. │2000-01-05│6.62 │DGS10 │
NB. ├──────────┼─────┼──────┤
NB. │2000-01-06│6.57 │DGS10 │
NB. ├──────────┼─────┼──────┤
NB. │2000-01-07│6.52 │DGS10 │
NB. ├──────────┼─────┼──────┤
NB. │2000-01-10│6.57 │DGS10 │
NB. └──────────┴─────┴──────┘
NB. (a) table view, also known as an inverted table
NB. ┌──────────┬─────┬──────┐
NB. │date      │quote│symbol│
NB. ├──────────┼─────┼──────┤
NB. │2000-01-03│6.58 │DGS10 │
NB. │2000-01-04│6.49 │DGS10 │
NB. │2000-01-05│6.62 │DGS10 │
NB. │2000-01-06│6.57 │DGS10 │
NB. │2000-01-07│6.52 │DGS10 │
NB. │2000-01-10│6.57 │DGS10 │
NB. └──────────┴─────┴──────┘

load 'tables/dsv'
NB. read from CSV file to grid view, y is file path
toGridFromCSV=: 3 : 0
',' readdsv y
)

NB. read from CSV file to table view, y is file path
toTableFromCSV=: 3 : 0
({.,:,each/@:(,:each)@}.) toGridFromCSV y
)

NB. transform from table view to grid view
toGridFromTable=: 3 : 0
({.y), |: <@dtb"1&> {:y
)

NB. transform from grid view to table view
toTableFromGrid=: 3 : 0
({.,:,each/@:(,:each)@}.) y
)

NB. gnuplot the grid with gnuplot commands
NB. y is expected to be structured as follows:
NB. cmds=:'cmd1';'cmd2'
NB. data=:toGridFromCSV 'file'
NB. y=:(<cmds),<data
fromGridToGnuplot =: 3 : 0
strs=. >0 { y
csv=. >1 { y
writeline=. {{ 2!:0 'echo ''', y, ''' >> temp.gp' }}
2!:0 'echo ''$d << EOD'' > temp.gp'
csv appenddsv 'temp.gp';',';''
writeline 'EOD'
writeline S:0 strs
2!:0 'gnuplot -p -c temp.gp'
)

NB. gnuplot the table with gnuplot commands
NB. y is expected to be structured as follows:
NB. cmds=:'cmd1';'cmd2'
NB. data=:toTableFromCSV 'file'
NB. y=:(<cmds),<data
fromTableToGnuplot =: 3 : 0
strs=. 0{y
t=. toGridFromTable >1{y
fromGridToGnuplot strs;<t
)

NB. Select rows from inverted table, header is maintained.
NB. x is vector, y is table
rowsFromTable=: 4 : 0
(({.),((<x) {&.> }.)) y
)
NB.    (0,1,2) rowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-05-30│-0.0860│1Y   │JP     │
NB. │2022-05-31│-0.0840│1Y   │JP     │
NB. │2022-06-01│-0.0840│1Y   │JP     │
NB. └──────────┴───────┴─────┴───────┘
NB.    (_1,2) rowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-17│3.2313 │10Y  │US     │
NB. │2022-06-01│-0.0840│1Y   │JP     │
NB. └──────────┴───────┴─────┴───────┘

NB. Select random rows from inverted table, header is maintained.
NB. x is number of random rows, y is table
randomRowsFromTable=: 4 : 0
nrows=.>{.{.#&.>}.y
assert. (x <: nrows)
(x?nrows) rowsFromTable y
)
NB.    3 randomRowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-15│0.2520 │10Y  │JP     │
NB. │2022-06-02│2.9131 │10Y  │US     │
NB. │2022-06-09│0.2490 │10Y  │JP     │
NB. └──────────┴───────┴─────┴───────┘
NB.    90 randomRowsFromTable bonds
NB. |assertion failure: randomRowsFromTable
NB. |       (x<:nrows)
