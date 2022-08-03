# SQL from J

Harnessing data from data source is fundamental task before any analysis.
As SQL databases are so prevalent we will start working with the database from J.
We will use sqlite3 database as an example.

## sqlite lib installation and check-out

Make sure you have sqlite3 in your system
```bash
$ which sqlite3
/usr/bin/sqlite3
```

J lang offers sqlite library that is about to be installed when you
```j
install 'all'
```

It might be the case that upon loading the library you will see the following:
```j
   load 'data/sqlite'
   getbin_psqlite_''
The data/sqlite binary has not yet been installed.

To install,  run the getbin_psqlite_'' line written to the session.
   getbin_psqlite_''
chmod: cannot access '/usr/share/j/9.03/addons/data/sqlite/lib/libjsqlite3.so': No such file or directory
Connection failed: curl: (23) Failure writing output to destination
```

If that happens then you need to download the shared library from http://www.jsoftware.com/download/sqlite/
and move it to the referenced location:
```bash
sudo mv libjsqlite3.so /usr/share/j/9.03/addons/data/sqlite/lib/
```

Now one can try again:
```j
   getbin_psqlite_''
Sqlite binary installed.
```

Now let's create DB with three tables using the following script
(this is a DB used in prolific SQL Cookbook by Anthony Molinaro and Robert de Graaf [1])
```bash
$ cat create.sql
DROP TABLE IF EXISTS dept;
DROP TABLE IF EXISTS salgrade;
DROP TABLE IF EXISTS emp;

CREATE TABLE salgrade(
grade int(4) not null primary key,
losal decimal(10,2),
hisal decimal(10,2));

CREATE TABLE dept(
deptno int(2) not null primary key,
dname varchar(50) not null,
location varchar(50) not null);

CREATE TABLE emp(
empno int(4) not null primary key,
ename varchar(50) not null,
job varchar(50) not null,
mgr int(4),
hiredate date,
sal decimal(10,2),
comm decimal(10,2),
deptno int(2) not null);

insert into dept values (10,'Accounting','New York');

insert into dept values (20,'Research','Dallas');

insert into dept values (30,'Sales','Chicago');

insert into dept values (40,'Operations','Boston');


insert into emp values (7369,'SMITH','CLERK',7902,'93/6/13',800,0.00,20);

insert into emp values (7499,'ALLEN','SALESMAN',7698,'98/8/15',1600,300,30);

insert into emp values (7521,'WARD','SALESMAN',7698,'96/3/26',1250,500,30);

insert into emp values (7566,'JONES','MANAGER',7839,'95/10/31',2975,null,20);

insert into emp values (7698,'BLAKE','MANAGER',7839,'92/6/11',2850,null,30);

insert into emp values (7782,'CLARK','MANAGER',7839,'93/5/14',2450,null,10);

insert into emp values (7788,'SCOTT','ANALYST',7566,'96/3/5',3000,null,20);

insert into emp values (7839,'KING','PRESIDENT',null,'90/6/9',5000,0,10);

insert into emp values (7844,'TURNER','SALESMAN',7698,'95/6/4',1500,0,30);

insert into emp values (7876,'ADAMS','CLERK',7788,'99/6/4',1100,null,20);

insert into emp values (7900,'JAMES','CLERK',7698,'00/6/23',950,null,30);

insert into emp values (7934,'MILLER','CLERK',7782,'00/1/21',1300,null,10);

insert into emp values (7902,'FORD','ANALYST',7566,'97/12/5',3000,null,20);

insert into emp values (7654,'MARTIN','SALESMAN',7698,'98/12/5',1250,1400,30);


insert into salgrade values (1,700,1200);

insert into salgrade values (2,1201,1400);

insert into salgrade values (3,1401,2000);

insert into salgrade values (4,2001,3000);

insert into salgrade values (5,3001,99999);
```

We can load the script
```bash
$ sqlite3 test.db < create.sql
```

Now we can inspect the created db
```sql
$ sqlite3 test.db
SQLite version 3.39.1 2022-07-13 19:41:41
Enter ".help" for usage hints.

sqlite> .tables
dept      emp       salgrade

sqlite> .schema emp
CREATE TABLE emp(
empno int(4) not null primary key,
ename varchar(50) not null,
job varchar(50) not null,
mgr int(4),
hiredate date,
sal decimal(10,2),
comm decimal(10,2),
deptno int(2) not null);

sqlite> select * from dept;
10|Accounting|New York
20|Research|Dallas
30|Sales|Chicago
40|Operations|Boston

sqlite> select * from emp;
7369|SMITH|CLERK|7902|93/6/13|800|0|20
7499|ALLEN|SALESMAN|7698|98/8/15|1600|300|30
7521|WARD|SALESMAN|7698|96/3/26|1250|500|30
7566|JONES|MANAGER|7839|95/10/31|2975||20
7698|BLAKE|MANAGER|7839|92/6/11|2850||30
7782|CLARK|MANAGER|7839|93/5/14|2450||10
7788|SCOTT|ANALYST|7566|96/3/5|3000||20
7839|KING|PRESIDENT||90/6/9|5000|0|10
7844|TURNER|SALESMAN|7698|95/6/4|1500|0|30
7876|ADAMS|CLERK|7788|99/6/4|1100||20
7900|JAMES|CLERK|7698|00/6/23|950||30
7934|MILLER|CLERK|7782|00/1/21|1300||10
7902|FORD|ANALYST|7566|97/12/5|3000||20
7654|MARTIN|SALESMAN|7698|98/12/5|1250|1400|30

sqlite> select * from salgrade;
1|700|1200
2|1201|1400
3|1401|2000
4|2001|3000
5|3001|99999
```

Let's see now how to work with this db in J.
```j
   load 'data/sqlite'
   db=: sqlopen_psqlite_ 'test.db'
   sqltables__db''
┌────┬───┬────────┐
│dept│emp│salgrade│
└────┴───┴────────┘
   sqlmeta__db 'emp'
┌───┬────────┬─────────────┬───────┬──────────┬──┐
│cid│name    │type         │notnull│dflt_value│pk│
├───┼────────┼─────────────┼───────┼──────────┼──┤
│0  │empno   │int(4)       │1      │NULL      │1 │
│1  │ename   │varchar(50)  │1      │NULL      │0 │
│2  │job     │varchar(50)  │1      │NULL      │0 │
│3  │mgr     │int(4)       │0      │NULL      │0 │
│4  │hiredate│date         │0      │NULL      │0 │
│5  │sal     │decimal(10,2)│0      │NULL      │0 │
│6  │comm    │decimal(10,2)│0      │NULL      │0 │
│7  │deptno  │int(2)       │1      │NULL      │0 │
└───┴────────┴─────────────┴───────┴──────────┴──┘
   sqlreads__db 'select * from dept'
┌──────┬──────────┬────────┐
│deptno│dname     │location│
├──────┼──────────┼────────┤
│10    │Accounting│New York│
│20    │Research  │Dallas  │
│30    │Sales     │Chicago │
│40    │Operations│Boston  │
└──────┴──────────┴────────┘
   sqlreads__db 'select * from emp'
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
   sqlreads__db 'select * from salgrade'
┌─────┬─────┬─────┐
│grade│losal│hisal│
├─────┼─────┼─────┤
│1    │ 700 │ 1200│
│2    │1201 │ 1400│
│3    │1401 │ 2000│
│4    │2001 │ 3000│
│5    │3001 │99999│
└─────┴─────┴─────┘
```

We see big negative numbers instead of NULLs that stem from the fact that
NULL is represented as the largest possible negative integer. For j64 it is
```j
   SQLITE_NULL_INTEGER_psqlite_
_9223372036854775808
   SQLITE_NULL_FLOAT_psqlite_
__
   SQLITE_NULL_TEXT_psqlite_
NULL
```

Let's now use high level interface and see how to set default NULL values if needed:
```j
   load 'data/sqlite/sqlitez'
   dbopen jpath 'test.db'
   dbreads 'emp'
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
   dbclose''
   SQLITE_NULL_INTEGER_psqlite_=: 1
   dbopen jpath 'test.db'
   dbreads 'emp'
┌─────┬──────┬─────────┬────┬────────┬────┬────┬──────┐
│empno│ename │job      │mgr │hiredate│sal │comm│deptno│
├─────┼──────┼─────────┼────┼────────┼────┼────┼──────┤
│7369 │SMITH │CLERK    │7902│93/6/13 │ 800│   0│20    │
│7499 │ALLEN │SALESMAN │7698│98/8/15 │1600│ 300│30    │
│7521 │WARD  │SALESMAN │7698│96/3/26 │1250│ 500│30    │
│7566 │JONES │MANAGER  │7839│95/10/31│2975│   1│20    │
│7698 │BLAKE │MANAGER  │7839│92/6/11 │2850│   1│30    │
│7782 │CLARK │MANAGER  │7839│93/5/14 │2450│   1│10    │
│7788 │SCOTT │ANALYST  │7566│96/3/5  │3000│   1│20    │
│7839 │KING  │PRESIDENT│   1│90/6/9  │5000│   0│10    │
│7844 │TURNER│SALESMAN │7698│95/6/4  │1500│   0│30    │
│7876 │ADAMS │CLERK    │7788│99/6/4  │1100│   1│20    │
│7900 │JAMES │CLERK    │7698│00/6/23 │ 950│   1│30    │
│7934 │MILLER│CLERK    │7782│00/1/21 │1300│   1│10    │
│7902 │FORD  │ANALYST  │7566│97/12/5 │3000│   1│20    │
│7654 │MARTIN│SALESMAN │7698│98/12/5 │1250│1400│30    │
└─────┴──────┴─────────┴────┴────────┴────┴────┴──────┘
```

Note: `dbreads 'emp'` is shortcut for `dbreads 'SELECT * FROM emp'`
