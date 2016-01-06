#!/bin/bash

# process:
# * fresh repo
# * 100 objects per batch, 100 batches per run (10K objects per run)
# * restart repo after each run (but keep data)
# * first run:
#   - create a normal container and a container for each kind of unordered coll
# * each run
#   - 100 batches:
#     - for each type, add 100 objects and report duration

RUNS=1000
BATCH_SIZE=1000
BASE=http://lib-fedora1:8080/fcrepo/rest/scale
TYPES="Flat Tiny Small"

RUN=0
while [ $RUN -lt $RUNS ]; do
	BATCH_COUNT=$(( ($RUN + 1) * $BATCH_SIZE ))
	BATCH_START=$(( $RUN * $BATCH_SIZE ))

	# create containers
	if [ "$RUN" = "0" ]; then
		curl -s -X PUT $BASE && echo
		for TYPE in $TYPES; do
			curl -s -X PUT -H "Content-type: text/turtle" -d "<> a <http://test.com/${TYPE}Container>" $BASE/$TYPE && echo
		done
	fi

	# print headers
	echo "Batch Size: $BATCH_SIZE"
	echo -n "Batch"
	for TYPE in $TYPES; do
		echo -en "\t$TYPE(w)\t$TYPE(r)"
	done
	echo

	# run batches
	BATCH=$BATCH_START
	while [ $BATCH -lt $BATCH_COUNT ]; do
		echo -n $BATCH
		for TYPE in $TYPES; do
			START=`date +%s`

			# create container
			curl -s -X PUT -H "Content-type: text/turtle" -d "<> a <http://test.com/${TYPE}Container>" $BASE/$TYPE/$BATCH > /dev/null

			# load itmes
			ITEM=0
			while [ $ITEM -lt $BATCH_SIZE ]; do
				curl -s -X PUT -H "Content-type: text/turtle" -d "<> <http://purl.org/dc/terms/title> \"Type $TYPE, Batch $BATCH, Item $ITEM\"" $BASE/$TYPE/$BATCH/$ITEM > /dev/null
				ITEM=$(( $ITEM + 1 ))
			done
			END=`date +%s`
			DUR=$(( $END - $START ))
			echo -en "\t$DUR"

			# also test reads 100 times
			START=`date +%s`
			curl -s $BASE > /dev/null
			CHILDREN=`curl -s $BASE/$TYPE/$BATCH | grep ldp:contains | grep $TYPE | tr ',' '\n' | tr -d '<>' | head -999`
			for i in $CHILDREN; do
        			curl -s $i > /dev/null
			done
			END=`date +%s`
			DUR=$(( $END - $START ))
			echo -en "\t$DUR"
		done
		echo

		BATCH=$(( $BATCH + 1 ))
	done

	# restart tomcat
	ssh lib-fedora1 "sudo /etc/init.d/tomcat7 restart > /dev/null"
	sleep 30

	RUN=$(( $RUN + 1 ))
done
