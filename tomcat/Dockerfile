FROM tomcat

MAINTAINER derk@muenchhausen.de

ENV CONSUL_TEMPLATE_VERSION=0.16.0

RUN apt-get update \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsLo consul-template.zip "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
  && unzip consul-template.zip -d /usr/local/bin \
  && rm consul-template.zip

COPY conf/server.xml.ctmpl /usr/local/tomcat/conf/
COPY conf/tomcat-users.xml.ctmpl /usr/local/tomcat/conf/
COPY conf/setenv.sh.ctmpl /usr/local/tomcat/bin/

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

EXPOSE 8080
