# tomcat-consul - Apache tomcat consul cluster
This is a starting point for running and administrating multiple [Apache Tomcat](http://tomcat.apache.org/) using a central Configuration Repository - here [consul](https://www.consul.io/).

The main subject under test&sample is [consul-template](https://github.com/hashicorp/consul-template).   

Here we use [Apache httpd](http://httpd.apache.org/) as a reverse proxy for load balancing. Why? It is since 1996 the most popular WebServer and it works fine :)

## what is this sample doing?
Apache Tomcat uses config files e.g. ```tomcat-users.xml``` to define access rights to the manager webapp or ```server.xml``` to define connectors. Some parameters shall be configured centrally, so we can change them within consul. Next you find all available settings.


## Consul Key-Value 

setenv.sh settings                    | description
--------------------------------------|---------------------------------------
`<prefix>/Xms`                        | sets JVM `-Xms`
`<prefix>/Xmx`                        | sets JVM `-Xmx`

tomcat-users.xml settings             | description
--------------------------------------|---------------------------------------
`<prefix>/roles`                      | comma-delimited list of roles
`<prefix>/users/<user>`               | username
`<prefix>/users/<user>/password`      | password
`<prefix>/users/<user>/roles`         | comma-delimited list of roles

server.xml settings                   | description
--------------------------------------|---------------------------------------
`<prefix>/maxThreads`                 | maxThreads attribute for jk connector
`env SERVICE_NAME`                    | used for jvmRoute


## Test in Browser

Access Consul
- http://192.168.99.100:8500/ui/

Access Apache HTTPD
- http://192.168.99.100/server-status/
- http://192.168.99.100/balancer-manager

Access Tomcat directly and behind the reverse proxy
- http://192.168.99.100:8180/examples/jsp/
- http://192.168.99.100/examples/jsp/

## some interesting code snippets

if using docker tools - find out ip with ```docker-machine env``` then run e.g.
```
curl -X PUT -d "123" http://192.168.99.100:8500/v1/kv/tomcat/maxThreads
curl -X PUT -d "200M" http://192.168.99.100:8500/v1/kv/tomcat/Xms
curl -X PUT -d "512M" http://192.168.99.100:8500/v1/kv/tomcat/Xmx
curl -X PUT -d "tomcat,manager-gui" http://192.168.99.100:8500/v1/kv/tomcat/roles
curl -X PUT -d "admin" http://192.168.99.100:8500/v1/kv/tomcat/users/admin/password
curl -X PUT -d "readwrite" http://192.168.99.100:8500/v1/kv/tomcat/users/admin/access
curl -X PUT -d "tomcat,manager-gui" http://192.168.99.100:8500/v1/kv/tomcat/users/admin/roles
```

read values
```
Open Browser 
http://192.168.99.100:8500/v1/kv/?recurse
http://192.168.99.100:8500/v1/kv/tomcat/maxThreads?raw

curl http://192.168.99.100:8500/v1/kv/tomcat/maxThreads
```

restart docker-compose containers
```
docker-compose stop && docker-compose rm -f && docker-compose build && docker-compose up --force-recreate
```

## Credits
https://github.com/Neil-Ni/consul-demo
https://github.com/bdclark/docker-tomcat-consul

