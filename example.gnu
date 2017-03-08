#!/usr/bin/env gnuplot
#An example using genplot. The sciency parts have been scrambled since it's not my intention to distribute my coursework, only the tools I used to make it. As a result it shouldn't be ran.

#Load genplot from the current directory
load "./genplot.gnu"

#Set things as usual
set term pngcairo
set output "plot.png"
set fit quiet errorvariables
set key samplen 1 spacing 1 outside
set xrange [0:1]
set xlabel "X-label"
set ylabel "Y-Label"

#A random number and function so I don't have to retype the same nonsense
somenumber = 123456
fn(x) = somenumber*x

#Helper functions that just retrieve the columns of a datafile
AA(N) = somenumber
AB(N) = somenumber
AC(N) = somenumber
AD(N) = somenumber
BA(N) = 1+somenumber*N
BB(N) = 2+somenumber*N
BC(N) = 3+somenumber*N
BD(N) = 4+somenumber*N

#The file I'm working with
fh = "data.dat"
#A variable, as usual
thingy = 123456

#Helper functions to put everything in one place, and construct them up in steps
xaxis(N) = "".AA
yaxis(N) = sprintf("(fn($%d*thingy))", 3+4*N)
xerr(N) = "(somenumber)"
yerr(N) = sprintf("(sqrt(($%d/$%d)**2 + (somenumber/$%d)**2 + (somenumber)**2))", BD(N), BB(N), AD(N))
columns(N) = sprintf("%s:%s:%s:%s", xaxis(N), yaxis(N), xerr(N), yerr(N))
fitopts(N) = sprintf("xyerrors")
plotfhopts(N) = sprintf("w xyerrorbars ls %d t \"Peak %d\"", N, N)
plotfnopts(N) = sprintf("ls %d t \"Fit %d\"", N, N)

#Using a for loop (same as a do loop), generate the commands for lines 1-3 and run them using eval.
do for [i=1:3] {
  eval(genLineN(i, 1, 1)."; ".genFit("", lineN(i), fh, columns(i), fitopts(i), lineNvars(i)))}

#Make an empty plot and add pairs of datapoints and the fitting line
PLOT = genPlot(1)
do for [i=1:3] {
  PLOT = addFh(PLOT, fh, columns(i), plotfhopts(i))
  PLOT = addFn(PLOT, lineN(i), plotfnopts(i))}


#Helper function because I wanted to split up the next function call
FA(N) = "fn(somenumber)*m".N
FA_err(N) = "fn(somenumber)*m".N

#Helper function to generate the contents of a label, since I wanted to have two groups of labels. The nested sprintf means we have to escape the % by prepending a %
labelstring(N) = sprintf("sprintf(\"X^%d = %%.2e +/- %%.0e units,\n\tY = %%.0f +/- %%.0f units\", m%d, m%d_err, %s, %s)", N, N, N, FA(N), FA_err(N))

#Make  label in the top left
eval("set label 1 ".labelstring(1)." at graph 0.23,graph 0.95")

#Make two labels in the bottom left
do for [i=2:3] {
  eval("set label ".i." ".labelstring(i)." at graph 0.03,graph ".sprintf("%f", fn(i)))}

#Run the plot command
eval(PLOT)
