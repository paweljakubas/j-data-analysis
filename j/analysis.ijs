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

NB. Establish ranking for each column ascending
rankingAsc=: i.!.0~ { /:@/:
NB. Example:
NB.   ]week
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-06│-0.0800│1Y   │JP     │
NB. │2022-06-07│-0.0830│1Y   │JP     │
NB. │2022-06-08│-0.0850│1Y   │JP     │
NB. │2022-06-09│-0.0830│1Y   │JP     │
NB. │2022-06-10│-0.0900│1Y   │JP     │
NB. │2022-06-06│-0.0040│5Y   │JP     │
NB. │2022-06-07│0.0000 │5Y   │JP     │
NB. │2022-06-08│-0.0100│5Y   │JP     │
NB. │2022-06-09│-0.0100│5Y   │JP     │
NB. │2022-06-10│-0.0040│5Y   │JP     │
NB. │2022-06-06│0.2400 │10Y  │JP     │
NB. │2022-06-07│0.2450 │10Y  │JP     │
NB. │2022-06-08│0.2450 │10Y  │JP     │
NB. │2022-06-09│0.2490 │10Y  │JP     │
NB. │2022-06-10│0.2500 │10Y  │JP     │
NB. │2022-06-06│2.1960 │1Y   │US     │
NB. │2022-06-07│2.2060 │1Y   │US     │
NB. │2022-06-08│2.2450 │1Y   │US     │
NB. │2022-06-09│2.3000 │1Y   │US     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-06-06│3.0368 │5Y   │US     │
NB. │2022-06-07│2.9906 │5Y   │US     │
NB. │2022-06-08│3.0355 │5Y   │US     │
NB. │2022-06-09│3.0702 │5Y   │US     │
NB. │2022-06-10│3.2637 │5Y   │US     │
NB. │2022-06-06│3.0399 │10Y  │US     │
NB. │2022-06-07│2.9791 │10Y  │US     │
NB. │2022-06-08│3.0270 │10Y  │US     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. │2022-06-10│3.1649 │10Y  │US     │
NB. └──────────┴───────┴─────┴───────┘
NB.    rankingAsc&> }.week
NB.  0  6 12 18 24  0  6 12 18 24  0  6 12 18 24  0  6 12 18 24  0  6 12 18 24  0  6 12 18 24
NB.  4  5  7  5  8  0  9  2  2  0 10 11 11 13 14 15 16 17 18 19 24 21 23 27 29 25 20 22 26 28
NB. 10 10 10 10 10 20 20 20 20 20  0  0  0  0  0 10 10 10 10 10 20 20 20 20 20  0  0  0  0  0
NB.  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15

NB. Establish ranking for each column ascending
rankingDesc=: i.!.0~ { /:@\:
NB. Example:
NB.    rankingDesc&> }.week
NB. 24 18 12  6  0 24 18 12  6  0 24 18 12  6  0 24 18 12  6  0 24 18 12 6 0 24 18 12  6  0
NB. 25 23 22 23 21 28 20 26 26 28 19 17 17 16 15 14 13 12 11 10  5  8  6 2 0  4  9  7  3  1
NB. 10 10 10 10 10  0  0  0  0  0 20 20 20 20 20 10 10 10 10 10  0  0  0 0 0 20 20 20 20 20
NB. 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15  0  0  0  0  0  0  0  0 0 0  0  0  0  0  0

NB. Order rows by columns specified by ranking
NB. x is ranking, y is inverted table with headers
orderFromRanking=: 4 : 0
r=: x
tgrade=: /: @ |: @: {{ r }}
tsort=: <@tgrade {&.> ]
(({.),((,.&.>) @ (tsort @ }.))) y
)
NB. Example:
NB.    ]ranking1=: ((<(<0),(<0)){rankingAsc&> }.week) ,0, ((<(<0),(<2)){rankingAsc&> }.week) ,: 0
NB.  0  6 12 18 24  0  6 12 18 24 0 6 12 18 24  0  6 12 18 24  0  6 12 18 24 0 6 12 18 24
NB.  0  0  0  0  0  0  0  0  0  0 0 0  0  0  0  0  0  0  0  0  0  0  0  0  0 0 0  0  0  0
NB. 10 10 10 10 10 20 20 20 20 20 0 0  0  0  0 10 10 10 10 10 20 20 20 20 20 0 0  0  0  0
NB.  0  0  0  0  0  0  0  0  0  0 0 0  0  0  0  0  0  0  0  0  0  0  0  0  0 0 0  0  0  0
NB.    $ranking1
NB. 4 30
NB.    ranking1 orderFromRanking week
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-06│0.2400 │10Y  │JP     │
NB. │2022-06-06│3.0399 │10Y  │US     │
NB. │2022-06-06│-0.0800│1Y   │JP     │
NB. │2022-06-06│2.1960 │1Y   │US     │
NB. │2022-06-06│-0.0040│5Y   │JP     │
NB. │2022-06-06│3.0368 │5Y   │US     │
NB. │2022-06-07│0.2450 │10Y  │JP     │
NB. │2022-06-07│2.9791 │10Y  │US     │
NB. │2022-06-07│-0.0830│1Y   │JP     │
NB. │2022-06-07│2.2060 │1Y   │US     │
NB. │2022-06-07│0.0000 │5Y   │JP     │
NB. │2022-06-07│2.9906 │5Y   │US     │
NB. │2022-06-08│0.2450 │10Y  │JP     │
NB. │2022-06-08│3.0270 │10Y  │US     │
NB. │2022-06-08│-0.0850│1Y   │JP     │
NB. │2022-06-08│2.2450 │1Y   │US     │
NB. │2022-06-08│-0.0100│5Y   │JP     │
NB. │2022-06-08│3.0355 │5Y   │US     │
NB. │2022-06-09│0.2490 │10Y  │JP     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. │2022-06-09│-0.0830│1Y   │JP     │
NB. │2022-06-09│2.3000 │1Y   │US     │
NB. │2022-06-09│-0.0100│5Y   │JP     │
NB. │2022-06-09│3.0702 │5Y   │US     │
NB. │2022-06-10│0.2500 │10Y  │JP     │
NB. │2022-06-10│3.1649 │10Y  │US     │
NB. │2022-06-10│-0.0900│1Y   │JP     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-06-10│-0.0040│5Y   │JP     │
NB. │2022-06-10│3.2637 │5Y   │US     │
NB. └──────────┴───────┴─────┴───────┘

NB. Exchange columns in inverted table.
NB. x specifies 2-element list of indices of columns to be exchanged, y is table
exchangeColumns=: 4 : 0
'c1 c2'=: x
size=.${.y
assert. ( (c1 >: (- size)) *. (c1 < size) *. (c2 >: (- size)) *. (c2 < size))
h=. {{ ((c1{y),(c2{y)) (c2,c1) } y }} {.y
r=. {{ (((<(<a:),(<c1)) { y),:(<(<a:),(<c2)) { y) ((<(<a:),(<c2)),(<(<a:),(<c1))) } y}} }.y
h,r
)
NB. Example:
NB.    (1,0) exchangeColumns week
NB. ┌───────┬──────────┬─────┬───────┐
NB. │quote  │date      │tenor│country│
NB. ├───────┼──────────┼─────┼───────┤
NB. │-0.0800│2022-06-06│1Y   │JP     │
NB. │-0.0830│2022-06-07│1Y   │JP     │
NB. │-0.0850│2022-06-08│1Y   │JP     │
NB. │-0.0830│2022-06-09│1Y   │JP     │
NB. │-0.0900│2022-06-10│1Y   │JP     │
NB. │-0.0040│2022-06-06│5Y   │JP     │
NB. │0.0000 │2022-06-07│5Y   │JP     │
NB. │-0.0100│2022-06-08│5Y   │JP     │
NB. │-0.0100│2022-06-09│5Y   │JP     │
NB. │-0.0040│2022-06-10│5Y   │JP     │
NB. │0.2400 │2022-06-06│10Y  │JP     │
NB. │0.2450 │2022-06-07│10Y  │JP     │
NB. │0.2450 │2022-06-08│10Y  │JP     │
NB. │0.2490 │2022-06-09│10Y  │JP     │
NB. │0.2500 │2022-06-10│10Y  │JP     │
NB. │2.1960 │2022-06-06│1Y   │US     │
NB. │2.2060 │2022-06-07│1Y   │US     │
NB. │2.2450 │2022-06-08│1Y   │US     │
NB. │2.3000 │2022-06-09│1Y   │US     │
NB. │2.5070 │2022-06-10│1Y   │US     │
NB. │3.0368 │2022-06-06│5Y   │US     │
NB. │2.9906 │2022-06-07│5Y   │US     │
NB. │3.0355 │2022-06-08│5Y   │US     │
NB. │3.0702 │2022-06-09│5Y   │US     │
NB. │3.2637 │2022-06-10│5Y   │US     │
NB. │3.0399 │2022-06-06│10Y  │US     │
NB. │2.9791 │2022-06-07│10Y  │US     │
NB. │3.0270 │2022-06-08│10Y  │US     │
NB. │3.0455 │2022-06-09│10Y  │US     │
NB. │3.1649 │2022-06-10│10Y  │US     │
NB. └───────┴──────────┴─────┴───────┘
NB.    (4,0) exchangeColumns week
NB. |assertion failure: exchangeColumns
NB. |       ((c1>:(-size))*.(c1<size)*.(c2>:(-size))*.(c2<size))
