#!/bin/bash

# the pipeline’s return status is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully
# The shell waits for all commands in the pipeline to terminate before returning a value. 
set -eo pipefail

echo "[tomcat-consul] booting container tomcat."

export RESTART_COMMAND="$CATALINA_HOME/bin/catalina.sh stop -force 2> /dev/null ; /usr/local/tomcat/bin/catalina.sh start"

export SERVER_XML="$CATALINA_HOME/conf/server.xml"
export SERVER_XML_TEMPLATE="${SERVER_XML}.ctmpl"

export TOMCAT_USERS_XML="$CATALINA_HOME/conf/tomcat-users.xml"
export TOMCAT_USERS_XML_TEMPLATE="${TOMCAT_USERS_XML}.ctmpl"

export SETENV_SH="$CATALINA_HOME/bin/setenv.sh"
export SETENV_SH_TEMPLATE="${SETENV_SH}.ctmpl"

export TOMCAT_PREFIX=${TOMCAT_PREFIX:-tomcat}
export CATALINA_PID="$CATALINA_HOME/logs/catalina.pid"
export HOSTNAME=`hostname`

# /usr/local/tomcat/bin/catalina.sh start

consul-template \
    -log-level ${LOG_LEVEL:-warn} \
    -consul ${CONSUL_HTTP_ADDR:-"localhost:8500"} \
    -template "${SERVER_XML_TEMPLATE}:${SERVER_XML}:${RESTART_COMMAND} || true" \
    -template "${TOMCAT_USERS_XML_TEMPLATE}:${TOMCAT_USERS_XML}:${RESTART_COMMAND} || true" \
    -template "${SETENV_SH_TEMPLATE}:${SETENV_SH}:${RESTART_COMMAND} || true"

