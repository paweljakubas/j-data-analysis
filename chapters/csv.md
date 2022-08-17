# CSV from J

Let's dump tables as CSV files from SQL.
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
