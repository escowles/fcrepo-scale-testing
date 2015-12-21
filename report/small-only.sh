#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "small-only.jpg";
set title "Time to Create and Read 100 Children" font "arial bold";
set xlabel "Batches of 100 Children";
set ylabel "Seconds";
set key top left Right samplen "2";
plot
    "small-only.txt" using 1:2 title "Small (create)" with lines lt rgb "orange",
    "small-only.txt" using 1:3 title "Small (read)"   with lines lt rgb "#00aa00"'
