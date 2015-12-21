#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "comboread.jpg";
set title "Time to Create and Read 100 Children" font "arial bold";
set xlabel "Batches of 100 Children";
set ylabel "Seconds";
set xrange [0:499];
set key top left Right samplen "2" enhanced;
plot
    "comboread.txt" using 1:2 title "Combined Flat" with lines lt rgb "blue",
    "comboread.txt" using 1:3 title "Combined PairTree" with lines lt rgb "gray",
    "comboread.txt" using 1:4 title "Combined Tiny" with lines lt rgb "red",
    "comboread.txt" using 1:5 title "Combined Small" with lines lt rgb "orange"'
