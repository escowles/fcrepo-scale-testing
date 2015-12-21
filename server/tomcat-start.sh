#!/bin/sh

export JAVA_OPTS="-Djava.awt.headless=true -Xmx8G"
/etc/init.d/tomcat7 start
