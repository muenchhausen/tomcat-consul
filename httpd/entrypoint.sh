#!/bin/bash

# the pipeline’s return status is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully
# The shell waits for all commands in the pipeline to terminate before returning a value. 
set -eo pipefail

echo "[httpd-consul] booting container httpd."

export RESTART_COMMAND="apachectl restart"
export PROXY_AJP_CONF="${HTTPD_PREFIX}/conf/extra/proxy_ajp.conf"
export PROXY_AJP_CONF_TEMPLATE="${PROXY_AJP_CONF}.ctmpl"

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid
apachectl

consul-template \
    -log-level ${LOG_LEVEL:-warn} \
    -consul ${CONSUL_HTTP_ADDR:-"localhost:8500"} \
    -template "${PROXY_AJP_CONF_TEMPLATE}:${PROXY_AJP_CONF}:${RESTART_COMMAND} || true"
