#!/bin/sh

NAME=2-4k

export GNUPLOT_DEFAULT_GDFONT=arial
gnuplot -e "set term jpeg enhanced size 800,600;
set output \"$NAME.jpg\";
set title \"Time to Create and Read 4096 Children\" font \"arial bold\";
set xlabel \"Batches of 4096 Children\";
set ylabel \"Seconds\";
set key top left Right samplen \"2\";
plot
    \"$NAME.txt\" using 1:2 title \"Small (create)\" with lines lt rgb \"orange\",
    \"$NAME.txt\" using 1:3 title \"Small (read)\"   with lines lt rgb \"#00aa00\""

open $NAME.jpg
