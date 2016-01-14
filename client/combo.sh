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

RUNS=100
BATCH_SIZE=100
BASE=http://lib-fedora1:8080/fcrepo/rest/scale
TYPES="Normal Tiny Small Large Huge"

RUN=0
while [ $RUN -lt $RUNS ]; do
	# run 100 batches
	BATCH_COUNT=$(( ($RUN + 1) * 100 ))
	BATCH_START=$(( $RUN * 100 ))

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
		echo -en "\t$TYPE"
	done
	echo

	# run batches
	BATCH=$BATCH_START
	while [ $BATCH -lt $BATCH_COUNT ]; do
		echo -n $BATCH
		for TYPE in $TYPES; do
			START=`date +%s`
			ITEM=0
			while [ $ITEM -lt $BATCH_SIZE ]; do
				curl -s -X PUT -H "Content-type: text/turtle" -d "<> <http://purl.org/dc/terms/title> \"Type $TYPE, Batch $BATCH, Item $ITEM\"" $BASE/$TYPE/$BATCH-$ITEM > /dev/null
				ITEM=$(( $ITEM + 1 ))
			done
			END=`date +%s`
			DUR=$(( $END - $START ))
			echo -en "\t$DUR"
		done
		echo

		# restart tomcat
		ssh lib-fedora1 "sudo /etc/init.d/tomcat7 restart > /dev/null"
		sleep 30

		BATCH=$(( $BATCH + 1 ))
	done


	RUN=$(( $RUN + 1 ))
done
