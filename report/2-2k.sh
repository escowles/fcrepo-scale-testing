#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "2-2k.jpg";
set title "Time to Create and Read 2048 Children" font "arial bold";
set xlabel "Batches of 2048 Children";
set ylabel "Seconds";
set key top left Right samplen "2";
set xrange [0:590];
plot
    "2-2k.txt" using 1:2 title "Small (create)" with lines lt rgb "orange",
    "2-2k.txt" using 1:3 title "Small (read)"   with lines lt rgb "#00aa00"'
open 2-2k.jpg
