#!/bin/sh

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e 'set term jpeg enhanced size 800,600;
set output "combo.jpg";
set title "Time to Create 100 Children" font "arial bold";
set xlabel "Batches of 100 Children";
set ylabel "Seconds";
set xrange [0:215];
set yrange [0:400];
set key top left Right samplen "2";
plot
  "combo.txt" using 1:2 title "Flat"  with lines lt rgb "blue",
  "combo.txt" using 1:3 title "Tiny"  with lines lt rgb "red",
  "combo.txt" using 1:4 title "Small" with lines lt rgb "orange",
  "combo.txt" using 1:5 title "Large" with lines lt rgb "#00aa00",
  "combo.txt" using 1:6 title "Huge"  with lines lt rgb "purple"'
