# Data analysis using J

by Pawel Jakubas, PhD

These are notes that cover a number of topics that I have
found fundamental to master data analysis using J language. The prerequisite
for fully comprehending the examples below is *Learning J* which is the recommended first
introductory material when learning J. The great example how beautifully and effciently J can be used in a specific domain is
a wonderful *Fractals, Visualization and J*. Besides that a list of high quality book references is specified.
The notes are supposed to be hands-on and to illustrate how efficient data analysis can be performed using J.
The topics and techniques presented reflect the author's subjective take on what is crucial to master the many tasks that are
required for powerful data analysis.

### SQL, data analysis, probability, statistics and machine learning
1. SQL Cookbook, Anthony Molinaro, Robert de Graaf, 2nd ed., O'Reilly 2021
2. SQL for Data Analysis: Advanced Techniques for Transforming Data into Insights, Cathy Tanimura, O'Reilly 2021
3. Data Analysis Techniques for Physical Scientists, Claude A. Pruneau, Cambridge University Press 2017
4. Statistics, Data Mining, and Machine Learning in Astronomy: A Practical Python Guide for the Analysis of Survey Data, Željko Ivezić, Andrew J. Connolly, Jacob T. VanderPlas, and Alexander Gray, Updated Edition, Princeton University Press 2020
5. Information Theory, Inference, and Learning Algorithms, David J.C. MacKay, Cambridge University Press 2003
6. Introduction to Probability Models, Sheldon M. Ross, 12th ed., Academic Press 2019
7. Statistical Inference, George Casella, Roger L. Berger, 2nd ed, Cengage Learning 2001
8. Computational Statistics, Geof H. Givens and Jennifer A. Hoeting, 2nd ed, Wiley 2013
9. Fundamentals of Machine Learning for Predictive Data Analytics: Algorithms, Worked Examples, and Case Studies, John D. Kelleher, Brian Mac Namee, Aoife D'Arcy, 2nd ed, MIT Press 2020
10. Statistical Rethinking: A Bayesian Course with Examples in R and STAN, Richard McElreath, 2nd ed, CRC 2020

### J language
11. Learning J. An Introduction to the J Programming Language, Roger Stokes, [https://www.jsoftware.com/help/learning/contents.htm#toc]
12. Fractals, Visualization & J, 4th ed. (2 Parts), Clifford A. Reiter 2016
13. Fifty Shades of J, Norman Thomson, [https://code.jsoftware.com/wiki/Fifty_Shades_of_J]
14. Math adventures using J, Pawel Jakubas, [https://github.com/paweljakubas/j-math]

   *Throughout the code 9.7 version of J lang was used.*


## Contents
### [SQL](chapters/sql.md)
### [CSV](chapters/csv.md)
### [Inverted table](chapters/inverted-table.md)
### [Gnuplot](chapters/gnuplot.md)
### [zsat](chapters/zsat.md)

[zsat](https://github.com/paweljakubas/zsat) is a Zig-based science plotting and
animation command line tool. It consumes 2D vector data from **stdin** as JSON,
e.g. `[[0,1],[1,3],[2,4]]`, and renders it in any terminal that implements the
[kitty graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/)
(Kitty, WezTerm, Ghostty, ...).

`j/analysis.ijs` ships a `vec2d` function that turns a two-row array into
zsat's `vec2d` JSON and hands it over to zsat through a named pipe (FIFO). This
makes it possible to drive zsat directly from an interactive `jconsole` session
running in one terminal, while zsat consumes the data from another.

`vec2d` takes a two-row array (`2 x n`) where each column becomes one `[x,y]`
pair:

```j
   vec2d 2 3 $ 0 1 2 1 3 4
[[0,1],[1,3],[2,4]]
```

The JSON is written to the FIFO named by the `JZSAT_FIFO` environment variable
(default `/tmp/jzsat.fifo`, created automatically) and is also returned as the
result.

#### Workflow

1. In `jconsole` invoke `vec2d`. J opens the FIFO for writing and blocks,
   waiting for a reader to attach:

   ```j
   jconsole> vec2d 2 3 $ 0 1 2 1 3 4
   ```

2. Switch to the terminal/pane where `zsat` runs and consume the stream. The
   reader attaches to the FIFO, the data flows, and zsat draws the figure:

   ```bash
   zsat draw < /tmp/jzsat.fifo
   ```

3. Switch back to `jconsole`, which has returned to the prompt and printed the
   JSON it sent:

   ```
   [[0,1],[1,3],[2,4]]
   ```

To use a different FIFO path, set `JZSAT_FIFO` before starting `jconsole`:

```bash
JZSAT_FIFO=/tmp/my.fifo jconsole
```

### [Inverted table workout and comparison with polar and pandas](chapters/workout.md)
### [Analysis of NIPA data series](chapters/nipa.md)
### [Data analysis cases using SQL and J's approach]
### [Information-based learning]
### [Similarity-based learning]
### [Deep look at statistical distributions]
### [Classical inference]
### [Bayesian inference]
### [Error-based learning]
### [Deep learning]
### [Case study - Titanic]
### [Case study - Multimodal Single-Cell Integration]
### [Case study - Galaxy classification]
### [Case study - Treasury yield curves and surfaces]

<div align="center">
  <img src="./figures/NoAiHand.png" alt="No AI powered, only Human effort" width="200">
  <p>Figure 1: Disclaimer for this repo</p>
</div>