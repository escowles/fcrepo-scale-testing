#!/bin/bash

# create $SCALE containers of type $TYPE
# for $SCALE runs
#  - create a node in each container
#  - restart repo after each run (but keep data)

BASE=http://lib-fedora1:8080/fcrepo/rest/scale
SCALE=4096
TYPE="Small"

# create containers
curl -s -X PUT $BASE && echo
curl -s -X PUT -H "Content-type: text/turtle" -d "<> a <http://test.com/${TYPE}Container>" $BASE/$TYPE && echo
CONTAINER=0
while [ $CONTAINER -lt $SCALE ]; do
	curl -s -X PUT -H "Content-type: text/turtle" -d "<> a <http://test.com/${TYPE}Container>" $BASE/$TYPE/$CONTAINER > /dev/null
	CONTAINER=$(( $CONTAINER + 1 ))
done

# print headers
echo "Batch Size: $BATCH_SIZE"
echo -en "Batch\t$TYPE(w)\t$TYPE(r)"
echo

RUN=0
while [ $RUN -lt $SCALE ]; do
	echo -n $RUN

	# time to create $SCALE nodes
	START=`date +%s`
	CONTAINER=0
	while [ $CONTAINER -lt $SCALE ]; do
		curl -s -X PUT "Content-type: text/turtle" -d "<> <http://purl.org/dc/terms/title> \"Type $TYPE, RUN $RUN, Container $CONTAINER\"" $BASE/$TYPE/$CONTAINER/$RUN > /dev/null
		CONTAINER=$(( $CONTAINER + 1 ))
	done
	END=`date +%s`
	DUR=$(( $END - $START ))
	echo -en "\t$DUR"

	# time to read the nodes we just created
	START=`date +%s`
	curl -s $BASE/$TYPE/0 > /dev/null
	CONTAINER=0
	while [ $CONTAINER -lt $SCALE ]; do
		curl -s $BASE/$TYPE/$CONTAINER/$RUN > /dev/null
		CONTAINER=$(( $CONTAINER + 1 ))
	done
	END=`date +%s`
	DUR=$(( $END - $START ))
	echo -e "\t$DUR"

	# restart tomcat
	ssh lib-fedora1 "sudo /etc/init.d/tomcat7 restart > /dev/null"
	sleep 30

	RUN=$(( $RUN + 1 ))
done
