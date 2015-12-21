#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "2-1000.jpg";
set title "Time to Create and Read 1000 Children" font "arial bold";
set xlabel "Batches of 1000 Children";
set ylabel "Seconds";
set key top left Right samplen "2";
set yrange [0:100];
plot
    "2-1000.txt" using 1:2 title "Flat (create)"  with lines lt rgb "purple",
    "2-1000.txt" using 1:3 title "Flat (read)"    with lines lt rgb "gray",
    "2-1000.txt" using 1:4 title "Tiny (create)"  with lines lt rgb "red",
    "2-1000.txt" using 1:5 title "Tiny (read)"    with lines lt rgb "blue",
    "2-1000.txt" using 1:6 title "Small (create)" with lines lt rgb "orange",
    "2-1000.txt" using 1:7 title "Small (read)"   with lines lt rgb "#00aa00"'
