#!/bin/sh

./tomcat-stop.sh && ./disk-clear.sh && ./tomcat-start.sh && ./tomcat-log.sh
