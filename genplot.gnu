#!/usr/bin/env gnuplot
#The above allows you to execute this as a gunplot script ("./genplot.gnu") if it has execute permission ("chmod +x genplot.gnu"). What it does is asks the environment program to look for a gnuplot, and then hands it over -- this is better than using a hard link to gnuplot as sometimes things are installed in odd places or with odd names.

#This script allows you to generate gnuplot scripts from within gnuplot, using the inbuilt function eval(s) which evaluates a string as a gnuplot command. This is useful if you need dynamism not provided in normal gnuplot - my usecase was to save me writing out code multiple times and matching line colour to plot point colour for multiple lines of different colour. The project aims to make human-readable code.

#General notes:
#	Most function parameters are strings, and don't need leading/traling spaces.
#	Optional arguments to the normal commands (e.g. range for fit) can be ommitted.
#Common shorthands:
#	fh => filehandle/filename
#	fn => function name
#	cols => the columns required by the u/using part
#	opts => The options -- don't forget to add the w/with part
#	vars => The fitting variables
#	range => The range of values for the command to operate over

#Needed to generate plot strings and test whether one is `empty'
emptyplot = "plot\t"

#Much needed string function using the ternary operator and the string equality
#s1.s2 appends the string s2 onto s1. It converts integer numbers too, but doesn't like expressions in parenthesis.
#TrueOrFalseValue ? returnTrueCase : returnFalseCase
isEmpty(s) = s eq "" ? 1 : 0
lpads(s, a) = s eq "" ? "" : a.s
lpad(s) = lpads(s, " ")
rpads(s, a) = s eq "" ? "" : s.a
rpad(s) = rpads(s, " ")
lrpads(s, a, b) = s eq "" ? "" : a.s.b
lrpad(s) = lrpads(s, " ", " ")

#Generates the gnuplot code for a generic line, useful if you need a bunch of lines that you can dynamically define. It is best to not use this directly, and instead 'wrap' it like the following function does.
genLinear(name, grad, const, a, b) = sprintf("%s(x) = %s*x + %s; %s = %e; %s = %e", name, grad, const, grad, a, const, b)
#Generates the code for a line named lineN where N is your index, alongside the variables mN and cN as your gradient and y-intercept respectively.
genLineN(N, a, b) = genLinear("line".N, "m".N, "c".N, a, b)
#Helper functions that return the names of genLineN's generated things
lineN(N) = "line".N."(x)"
lineNvars(N) = "m".N.","."c".N

#Generates the code to fit a function to some file
genFit(range, fn, fh, cols, opts, vars) = sprintf("fit %s%s \"%s\" u %s %svia %s", rpad(range), fn, fh, cols, lrpad(opts), vars)

#These functions are used to construct a plot command string by appending what you want to add to your current plot string. It requires you to pass the plot string as an argument, but allows you to skip out on writing PLOT = PLOT.somestring lines, instead just doing PLOT = addThing .
#Generates an empty plot. Has a dummy argument since gnuplot needs one.
genPlot(x) = emptyplot
#Adds data points from a file to your plot
addFh(plots, fh, cols, opts) = plots.sprintf("%s\"%s\" u %s%s", plots eq emptyplot ? "" : ", ", fh, cols, lpad(opts))
#Adds a function to your plot
addFn(plots, fn, opts) = plots.sprintf("%s%s%s", plots eq emptyplot ? "" : ", ",fn, lrpad(opts))
