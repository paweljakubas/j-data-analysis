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
tmp_r=: x
tgrade=: /: @ |: @: {{ tmp_r }}
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
'tmp_c1 tmp_c2'=: x
size=.${.y
assert. ( (tmp_c1 >: (- size)) *. (tmp_c1 < size) *. (tmp_c2 >: (- size)) *. (tmp_c2 < size))
h=. {{ ((tmp_c1{y),(tmp_c2{y)) (tmp_c2,tmp_c1) } y }} {.y
r=. {{ (((<(<a:),(<tmp_c1)) { y),:(<(<a:),(<tmp_c2)) { y) ((<(<a:),(<tmp_c2)),(<(<a:),(<tmp_c1))) } y}} }.y
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

NB. Number of rows in inverted table
nrows=: {{ >{.{.#&.>}.y }}
NB. Example
NB.    nrows bonds
NB. 89

NB. Update the values of a selected column
NB. x is (colIx,newcol) and y is an inverted table
updateColumnVals =: 4 : 0
'tmp_ix tmp_col'=:x
d=.{.$tmp_col
assert. (d = (nrows y))
size=.${.y
assert. ( (tmp_ix >: (- size)) *. (tmp_ix < size) )
cols=. {{ (<tmp_col) (<(<a:),(<tmp_ix)) } y }} }.y
({.y),cols
)
NB. Example.
NB.    newcol=:<30 1 $ ".>(<(<0),(<1)){ }. week
NB.    (1;newcol) updateColumnVals week
NB. ┌──────────┬──────┬─────┬───────┐
NB. │date      │quote │tenor│country│
NB. ├──────────┼──────┼─────┼───────┤
NB. │2022-06-06│ _0.08│1Y   │JP     │
NB. │2022-06-07│_0.083│1Y   │JP     │
NB. │2022-06-08│_0.085│1Y   │JP     │
NB. │2022-06-09│_0.083│1Y   │JP     │
NB. │2022-06-10│ _0.09│1Y   │JP     │
NB. │2022-06-06│_0.004│5Y   │JP     │
NB. │2022-06-07│     0│5Y   │JP     │
NB. │2022-06-08│ _0.01│5Y   │JP     │
NB. │2022-06-09│ _0.01│5Y   │JP     │
NB. │2022-06-10│_0.004│5Y   │JP     │
NB. │2022-06-06│  0.24│10Y  │JP     │
NB. │2022-06-07│ 0.245│10Y  │JP     │
NB. │2022-06-08│ 0.245│10Y  │JP     │
NB. │2022-06-09│ 0.249│10Y  │JP     │
NB. │2022-06-10│  0.25│10Y  │JP     │
NB. │2022-06-06│ 2.196│1Y   │US     │
NB. │2022-06-07│ 2.206│1Y   │US     │
NB. │2022-06-08│ 2.245│1Y   │US     │
NB. │2022-06-09│   2.3│1Y   │US     │
NB. │2022-06-10│ 2.507│1Y   │US     │
NB. │2022-06-06│3.0368│5Y   │US     │
NB. │2022-06-07│2.9906│5Y   │US     │
NB. │2022-06-08│3.0355│5Y   │US     │
NB. │2022-06-09│3.0702│5Y   │US     │
NB. │2022-06-10│3.2637│5Y   │US     │
NB. │2022-06-06│3.0399│10Y  │US     │
NB. │2022-06-07│2.9791│10Y  │US     │
NB. │2022-06-08│ 3.027│10Y  │US     │
NB. │2022-06-09│3.0455│10Y  │US     │
NB. │2022-06-10│3.1649│10Y  │US     │
NB. └──────────┴──────┴─────┴───────┘

NB. Update the name of a selected column
NB. x is (colIx,newcolname) and y is an inverted table
updateColumnName =: 4 : 0
'tmp_ix tmp_col'=:x
size=.${.y
assert. ( (tmp_ix >: (- size)) *. (tmp_ix < size) )
h=. {{ (<tmp_col) tmp_ix } y }} {.y
h,}.y
)
NB. Example:
NB.    newcol=:<30 1 $ ".>(<(<0),(<1)){ }. week
NB.    week2=: (1;newcol) updateColumnVals week
NB.    ]week3=: (1;'quote as number') updateColumnName week2
NB. ┌──────────┬───────────────┬─────┬───────┐
NB. │date      │quote as number│tenor│country│
NB. ├──────────┼───────────────┼─────┼───────┤
NB. │2022-06-06│ _0.08         │1Y   │JP     │
NB. │2022-06-07│_0.083         │1Y   │JP     │
NB. │2022-06-08│_0.085         │1Y   │JP     │
NB. │2022-06-09│_0.083         │1Y   │JP     │
NB. │2022-06-10│ _0.09         │1Y   │JP     │
NB. │2022-06-06│_0.004         │5Y   │JP     │
NB. │2022-06-07│     0         │5Y   │JP     │
NB. │2022-06-08│ _0.01         │5Y   │JP     │
NB. │2022-06-09│ _0.01         │5Y   │JP     │
NB. │2022-06-10│_0.004         │5Y   │JP     │
NB. │2022-06-06│  0.24         │10Y  │JP     │
NB. │2022-06-07│ 0.245         │10Y  │JP     │
NB. │2022-06-08│ 0.245         │10Y  │JP     │
NB. │2022-06-09│ 0.249         │10Y  │JP     │
NB. │2022-06-10│  0.25         │10Y  │JP     │
NB. │2022-06-06│ 2.196         │1Y   │US     │
NB. │2022-06-07│ 2.206         │1Y   │US     │
NB. │2022-06-08│ 2.245         │1Y   │US     │
NB. │2022-06-09│   2.3         │1Y   │US     │
NB. │2022-06-10│ 2.507         │1Y   │US     │
NB. │2022-06-06│3.0368         │5Y   │US     │
NB. │2022-06-07│2.9906         │5Y   │US     │
NB. │2022-06-08│3.0355         │5Y   │US     │
NB. │2022-06-09│3.0702         │5Y   │US     │
NB. │2022-06-10│3.2637         │5Y   │US     │
NB. │2022-06-06│3.0399         │10Y  │US     │
NB. │2022-06-07│2.9791         │10Y  │US     │
NB. │2022-06-08│ 3.027         │10Y  │US     │
NB. │2022-06-09│3.0455         │10Y  │US     │
NB. │2022-06-10│3.1649         │10Y  │US     │
NB. └──────────┴───────────────┴─────┴───────┘

NB. Add column to an inverted table
NB. x is (columnName, columnValues), y is an inverted table
addColumn=: 4 : 0
'colname colvals'=.x
d=.{.$colvals
assert. (d = (nrows y))
h=.({.y),<colname
v=.(}.y),.<colvals
h,v
)
NB. Example:
NB.    ]newcol=:<30 1 $ i.30
NB. ┌──┐
NB. │ 0│
NB. │ 1│
NB. │ 2│
NB. │ 3│
NB. │ 4│
NB. │ 5│
NB. │ 6│
NB. │ 7│
NB. │ 8│
NB. │ 9│
NB. │10│
NB. │11│
NB. │12│
NB. │13│
NB. │14│
NB. │15│
NB. │16│
NB. │17│
NB. │18│
NB. │19│
NB. │20│
NB. │21│
NB. │22│
NB. │23│
NB. │24│
NB. │25│
NB. │26│
NB. │27│
NB. │28│
NB. │29│
NB. └──┘
NB.    ('number';newcol) addColumn week
NB. ┌──────────┬───────┬─────┬───────┬──────┐
NB. │date      │quote  │tenor│country│number│
NB. ├──────────┼───────┼─────┼───────┼──────┤
NB. │2022-06-06│-0.0800│1Y   │JP     │ 0    │
NB. │2022-06-07│-0.0830│1Y   │JP     │ 1    │
NB. │2022-06-08│-0.0850│1Y   │JP     │ 2    │
NB. │2022-06-09│-0.0830│1Y   │JP     │ 3    │
NB. │2022-06-10│-0.0900│1Y   │JP     │ 4    │
NB. │2022-06-06│-0.0040│5Y   │JP     │ 5    │
NB. │2022-06-07│0.0000 │5Y   │JP     │ 6    │
NB. │2022-06-08│-0.0100│5Y   │JP     │ 7    │
NB. │2022-06-09│-0.0100│5Y   │JP     │ 8    │
NB. │2022-06-10│-0.0040│5Y   │JP     │ 9    │
NB. │2022-06-06│0.2400 │10Y  │JP     │10    │
NB. │2022-06-07│0.2450 │10Y  │JP     │11    │
NB. │2022-06-08│0.2450 │10Y  │JP     │12    │
NB. │2022-06-09│0.2490 │10Y  │JP     │13    │
NB. │2022-06-10│0.2500 │10Y  │JP     │14    │
NB. │2022-06-06│2.1960 │1Y   │US     │15    │
NB. │2022-06-07│2.2060 │1Y   │US     │16    │
NB. │2022-06-08│2.2450 │1Y   │US     │17    │
NB. │2022-06-09│2.3000 │1Y   │US     │18    │
NB. │2022-06-10│2.5070 │1Y   │US     │19    │
NB. │2022-06-06│3.0368 │5Y   │US     │20    │
NB. │2022-06-07│2.9906 │5Y   │US     │21    │
NB. │2022-06-08│3.0355 │5Y   │US     │22    │
NB. │2022-06-09│3.0702 │5Y   │US     │23    │
NB. │2022-06-10│3.2637 │5Y   │US     │24    │
NB. │2022-06-06│3.0399 │10Y  │US     │25    │
NB. │2022-06-07│2.9791 │10Y  │US     │26    │
NB. │2022-06-08│3.0270 │10Y  │US     │27    │
NB. │2022-06-09│3.0455 │10Y  │US     │28    │
NB. │2022-06-10│3.1649 │10Y  │US     │29    │
NB. └──────────┴───────┴─────┴───────┴──────┘

NB. String concat, x is string connector, y boxed strings
strconcat=: #@[ }. <@[ ;@,. ]
NB. Example
NB.    '-' strconcat ;: 'one two three'
NB. one-two-three
NB.    '-' strconcat ":each(1;2;3)
NB. 1-2-3

NB. String split, x is string connector against which the split occur, y string
strsplit=: #@[ }.each [ (E. <;.1 ]) ,
NB. Example
NB.    '-' strsplit '2014-20'
NB. ┌────┬──┐
NB. │2014│20│
NB. └────┴──┘

NB. Despace string, remove leading and trailing spaces
strdespace=: [:(#~(+.(1:|.(></\)))@(' '&~:))"1 (#~([:(+./\*. +./\.)' '&~:))"1
NB. Example
NB.    $strdespace 'aa aa'
NB. 5
NB.    $strdespace 'aa aa    '
NB. 5
NB.    $strdespace '    aa aa    '
NB. 5

load 'types/datetime'

NB. Day of week of a given datetime value given as y
dayOfWeek=: 3 : 0
days=. 'Mon','Tue','Wed','Thu','Fri','Sat',:'Sun'
ref=. toDayNo (,".>'-' strsplit '2022-09-05'),0,0,0
d=. <.!.0 toDayNo y
if. (ref > d) do.
(- 7 | ref - d) { days
else.
(7 | d - ref) { days
end.
)
NB. Example
NB.    d=: toDateTime toDayNo (,".>'-' strsplit '2022-09-05'),0,0,0
NB.    d
NB. 2022 9 5 0 0 0
NB.    dayOfWeek d
NB. Mon
NB.    ]d=: 6!:0 ''
NB. 2022 9 8 19 19 15.7767
NB.    dayOfWeek d
NB. Thu

NB. First day of the first week of a given year y
firstDayOfFirstWeekOfYear=: 3 : 0
begYearDayNo=.toDayNo y,1,1,0,0,0
begYearDay=.dayOfWeek toDateTime begYearDayNo
if. begYearDay = 'Mon' do.
  begYearDayNo
elseif. begYearDay = 'Tue' do.
  <:begYearDayNo
elseif. begYearDay = 'Wed' do.
  <:<:begYearDayNo
elseif. begYearDay = 'Thu' do.
  <:<:<:begYearDayNo
elseif. begYearDay = 'Fri' do.
  >:>:>:begYearDayNo
elseif. begYearDay = 'Sat' do.
  >:>:begYearDayNo
else.
  >:begYearDayNo
end.
)
NB. Example
NB.    firstDayOfFirstWeekOfYear 2010
NB. 76704
NB.    firstDayOfFirstWeekOfYear 2009
NB. 76335

NB. Week number of a given datetime y
NB. ISO 8601 defines a standard for the representation of dates, times and time zones.
NB. It defines weeks that start on a Monday. It also says Week 1 of a year is the one
NB. which contains at least 4 days from the given year. Consequently, the 29th, 30th and
NB. 31st of December 20xx could be in week 1 of 20xy (where xy = xx + 1), and the 1st,
NB. 2nd and 3rd of January 20xy could all be in the last week of 20xx. Further, there can be a week 53.
weekNo=: 3 : 0
year=. 0{y
begYear=. year,1,1,0,0,0
begYearDayNo=.toDayNo begYear
begYearDay=.dayOfWeek begYear
dayNo=. <.!.0 toDayNo y
if. begYearDay = 'Mon' do.
  >: (dayNo - begYearDayNo) <.@% 7
elseif. begYearDay = 'Tue' do.
  >: (dayNo - <:begYearDayNo) <.@% 7
elseif. begYearDay = 'Wed' do.
  >: (dayNo - <:<:begYearDayNo) <.@% 7
elseif. begYearDay = 'Thu' do.
  >: (dayNo - <:<:<:begYearDayNo) <.@% 7
elseif. begYearDay = 'Fri' do.
  if. (dayNo < >:>:>:begYearDayNo) do.
    >: (dayNo - (firstDayOfFirstWeekOfYear <:year)) <.@% 7
  else.
    >: (dayNo - >:>:>:begYearDayNo) <.@% 7
  end.
elseif. begYearDay = 'Sat' do.
  if. (dayNo < >:>:begYearDayNo) do.
    >: (dayNo - (firstDayOfFirstWeekOfYear <:year)) <.@% 7
  else.
    >: (dayNo - >:>:begYearDayNo) <.@% 7
  end.
else.
  if. (dayNo < >:begYearDayNo) do.
    >: (dayNo - (firstDayOfFirstWeekOfYear <:year)) <.@% 7
  else.
    >: (dayNo - >:begYearDayNo) <.@% 7
  end.
end.
)
NB. Example
NB.    ]d=: 6!:0 ''
NB. 2022 9 8 20 18 48.9199
NB.    dayOfWeek d
NB. Thu
NB.    weekNo d
NB. 36
NB.    ]d=: toDateTime toDayNo (,".>'-' strsplit '2010-01-01'),0,0,0
NB. 2010 1 1 0 0 0
NB.    dayOfWeek d
NB. Fri
NB.    weekNo d
NB. 53
NB.    ]d=: toDateTime toDayNo (,".>'-' strsplit '2011-01-01'),0,0,0
NB. 2011 1 1 0 0 0
NB.    dayOfWeek d
NB. Sat
NB.    weekNo d
NB. 52
NB.    ]d=: toDateTime toDayNo (,".>'-' strsplit '2012-01-01'),0,0,0
NB. 2012 1 1 0 0 0
NB.    dayOfWeek d
NB. Sun
NB.    weekNo d
NB. 52
NB.    ]d=: toDateTime toDayNo (,".>'-' strsplit '2013-01-01'),0,0,0
NB. 2013 1 1 0 0 0
NB.    dayOfWeek d
NB. Tue
NB.    weekNo d
NB. 1

NB. Remove column from inverted table
NB. x is index, y is table
removeColumn=: 4 : 0
size=.${.y
assert. ( (x >: (- size)) *. (x < size) )
h=. (<(<<x)){{. y
c=. (<(<a:),(<<x)){}. y
h,c
)
NB. Example
NB.    bonds3
NB. ┌──────────┬───────┬─────┬───────┬──────┐
NB. │date      │quote  │tenor│country│weekno│
NB. ├──────────┼───────┼─────┼───────┼──────┤
NB. │2022-05-30│2.8097 │10Y  │US     │22    │
NB. │2022-05-31│2.8495 │10Y  │US     │22    │
NB. │2022-06-01│2.9113 │10Y  │US     │22    │
NB. │2022-06-02│2.9131 │10Y  │US     │22    │
NB. │2022-06-03│2.9405 │10Y  │US     │22    │
NB. │2022-06-06│3.0399 │10Y  │US     │23    │
NB. │2022-06-07│2.9791 │10Y  │US     │23    │
NB. │2022-06-08│3.0270 │10Y  │US     │23    │
NB. │2022-06-09│3.0455 │10Y  │US     │23    │
NB. │2022-06-10│3.1649 │10Y  │US     │23    │
NB. │2022-06-13│3.3617 │10Y  │US     │24    │
NB. │2022-06-14│3.4791 │10Y  │US     │24    │
NB. │2022-06-15│3.2915 │10Y  │US     │24    │
NB. │2022-06-16│3.1952 │10Y  │US     │24    │
NB. │2022-06-17│3.2313 │10Y  │US     │24    │
NB. └──────────┴───────┴─────┴───────┴──────┘
NB.
NB.    2 removeColumn bonds3
NB. ┌──────────┬───────┬───────┬──────┐
NB. │date      │quote  │country│weekno│
NB. ├──────────┼───────┼───────┼──────┤
NB. │2022-05-30│2.8097 │US     │22    │
NB. │2022-05-31│2.8495 │US     │22    │
NB. │2022-06-01│2.9113 │US     │22    │
NB. │2022-06-02│2.9131 │US     │22    │
NB. │2022-06-03│2.9405 │US     │22    │
NB. │2022-06-06│3.0399 │US     │23    │
NB. │2022-06-07│2.9791 │US     │23    │
NB. │2022-06-08│3.0270 │US     │23    │
NB. │2022-06-09│3.0455 │US     │23    │
NB. │2022-06-10│3.1649 │US     │23    │
NB. │2022-06-13│3.3617 │US     │24    │
NB. │2022-06-14│3.4791 │US     │24    │
NB. │2022-06-15│3.2915 │US     │24    │
NB. │2022-06-16│3.1952 │US     │24    │
NB. │2022-06-17│3.2313 │US     │24    │
NB. └──────────┴───────┴───────┴──────┘
NB.    2 removeColumn 2 removeColumn bonds3
NB. ┌──────────┬───────┬──────┐
NB. │date      │quote  │weekno│
NB. ├──────────┼───────┼──────┤
NB. │2022-05-30│2.8097 │22    │
NB. │2022-05-31│2.8495 │22    │
NB. │2022-06-01│2.9113 │22    │
NB. │2022-06-02│2.9131 │22    │
NB. │2022-06-03│2.9405 │22    │
NB. │2022-06-06│3.0399 │23    │
NB. │2022-06-07│2.9791 │23    │
NB. │2022-06-08│3.0270 │23    │
NB. │2022-06-09│3.0455 │23    │
NB. │2022-06-10│3.1649 │23    │
NB. │2022-06-13│3.3617 │24    │
NB. │2022-06-14│3.4791 │24    │
NB. │2022-06-15│3.2915 │24    │
NB. │2022-06-16│3.1952 │24    │
NB. │2022-06-17│3.2313 │24    │
NB. └──────────┴───────┴──────┘


NB. Take rows by specifying in x the index of column and values (could be numeric or literal)
NB. from inverted table y
takeSlice=: 4 : 0
'tmp_ix tmp_vals'=:x
size=.${.y
assert. ( (tmp_ix >: (- size)) *. (tmp_ix < size) )
t=. datatype >{.tmp_vals
if. ((<t) e. 'integer';'floating';'rational';'boolean') do.
  ixs=. {{ tmp_vals e.~ y }} >.each>(<(<0),(<tmp_ix)){ }.y
else.
  ixs=. {{ tmp_vals e.~ y }} ;:>(<(<0),(<tmp_ix)){ }.y
end.
ixss=. (,ixs) # i.nrows y
ixss rowsFromTable y
)
NB. Example
NB.    bonds4
NB. ┌──────────┬───────┬─────┬───────┬──────┬───────┐
NB. │date      │quote  │tenor│country│weekno│weekday│
NB. ├──────────┼───────┼─────┼───────┼──────┼───────┤
NB. │2022-05-30│2.8097 │10Y  │US     │22    │Mon    │
NB. │2022-05-31│2.8495 │10Y  │US     │22    │Tue    │
NB. │2022-06-01│2.9113 │10Y  │US     │22    │Wed    │
NB. │2022-06-02│2.9131 │10Y  │US     │22    │Thu    │
NB. │2022-06-03│2.9405 │10Y  │US     │22    │Fri    │
NB. │2022-06-06│3.0399 │10Y  │US     │23    │Mon    │
NB. │2022-06-07│2.9791 │10Y  │US     │23    │Tue    │
NB. │2022-06-08│3.0270 │10Y  │US     │23    │Wed    │
NB. │2022-06-09│3.0455 │10Y  │US     │23    │Thu    │
NB. │2022-06-10│3.1649 │10Y  │US     │23    │Fri    │
NB. │2022-06-13│3.3617 │10Y  │US     │24    │Mon    │
NB. │2022-06-14│3.4791 │10Y  │US     │24    │Tue    │
NB. │2022-06-15│3.2915 │10Y  │US     │24    │Wed    │
NB. │2022-06-16│3.1952 │10Y  │US     │24    │Thu    │
NB. │2022-06-17│3.2313 │10Y  │US     │24    │Fri    │
NB. └──────────┴───────┴─────┴───────┴──────┴───────┘
NB.    (5;<('Mon';'Fri'))
NB. ┌─┬─────────┐
NB. │5│┌───┬───┐│
NB. │ ││Mon│Fri││
NB. │ │└───┴───┘│
NB. └─┴─────────┘
NB.    (5;<('Mon';'Fri')) takeSlice bonds4
NB. ┌──────────┬───────┬─────┬───────┬──────┬───────┐
NB. │date      │quote  │tenor│country│weekno│weekday│
NB. ├──────────┼───────┼─────┼───────┼──────┼───────┤
NB. │2022-05-30│2.8097 │10Y  │US     │22    │Mon    │
NB. │2022-06-03│2.9405 │10Y  │US     │22    │Fri    │
NB. │2022-06-06│3.0399 │10Y  │US     │23    │Mon    │
NB. │2022-06-10│3.1649 │10Y  │US     │23    │Fri    │
NB. │2022-06-13│3.3617 │10Y  │US     │24    │Mon    │
NB. │2022-06-17│3.2313 │10Y  │US     │24    │Fri    │
NB. └──────────┴───────┴─────┴───────┴──────┴───────┘
NB.    (4;<(22;23))
NB. ┌─┬───────┐
NB. │4│┌──┬──┐│
NB. │ ││22│23││
NB. │ │└──┴──┘│
NB. └─┴───────┘
NB.    (4;<(22;23)) takeSlice bonds4
NB. ┌──────────┬───────┬─────┬───────┬──────┬───────┐
NB. │date      │quote  │tenor│country│weekno│weekday│
NB. ├──────────┼───────┼─────┼───────┼──────┼───────┤
NB. │2022-05-30│2.8097 │10Y  │US     │22    │Mon    │
NB. │2022-05-31│2.8495 │10Y  │US     │22    │Tue    │
NB. │2022-06-01│2.9113 │10Y  │US     │22    │Wed    │
NB. │2022-06-02│2.9131 │10Y  │US     │22    │Thu    │
NB. │2022-06-03│2.9405 │10Y  │US     │22    │Fri    │
NB. │2022-06-06│3.0399 │10Y  │US     │23    │Mon    │
NB. │2022-06-07│2.9791 │10Y  │US     │23    │Tue    │
NB. │2022-06-08│3.0270 │10Y  │US     │23    │Wed    │
NB. │2022-06-09│3.0455 │10Y  │US     │23    │Thu    │
NB. │2022-06-10│3.1649 │10Y  │US     │23    │Fri    │
NB. └──────────┴───────┴─────┴───────┴──────┴───────┘


NB. Determine occurence of a given condition in an inverted table
NB. x is expected to have the following structure
NB. ix is index in an inverted table to look, v1,v2,.. values
NB. could be numeric or literal, op is operation delivered as gerund
NB. For literal:
NB. ┌────────────┬──┐
NB. │┌──┬───────┐│op│
NB. ││ix│┌──┬──┐││  │
NB. ││  ││v1│v2│││  │
NB. ││  │└──┴──┘││  │
NB. │└──┴───────┘│  │
NB. └────────────┴──┘
NB. For numeric
NB. ┌──────────┬──┐
NB. │┌──┬─────┐│op│
NB. ││ix│v1 v2││  │
NB. │└──┴─────┘│  │
NB. └──────────┴──┘
condIxs=: 4 : 0
t=. datatype >{.(>1{>0{x)
size=.${.y
ix=.>0{>0{x
assert. ( (ix >: (- size)) *. (ix < size) )
if. ((<t) e. 'integer';'floating';'rational';'boolean') do.
  x {{ (>1{>0{x) ((1{x)`:6) ,>(<(<0),(0{>0{x)){ }. y }} y
else.
  x {{ (>1{>0{x) ((1{x)`:6) ,;: >(<(<0),(0{>0{x)){ }. y }} y
end.
)
NB. Example:
NB.    ((3;<(<'JP'));(e.~`''))
NB. ┌────────┬────────┐
NB. │┌─┬────┐│┌─┬────┐│
NB. ││3│┌──┐│││~│┌──┐││
NB. ││ ││JP││││ ││e.│││
NB. ││ │└──┘│││ │└──┘││
NB. │└─┴────┘│└─┴────┘│
NB. └────────┴────────┘
NB.    ((3;<(<'JP'));(e.~`'')) condIxs bonds2
NB. 1 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0
NB.    ((3;<('JP';'US'));(e.~`''))
NB. ┌───────────┬────────┐
NB. │┌─┬───────┐│┌─┬────┐│
NB. ││3│┌──┬──┐│││~│┌──┐││
NB. ││ ││JP│US││││ ││e.│││
NB. ││ │└──┴──┘│││ │└──┘││
NB. │└─┴───────┘│└─┴────┘│
NB. └───────────┴────────┘
NB.    ((3;<('JP';'US'));(e.~`'')) condIxs bonds2
NB. 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
NB.    ((3;<('JP';'US'));({{y e. x}}`''))
NB. ┌───────────┬──────────────────────┐
NB. │┌─┬───────┐│┌─┬──────────────────┐│
NB. ││3│┌──┬──┐│││:│┌─────┬──────────┐││
NB. ││ ││JP│US││││ ││┌─┬─┐│┌─┬──────┐│││
NB. ││ │└──┴──┘│││ │││0│4│││0│y e. x││││
NB. │└─┴───────┘││ ││└─┴─┘│└─┴──────┘│││
NB. │           ││ │└─────┴──────────┘││
NB. │           │└─┴──────────────────┘│
NB. └───────────┴──────────────────────┘
NB.    ((3;<('JP';'US'));({{y e. x}}`'')) condIxs bonds2
NB. 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
NB.    ((4;<22);({{y e. x}}`''))
NB. ┌──────┬──────────────────────┐
NB. │┌─┬──┐│┌─┬──────────────────┐│
NB. ││4│22│││:│┌─────┬──────────┐││
NB. │└─┴──┘││ ││┌─┬─┐│┌─┬──────┐│││
NB. │      ││ │││0│4│││0│y e. x││││
NB. │      ││ ││└─┴─┘│└─┴──────┘│││
NB. │      ││ │└─────┴──────────┘││
NB. │      │└─┴──────────────────┘│
NB. └──────┴──────────────────────┘
NB.    ((4;<22);({{y e. x}}`'')) condIxs bonds2
NB. 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
NB.    ((4;23,22);({{ y e. x }}`''))
NB. ┌─────────┬───────────────────────┐
NB. │┌─┬─────┐│┌─┬───────────────────┐│
NB. ││4│23 22│││:│┌─────┬───────────┐││
NB. │└─┴─────┘││ ││┌─┬─┐│┌─┬───────┐│││
NB. │         ││ │││0│4│││0│y e. x ││││
NB. │         ││ ││└─┴─┘│└─┴───────┘│││
NB. │         ││ │└─────┴───────────┘││
NB. │         │└─┴───────────────────┘│
NB. └─────────┴───────────────────────┘
NB.    ((4;23,22);({{ y e. x }}`'')) condIxs bonds2
NB. 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
NB.    ((4;23);({{ y e. x }}`''))
NB. ┌──────┬───────────────────────┐
NB. │┌─┬──┐│┌─┬───────────────────┐│
NB. ││4│23│││:│┌─────┬───────────┐││
NB. │└─┴──┘││ ││┌─┬─┐│┌─┬───────┐│││
NB. │      ││ │││0│4│││0│y e. x ││││
NB. │      ││ ││└─┴─┘│└─┴───────┘│││
NB. │      ││ │└─────┴───────────┘││
NB. │      │└─┴───────────────────┘│
NB. └──────┴───────────────────────┘
NB.    ((4;23);({{ y e. x }}`'')) condIxs bonds2
NB. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
NB.    ((1;3.4);({{ y >: x }}`''))
NB. ┌───────┬───────────────────────┐
NB. │┌─┬───┐│┌─┬───────────────────┐│
NB. ││1│3.4│││:│┌─────┬───────────┐││
NB. │└─┴───┘││ ││┌─┬─┐│┌─┬───────┐│││
NB. │       ││ │││0│4│││0│y >: x ││││
NB. │       ││ ││└─┴─┘│└─┴───────┘│││
NB. │       ││ │└─────┴───────────┘││
NB. │       │└─┴───────────────────┘│
NB. └───────┴───────────────────────┘
NB.    ((1;3.4);({{ y >: x }}`'')) condIxs bonds1
NB. 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0


NB. Checks if an inverted table y is empty, ie. does not have any rows
isTableEmpty=: 3 : 0
cols=. #{. y
tmp_y=: y
(+/ {{ #>(<(<0),(<y)){ }. tmp_y }}"0 i.cols) = 0
)
NB. Example
NB.    ]bonds1=: 10 randomRowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-14│0.2560 │10Y  │JP     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-05-31│0.0040 │5Y   │JP     │
NB. │2022-06-07│2.9906 │5Y   │US     │
NB. │2022-06-01│-0.0040│5Y   │JP     │
NB. │2022-06-17│2.8870 │1Y   │US     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. │2022-06-07│0.2450 │10Y  │JP     │
NB. │2022-06-14│3.0520 │1Y   │US     │
NB. │2022-06-06│3.0399 │10Y  │US     │
NB. └──────────┴───────┴─────┴───────┘
NB.    isTableEmpty bonds1
NB. 0
NB.    isTableEmpty 0 randomRowsFromTable bonds
NB. 1

NB. Update a given column x of inverted table y with the numeric cast of its literal values
columnAsNum=: 4 : 0
size=.${.y
assert. ( (x >: (- size)) *. (x < size) )
newvals=. <,.".>(<(<0),(<x)){ }. y
(x;newvals) updateColumnVals y
)
NB. Example
NB.    ]bonds1=: 10 randomRowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-14│3.0520 │1Y   │US     │
NB. │2022-06-16│0.0380 │5Y   │JP     │
NB. │2022-06-07│2.9791 │10Y  │US     │
NB. │2022-06-06│-0.0800│1Y   │JP     │
NB. │2022-06-03│0.2350 │10Y  │JP     │
NB. │2022-05-30│0.2300 │10Y  │JP     │
NB. │2022-06-09│-0.0830│1Y   │JP     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-06-13│0.0350 │5Y   │JP     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. └──────────┴───────┴─────┴───────┘
NB.    1 columnAsNum bonds1
NB. ┌──────────┬──────┬─────┬───────┐
NB. │date      │quote │tenor│country│
NB. ├──────────┼──────┼─────┼───────┤
NB. │2022-06-14│ 3.052│1Y   │US     │
NB. │2022-06-16│ 0.038│5Y   │JP     │
NB. │2022-06-07│2.9791│10Y  │US     │
NB. │2022-06-06│ _0.08│1Y   │JP     │
NB. │2022-06-03│ 0.235│10Y  │JP     │
NB. │2022-05-30│  0.23│10Y  │JP     │
NB. │2022-06-09│_0.083│1Y   │JP     │
NB. │2022-06-10│ 2.507│1Y   │US     │
NB. │2022-06-13│ 0.035│5Y   │JP     │
NB. │2022-06-09│3.0455│10Y  │US     │
NB. └──────────┴──────┴─────┴───────┘

NB. Show datatypes of columns of an inverted table y
columnTypes=: 3 : 0
assert. (-. isTableEmpty y)
tmp_y=:y
hs=. {. y
ts=. <"1 {{ datatype {.>(<(<0),(<y)){ }. tmp_y }}"0 i.#{.y
hs,:ts
)
NB. Example
NB.    columnTypes bonds1
NB. ┌───────┬───────┬───────┬───────┐
NB. │date   │quote  │tenor  │country│
NB. ├───────┼───────┼───────┼───────┤
NB. │literal│literal│literal│literal│
NB. └───────┴───────┴───────┴───────┘
NB.    columnTypes 0 randomRowsFromTable bonds
NB. |assertion failure: columnTypes
NB. |       (-.isTableEmpty y)
NB.    columnTypes (1 columnAsNum bonds1)
NB. ┌────────┬────────┬────────┬────────┐
NB. │date    │quote   │tenor   │country │
NB. ├────────┼────────┼────────┼────────┤
NB. │literal │floating│literal │literal │
NB. └────────┴────────┴────────┴────────┘


NB. Grouping funtionality
NB. Helping function
f1_groupBy=: 3 : 0
elems=. #> y
if. (elems > 1) do.
  <"0 >y
else.
  y
end.
)
NB.    f1_groupBy 1,2,3
NB. ┌─┬─┬─┐
NB. │1│2│3│
NB. └─┴─┴─┘
NB.    f1_groupBy 1;2;3
NB. ┌─┬─┬─┐
NB. │1│2│3│
NB. └─┴─┴─┘

f2_groupBy=: 3 : 0
if. ( (<'boxed') e. <(datatype >y) ) do.
  >y
else.
   y
end.
)
NB.    vals
NB. ┌───────┐
NB. │┌──┬──┐│
NB. ││1Y│5Y││
NB. │└──┴──┘│
NB. └───────┘
NB.    f2_groupBy vals
NB. ┌──┬──┐
NB. │1Y│5Y│
NB. └──┴──┘
NB.    vals1
NB. ┌──┐
NB. │1Y│
NB. └──┘
NB.    f2_groupBy vals1
NB. ┌──┐
NB. │1Y│
NB. └──┘


NB. Grouping by numeric and literal value(s) specified in x of an inverted table y
NB. If x is single number then grouping will take place for a given column
NB. with all values separate. Otherwise the following structure is expected
NB.    (ix;<(v1;v2);(v3;v4);<<v5)
NB. ┌──┬──────────────────────┐
NB. │ix│┌───────┬───────┬────┐│
NB. │  ││┌──┬──┐│┌──┬──┐│┌──┐││
NB. │  │││v1│v2│││v3│v4│││v5│││
NB. │  ││└──┴──┘│└──┴──┘│└──┘││
NB. │  │└───────┴───────┴────┘│
NB. └──┴──────────────────────┘
groupByNumeric=: 4 : 0
if. 1 = #x do.
  vals=. <each <.each ,{./.~ >(<(<0),(<x)){ }. y
else.
  vals=. ,>}.x
end.
tmp_y=:y
tmp_ix=: >0{x
(<(<a:),(<<0)) { (<0$0) ]F..{{ y ,. (<(tmp_ix;(f2_groupBy <x))) ,: <(tmp_ix;x) takeSlice tmp_y }} vals
)
NB. Example
NB.    ]bonds1=: 10 randomRowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-14│3.0520 │1Y   │US     │
NB. │2022-06-16│0.0380 │5Y   │JP     │
NB. │2022-06-07│2.9791 │10Y  │US     │
NB. │2022-06-06│-0.0800│1Y   │JP     │
NB. │2022-06-03│0.2350 │10Y  │JP     │
NB. │2022-05-30│0.2300 │10Y  │JP     │
NB. │2022-06-09│-0.0830│1Y   │JP     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-06-13│0.0350 │5Y   │JP     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. └──────────┴───────┴─────┴───────┘
NB.    ]weekday=: <{{ dayOfWeek toDateTime toDayNo (,".>'-' strsplit y),0,0,0 }}"1 >(<(<0),(<0)){ }. bonds1
NB. ┌───┐
NB. │Tue│
NB. │Thu│
NB. │Tue│
NB. │Mon│
NB. │Fri│
NB. │Mon│
NB. │Thu│
NB. │Fri│
NB. │Mon│
NB. │Thu│
NB. └───┘
NB.    ]bonds2=: ('weekday';weekday) addColumn bonds1
NB. ┌──────────┬───────┬─────┬───────┬───────┐
NB. │date      │quote  │tenor│country│weekday│
NB. ├──────────┼───────┼─────┼───────┼───────┤
NB. │2022-06-14│3.0520 │1Y   │US     │Tue    │
NB. │2022-06-16│0.0380 │5Y   │JP     │Thu    │
NB. │2022-06-07│2.9791 │10Y  │US     │Tue    │
NB. │2022-06-06│-0.0800│1Y   │JP     │Mon    │
NB. │2022-06-03│0.2350 │10Y  │JP     │Fri    │
NB. │2022-05-30│0.2300 │10Y  │JP     │Mon    │
NB. │2022-06-09│-0.0830│1Y   │JP     │Thu    │
NB. │2022-06-10│2.5070 │1Y   │US     │Fri    │
NB. │2022-06-13│0.0350 │5Y   │JP     │Mon    │
NB. │2022-06-09│3.0455 │10Y  │US     │Thu    │
NB. └──────────┴───────┴─────┴───────┴───────┘
NB.    ]weekno=: <,.{{ weekNo toDateTime toDayNo (,".>'-' strsplit y),0,0,0 }}"1 >(<(<0),(<0)){ }. bonds2
NB. ┌──┐
NB. │24│
NB. │24│
NB. │23│
NB. │23│
NB. │22│
NB. │22│
NB. │23│
NB. │23│
NB. │24│
NB. │23│
NB. └──┘
NB.    ]bonds3=: ('weekno';weekno) addColumn bonds2
NB. ┌──────────┬───────┬─────┬───────┬───────┬──────┐
NB. │date      │quote  │tenor│country│weekday│weekno│
NB. ├──────────┼───────┼─────┼───────┼───────┼──────┤
NB. │2022-06-14│3.0520 │1Y   │US     │Tue    │24    │
NB. │2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │
NB. │2022-06-07│2.9791 │10Y  │US     │Tue    │23    │
NB. │2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │
NB. │2022-06-03│0.2350 │10Y  │JP     │Fri    │22    │
NB. │2022-05-30│0.2300 │10Y  │JP     │Mon    │22    │
NB. │2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │
NB. │2022-06-10│2.5070 │1Y   │US     │Fri    │23    │
NB. │2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │
NB. │2022-06-09│3.0455 │10Y  │US     │Thu    │23    │
NB. └──────────┴───────┴─────┴───────┴───────┴──────┘
NB.    columnTypes bonds3
NB. ┌───────┬───────┬───────┬───────┬───────┬───────┐
NB. │date   │quote  │tenor  │country│weekday│weekno │
NB. ├───────┼───────┼───────┼───────┼───────┼───────┤
NB. │literal│literal│literal│literal│literal│integer│
NB. └───────┴───────┴───────┴───────┴───────┴───────┘
NB.    5 groupByNumeric bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬────┐                                         │┌─┬────┐                                         │┌─┬────┐                                         │
NB. ││5│┌──┐│                                         ││5│┌──┐│                                         ││5│┌──┐│                                         │
NB. ││ ││24││                                         ││ ││23││                                         ││ ││22││                                         │
NB. ││ │└──┘│                                         ││ │└──┘│                                         ││ │└──┘│                                         │
NB. │└─┴────┘                                         │└─┴────┘                                         │└─┴────┘                                         │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    ││
NB. ││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    ││
NB. ││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││                                                 │
NB. │                                                 ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││                                                 │
NB. │                                                 │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘
NB.    ]x2=: (5;<(24;23);(23;22);<<23)
NB. ┌─┬──────────────────────┐
NB. │5│┌───────┬───────┬────┐│
NB. │ ││┌──┬──┐│┌──┬──┐│┌──┐││
NB. │ │││24│23│││23│22│││23│││
NB. │ ││└──┴──┘│└──┴──┘│└──┘││
NB. │ │└───────┴───────┴────┘│
NB. └─┴──────────────────────┘
NB.    x2 groupByNumeric bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬───────┐                                      │┌─┬───────┐                                      │┌─┬────┐                                         │
NB. ││5│┌──┬──┐│                                      ││5│┌──┬──┐│                                      ││5│┌──┐│                                         │
NB. ││ ││24│23││                                      ││ ││23│22││                                      ││ ││23││                                         │
NB. ││ │└──┴──┘│                                      ││ │└──┴──┘│                                      ││ │└──┘│                                         │
NB. │└─┴───────┘                                      │└─┴───────┘                                      │└─┴────┘                                         │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    ││
NB. ││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    ││
NB. ││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││
NB. ││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││
NB. ││2022-06-10│2.5070 │1Y   │US     │Fri    │23    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. ││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││                                                 │
NB. ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │                                                 │
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘

groupByLiteral=: 4 : 0
if. 1 = #x do.
  vals=. <each strdespace each <"1 {./.~ >(<(<0),(<x)){ }. y
else.
  vals=. ,>}.x
end.
tmp_y=:y
tmp_ix=: >0{x
(<(<a:),(<<0)) { (<0$0) ]F..{{ y ,. (<(tmp_ix;(f2_groupBy <x))) ,: <(tmp_ix;x) takeSlice tmp_y }} vals
)
NB. Example
NB.    ]bonds1=: 10 randomRowsFromTable bonds
NB. ┌──────────┬───────┬─────┬───────┐
NB. │date      │quote  │tenor│country│
NB. ├──────────┼───────┼─────┼───────┤
NB. │2022-06-14│3.0520 │1Y   │US     │
NB. │2022-06-16│0.0380 │5Y   │JP     │
NB. │2022-06-07│2.9791 │10Y  │US     │
NB. │2022-06-06│-0.0800│1Y   │JP     │
NB. │2022-06-03│0.2350 │10Y  │JP     │
NB. │2022-05-30│0.2300 │10Y  │JP     │
NB. │2022-06-09│-0.0830│1Y   │JP     │
NB. │2022-06-10│2.5070 │1Y   │US     │
NB. │2022-06-13│0.0350 │5Y   │JP     │
NB. │2022-06-09│3.0455 │10Y  │US     │
NB. └──────────┴───────┴─────┴───────┘
NB.    2 groupByLiteral bonds1
NB. ┌──────────────────────────────────┬──────────────────────────────────┬──────────────────────────────────┐
NB. │┌─┬────┐                          │┌─┬────┐                          │┌─┬─────┐                         │
NB. ││2│┌──┐│                          ││2│┌──┐│                          ││2│┌───┐│                         │
NB. ││ ││1Y││                          ││ ││5Y││                          ││ ││10Y││                         │
NB. ││ │└──┘│                          ││ │└──┘│                          ││ │└───┘│                         │
NB. │└─┴────┘                          │└─┴────┘                          │└─┴─────┘                         │
NB. ├──────────────────────────────────┼──────────────────────────────────┼──────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┐│┌──────────┬───────┬─────┬───────┐│┌──────────┬───────┬─────┬───────┐│
NB. ││date      │quote  │tenor│country│││date      │quote  │tenor│country│││date      │quote  │tenor│country││
NB. │├──────────┼───────┼─────┼───────┤│├──────────┼───────┼─────┼───────┤│├──────────┼───────┼─────┼───────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │││2022-06-16│0.0380 │5Y   │JP     │││2022-06-07│2.9791 │10Y  │US     ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │││2022-06-13│0.0350 │5Y   │JP     │││2022-06-03│0.2350 │10Y  │JP     ││
NB. ││2022-06-09│-0.0830│1Y   │JP     ││└──────────┴───────┴─────┴───────┘││2022-05-30│0.2300 │10Y  │JP     ││
NB. ││2022-06-10│2.5070 │1Y   │US     ││                                  ││2022-06-09│3.0455 │10Y  │US     ││
NB. │└──────────┴───────┴─────┴───────┘│                                  │└──────────┴───────┴─────┴───────┘│
NB. └──────────────────────────────────┴──────────────────────────────────┴──────────────────────────────────┘
NB.    ]x1=: (2;<('1Y';'10Y');('1Y';'5Y');<<'1Y')
NB. ┌─┬───────────────────────┐
NB. │2│┌────────┬───────┬────┐│
NB. │ ││┌──┬───┐│┌──┬──┐│┌──┐││
NB. │ │││1Y│10Y│││1Y│5Y│││1Y│││
NB. │ ││└──┴───┘│└──┴──┘│└──┘││
NB. │ │└────────┴───────┴────┘│
NB. └─┴───────────────────────┘
NB.    x1 groupByLiteral bonds1
NB. ┌──────────────────────────────────┬──────────────────────────────────┬──────────────────────────────────┐
NB. │┌─┬────────┐                      │┌─┬───────┐                       │┌─┬────┐                          │
NB. ││2│┌──┬───┐│                      ││2│┌──┬──┐│                       ││2│┌──┐│                          │
NB. ││ ││1Y│10Y││                      ││ ││1Y│5Y││                       ││ ││1Y││                          │
NB. ││ │└──┴───┘│                      ││ │└──┴──┘│                       ││ │└──┘│                          │
NB. │└─┴────────┘                      │└─┴───────┘                       │└─┴────┘                          │
NB. ├──────────────────────────────────┼──────────────────────────────────┼──────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┐│┌──────────┬───────┬─────┬───────┐│┌──────────┬───────┬─────┬───────┐│
NB. ││date      │quote  │tenor│country│││date      │quote  │tenor│country│││date      │quote  │tenor│country││
NB. │├──────────┼───────┼─────┼───────┤│├──────────┼───────┼─────┼───────┤│├──────────┼───────┼─────┼───────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │││2022-06-14│3.0520 │1Y   │US     │││2022-06-14│3.0520 │1Y   │US     ││
NB. ││2022-06-07│2.9791 │10Y  │US     │││2022-06-16│0.0380 │5Y   │JP     │││2022-06-06│-0.0800│1Y   │JP     ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │││2022-06-06│-0.0800│1Y   │JP     │││2022-06-09│-0.0830│1Y   │JP     ││
NB. ││2022-06-03│0.2350 │10Y  │JP     │││2022-06-09│-0.0830│1Y   │JP     │││2022-06-10│2.5070 │1Y   │US     ││
NB. ││2022-05-30│0.2300 │10Y  │JP     │││2022-06-10│2.5070 │1Y   │US     ││└──────────┴───────┴─────┴───────┘│
NB. ││2022-06-09│-0.0830│1Y   │JP     │││2022-06-13│0.0350 │5Y   │JP     ││                                  │
NB. ││2022-06-10│2.5070 │1Y   │US     ││└──────────┴───────┴─────┴───────┘│                                  │
NB. ││2022-06-09│3.0455 │10Y  │US     ││                                  │                                  │
NB. │└──────────┴───────┴─────┴───────┘│                                  │                                  │
NB. └──────────────────────────────────┴──────────────────────────────────┴──────────────────────────────────┘

groupBy=: 4 : 0
tmp_ix=: >0{x
t=. datatype 0{>(<(<0),(<tmp_ix)){ }. y
if. 1 = #x do.
  if. ((<t) e. 'integer';'floating';'rational';'boolean') do.
    vals=. <each <.each ,{./.~ >(<(<0),(<x)){ }. y
  else.
    vals=. <each strdespace each <"1 {./.~ >(<(<0),(<x)){ }. y
  end.
else.
  vals=. ,>}.x
end.
tmp_y=:y
(<(<a:),(<<0)) { (<0$0) ]F..{{ y ,. (<(tmp_ix;(f2_groupBy <x))) ,: <(tmp_ix;x) takeSlice tmp_y }} vals
)
NB.    2 groupBy bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬────┐                                         │┌─┬────┐                                         │┌─┬─────┐                                        │
NB. ││2│┌──┐│                                         ││2│┌──┐│                                         ││2│┌───┐│                                        │
NB. ││ ││1Y││                                         ││ ││5Y││                                         ││ ││10Y││                                        │
NB. ││ │└──┘│                                         ││ │└──┘│                                         ││ │└───┘│                                        │
NB. │└─┴────┘                                         │└─┴────┘                                         │└─┴─────┘                                        │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    ││
NB. ││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    ││
NB. ││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││                                                 ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘
NB.    x1
NB. ┌─┬───────────────────────┐
NB. │2│┌────────┬───────┬────┐│
NB. │ ││┌──┬───┐│┌──┬──┐│┌──┐││
NB. │ │││1Y│10Y│││1Y│5Y│││1Y│││
NB. │ ││└──┴───┘│└──┴──┘│└──┘││
NB. │ │└────────┴───────┴────┘│
NB. └─┴───────────────────────┘
NB.    x1 groupBy bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬────────┐                                     │┌─┬───────┐                                      │┌─┬────┐                                         │
NB. ││2│┌──┬───┐│                                     ││2│┌──┬──┐│                                      ││2│┌──┐│                                         │
NB. ││ ││1Y│10Y││                                     ││ ││1Y│5Y││                                      ││ ││1Y││                                         │
NB. ││ │└──┴───┘│                                     ││ │└──┴──┘│                                      ││ │└──┘│                                         │
NB. │└─┴────────┘                                     │└─┴───────┘                                      │└─┴────┘                                         │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-14│3.0520 │1Y   │US     │Tue    │24    ││
NB. ││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││
NB. ││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││
NB. ││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. ││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    ││                                                 │
NB. ││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │
NB. ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││                                                 │                                                 │
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │                                                 │
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘
NB.    5 groupBy bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬────┐                                         │┌─┬────┐                                         │┌─┬────┐                                         │
NB. ││5│┌──┐│                                         ││5│┌──┐│                                         ││5│┌──┐│                                         │
NB. ││ ││24││                                         ││ ││23││                                         ││ ││22││                                         │
NB. ││ │└──┘│                                         ││ │└──┘│                                         ││ │└──┘│                                         │
NB. │└─┴────┘                                         │└─┴────┘                                         │└─┴────┘                                         │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    ││
NB. ││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    ││
NB. ││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││                                                 │
NB. │                                                 ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││                                                 │
NB. │                                                 │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘
NB.    x2
NB. ┌─┬──────────────────────┐
NB. │5│┌───────┬───────┬────┐│
NB. │ ││┌──┬──┐│┌──┬──┐│┌──┐││
NB. │ │││24│23│││23│22│││23│││
NB. │ ││└──┴──┘│└──┴──┘│└──┘││
NB. │ │└───────┴───────┴────┘│
NB. └─┴──────────────────────┘
NB.    x2 groupBy bonds3
NB. ┌─────────────────────────────────────────────────┬─────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
NB. │┌─┬───────┐                                      │┌─┬───────┐                                      │┌─┬────┐                                         │
NB. ││5│┌──┬──┐│                                      ││5│┌──┬──┐│                                      ││5│┌──┐│                                         │
NB. ││ ││24│23││                                      ││ ││23│22││                                      ││ ││23││                                         │
NB. ││ │└──┴──┘│                                      ││ │└──┴──┘│                                      ││ │└──┘│                                         │
NB. │└─┴───────┘                                      │└─┴───────┘                                      │└─┴────┘                                         │
NB. ├─────────────────────────────────────────────────┼─────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
NB. │┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│┌──────────┬───────┬─────┬───────┬───────┬──────┐│
NB. ││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno│││date      │quote  │tenor│country│weekday│weekno││
NB. │├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│├──────────┼───────┼─────┼───────┼───────┼──────┤│
NB. ││2022-06-14│3.0520 │1Y   │US     │Tue    │24    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-07│2.9791 │10Y  │US     │Tue    │23    ││
NB. ││2022-06-16│0.0380 │5Y   │JP     │Thu    │24    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    ││
NB. ││2022-06-07│2.9791 │10Y  │US     │Tue    │23    │││2022-06-03│0.2350 │10Y  │JP     │Fri    │22    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    ││
NB. ││2022-06-06│-0.0800│1Y   │JP     │Mon    │23    │││2022-05-30│0.2300 │10Y  │JP     │Mon    │22    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││
NB. ││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-09│-0.0830│1Y   │JP     │Thu    │23    │││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││
NB. ││2022-06-10│2.5070 │1Y   │US     │Fri    │23    │││2022-06-10│2.5070 │1Y   │US     │Fri    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│
NB. ││2022-06-13│0.0350 │5Y   │JP     │Mon    │24    │││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││                                                 │
NB. ││2022-06-09│3.0455 │10Y  │US     │Thu    │23    ││└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │
NB. │└──────────┴───────┴─────┴───────┴───────┴──────┘│                                                 │                                                 │
NB. └─────────────────────────────────────────────────┴─────────────────────────────────────────────────┴─────────────────────────────────────────────────┘
