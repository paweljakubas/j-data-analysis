# CSV from J

## Contents
1. [Dumping csv files](#dump-csv-files)
2. [Loading CSV file to a table in J](#load-csv-file-to-table-in-j)
3. [Loading CSV file to jd](#load-csv-file-to-jd)


## Dump CSV files

Let's dump tables from chapter [SQL](sql.md) as CSV files using SQL.
```sql
$ sqlite3 test.db
SQLite version 3.39.2 2022-07-21 15:24:47
Enter ".help" for usage hints.
sqlite> .tables
dept      emp       salgrade
sqlite> .headers on
sqlite> .mode csv
sqlite> .output dept.csv
sqlite> select * from dept;
sqlite> .output emp.csv
sqlite> select * from emp;
sqlite> .output salgrade.csv
sqlite> select * from salgrade;
sqlite> .output stdout
```
Indeed, we have the proper CSV files.
```bash
$ cat dept.csv
deptno,dname,location
10,Accounting,"New York"
20,Research,Dallas
30,Sales,Chicago
40,Operations,Boston

$ cat emp.csv
empno,ename,job,mgr,hiredate,sal,comm,deptno
7369,SMITH,CLERK,7902,93/6/13,800,0,20
7499,ALLEN,SALESMAN,7698,98/8/15,1600,300,30
7521,WARD,SALESMAN,7698,96/3/26,1250,500,30
7566,JONES,MANAGER,7839,95/10/31,2975,,20
7698,BLAKE,MANAGER,7839,92/6/11,2850,,30
7782,CLARK,MANAGER,7839,93/5/14,2450,,10
7788,SCOTT,ANALYST,7566,96/3/5,3000,,20
7839,KING,PRESIDENT,,90/6/9,5000,0,10
7844,TURNER,SALESMAN,7698,95/6/4,1500,0,30
7876,ADAMS,CLERK,7788,99/6/4,1100,,20
7900,JAMES,CLERK,7698,00/6/23,950,,30
7934,MILLER,CLERK,7782,00/1/21,1300,,10
7902,FORD,ANALYST,7566,97/12/5,3000,,20
7654,MARTIN,SALESMAN,7698,98/12/5,1250,1400,30

$ cat salgrade.csv
grade,losal,hisal
1,700,1200
2,1201,1400
3,1401,2000
4,2001,3000
5,3001,99999
```

## Load CSV file to table in J

Having CSV files we can ingest them to J as follows.
```j
   load 'tables/dsv'
   readdsv 'dept.csv'
┌──────────────────────┐
│deptno,dname,location │
├──────────────────────┤
│10,Accounting,New York│
├──────────────────────┤
│20,Research,Dallas    │
├──────────────────────┤
│30,Sales,Chicago      │
├──────────────────────┤
│40,Operations,Boston  │
└──────────────────────┘
   ',' readdsv 'dept.csv'
┌──────┬──────────┬──────────┐
│deptno│dname     │location  │
├──────┼──────────┼──────────┤
│10    │Accounting│"New York"│
├──────┼──────────┼──────────┤
│20    │Research  │Dallas    │
├──────┼──────────┼──────────┤
│30    │Sales     │Chicago   │
├──────┼──────────┼──────────┤
│40    │Operations│Boston    │
└──────┴──────────┴──────────┘
   ({.,:,each/@:(,:each)@}.) ',' readdsv 'dept.csv'
┌──────┬──────────┬──────────┐
│deptno│dname     │location  │
├──────┼──────────┼──────────┤
│10    │Accounting│"New York"│
│20    │Research  │Dallas    │
│30    │Sales     │Chicago   │
│40    │Operations│Boston    │
└──────┴──────────┴──────────┘
   ({.,:,each/@:(,:each)@}.) ',' readdsv 'emp.csv'
┌─────┬──────┬─────────┬────┬────────┬────┬────┬──────┐
│empno│ename │job      │mgr │hiredate│sal │comm│deptno│
├─────┼──────┼─────────┼────┼────────┼────┼────┼──────┤
│7369 │SMITH │CLERK    │7902│93/6/13 │800 │0   │20    │
│7499 │ALLEN │SALESMAN │7698│98/8/15 │1600│300 │30    │
│7521 │WARD  │SALESMAN │7698│96/3/26 │1250│500 │30    │
│7566 │JONES │MANAGER  │7839│95/10/31│2975│    │20    │
│7698 │BLAKE │MANAGER  │7839│92/6/11 │2850│    │30    │
│7782 │CLARK │MANAGER  │7839│93/5/14 │2450│    │10    │
│7788 │SCOTT │ANALYST  │7566│96/3/5  │3000│    │20    │
│7839 │KING  │PRESIDENT│    │90/6/9  │5000│0   │10    │
│7844 │TURNER│SALESMAN │7698│95/6/4  │1500│0   │30    │
│7876 │ADAMS │CLERK    │7788│99/6/4  │1100│    │20    │
│7900 │JAMES │CLERK    │7698│00/6/23 │950 │    │30    │
│7934 │MILLER│CLERK    │7782│00/1/21 │1300│    │10    │
│7902 │FORD  │ANALYST  │7566│97/12/5 │3000│    │20    │
│7654 │MARTIN│SALESMAN │7698│98/12/5 │1250│1400│30    │
└─────┴──────┴─────────┴────┴────────┴────┴────┴──────┘
   ({.,:,each/@:(,:each)@}.) ',' readdsv 'salgrade.csv'
┌─────┬─────┬─────┐
│grade│losal│hisal│
├─────┼─────┼─────┤
│1    │700  │1200 │
│2    │1201 │1400 │
│3    │1401 │2000 │
│4    │2001 │3000 │
│5    │3001 │99999│
└─────┴─────┴─────┘
```
The last versions are consistent with what we got using sql in J.

## Load CSV file to Jd

We can also ingest CSV file to `Jd` which is a relational database management system from Jsoftware that is implemented in J.
The Jd advertises itself as a very perfomant solution and has a prolific hands-on tutorial (https://www.jsoftware.com/jd_tuts.html)
```j
   load 'jd'
!!! Jd key: non-commercial use only!
   jdwelcome_jd_ NB. run this sentence for important information

   NB. instantiates db which is located in ~/j903-user/temp/jd/test directory
   NB. ├── jd
   NB. └── test
   NB.   ├── admin.ijs
   NB.   ├── jdclass
   NB.   ├── jdlock
   NB.   ├── jdstate
   NB.   ├── jdversion
   NB.   └── log.txt
   jdadminnew'test'

   NB. The first attempt to load from dept.csv is not successful
   jd'csvrd dept.csv dept'
|Jd error: CSVFOLDER must be defined as path to csv files: op:csvrd db:test user:u : jd_jd_
|       13!:8&3 t

   NB. After setting CSV folder it is still demanding presence of accompanying metafiles
   CSVFOLDER=:'./'
   jd'csvrd dept.csv dept'
|Jd error: cdefs file not found: op:csvrd db:test user:u : jd_jd_
|       13!:8&3 t

   NB. Create dept.cdefs file based on the CSV file
   jd'csvcdefs /replace /h 1 dept.csv'
   NB. using /replace overwrite the resultant cdefs file
   NB. using /h 1 enforces using column names in CSV file, in order to omit them - /h 0
   NB. and indeed the corresponding cdefs file was created
   fread jpath 'dept.cdefs'
1 deptno   int
2 dname    byte 10
3 location byte 8
options , CRLF " NO 1 iso8601-char

   NB.now we can load the dept.csv file into dept table
   jd'csvrd dept.csv dept'
   jd'reads from dept'
┌──────┬──────────┬────────┐
│deptno│dname     │location│
├──────┼──────────┼────────┤
│10    │Accounting│New York│
│20    │Research  │Dallas  │
│30    │Sales     │Chicago │
│40    │Operations│Boston  │
└──────┴──────────┴────────┘

   NB. The same procedure is adopted for other tables.
   jd'csvcdefs /replace /h 1 emp.csv'
   jd'csvrd emp.csv emp'
   jd'reads from emp'
┌─────┬──────┬─────────┬────────────────────┬────────┬────┬────────────────────┬──────┐
│empno│ename │job      │mgr                 │hiredate│sal │comm                │deptno│
├─────┼──────┼─────────┼────────────────────┼────────┼────┼────────────────────┼──────┤
│7369 │SMITH │CLERK    │                7902│93/6/13 │ 800│                   0│20    │
│7499 │ALLEN │SALESMAN │                7698│98/8/15 │1600│                 300│30    │
│7521 │WARD  │SALESMAN │                7698│96/3/26 │1250│                 500│30    │
│7566 │JONES │MANAGER  │                7839│95/10/31│2975│_9223372036854775808│20    │
│7698 │BLAKE │MANAGER  │                7839│92/6/11 │2850│_9223372036854775808│30    │
│7782 │CLARK │MANAGER  │                7839│93/5/14 │2450│_9223372036854775808│10    │
│7788 │SCOTT │ANALYST  │                7566│96/3/5  │3000│_9223372036854775808│20    │
│7839 │KING  │PRESIDENT│_9223372036854775808│90/6/9  │5000│                   0│10    │
│7844 │TURNER│SALESMAN │                7698│95/6/4  │1500│                   0│30    │
│7876 │ADAMS │CLERK    │                7788│99/6/4  │1100│_9223372036854775808│20    │
│7900 │JAMES │CLERK    │                7698│00/6/23 │ 950│_9223372036854775808│30    │
│7934 │MILLER│CLERK    │                7782│00/1/21 │1300│_9223372036854775808│10    │
│7902 │FORD  │ANALYST  │                7566│97/12/5 │3000│_9223372036854775808│20    │
│7654 │MARTIN│SALESMAN │                7698│98/12/5 │1250│                1400│30    │
└─────┴──────┴─────────┴────────────────────┴────────┴────┴────────────────────┴──────┘
   NB. Treatment of NULL values is the same as for 'data/sqlite' described in previous chapter.
   jd'csvcdefs /replace /h 1 salgrade.csv'
   jd'csvrd salgrade.csv salgrade'
   jd'reads from salgrade'
┌─────┬─────┬─────┐
│grade│losal│hisal│
├─────┼─────┼─────┤
│1    │ 700 │ 1200│
│2    │1201 │ 1400│
│3    │1401 │ 2000│
│4    │2001 │ 3000│
│5    │3001 │99999│
└─────┴─────┴─────┘
   jd'info summary'
┌────────┬────┐
│table   │rows│
├────────┼────┤
│dept    │ 4  │
│emp     │14  │
│salgrade│ 5  │
└────────┴────┘
   jd'csvreport'
table: dept
src: ./dept.csv
start: 2022 8 22 12 38 13
rows: 4

table: emp
src: ./emp.csv
start: 2022 8 22 13 28 2
rows: 14
error:  col  error                                # row position text
error:  mgr  ECMISSING   empty or all blank field 1 7   319      ,90/6/9,5000,0,10 CR  LF 7
error:  comm ECMISSING   empty or all blank field 8 3   169      ,20 CR  LF 7698,BLAKE,MANA

table: salgrade
src: ./salgrade.csv
start: 2022 8 22 13 28 55
rows: 5

   NB. Now if we get out of ijconsole or dump we can restore the db provided we have CSVFOLDER set correctly
$ ijconsole
   load 'jd'
!!! Jd key: non-commercial use only!
   jdwelcome_jd_ NB. run this sentence for important information

   jdadminx'test'
   jd'info summary'
┌─────┬────┐
│table│rows│
├─────┼────┤
└─────┴────┘
   jd'csvrestore'
|Jd error: CSVFOLDER must be defined as path to csv files: op:csvrestore db:test user:u : jd_jd_
|       13!:8&3 t
   CSVFOLDER=:'./'
   jd'csvrestore'
   jd'info summary'
┌────────┬────┐
│table   │rows│
├────────┼────┤
│dept    │ 4  │
│emp     │14  │
│salgrade│ 5  │
└────────┴────┘
```
