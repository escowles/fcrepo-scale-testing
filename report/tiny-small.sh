#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "tiny-small.jpg";
set title "Time to Create and Read 100 Children" font "arial bold";
set xlabel "Batches of 100 Children";
set ylabel "Seconds";
set key top left Right samplen "2";
set xrange [0:3158];
plot
    "tiny-small.txt" using 1:2 title "Tiny (create)"  with lines lt rgb "red",
    "tiny-small.txt" using 1:3 title "Tiny (read)"    with lines lt rgb "blue",
    "tiny-small.txt" using 1:4 title "Small (create)" with lines lt rgb "orange",
    "tiny-small.txt" using 1:5 title "Small (read)"   with lines lt rgb "#00aa00"'
