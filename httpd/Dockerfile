FROM httpd
MAINTAINER derk@muenchhausen.de

RUN apt-get update \
	&& apt-get install -y \
		curl \
		libapache2-mod-proxy-html

ENV CONSUL_TEMPLATE_VERSION=0.16.0

RUN apt-get update \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsLo consul-template.zip "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
  && unzip consul-template.zip -d /usr/local/bin \
  && rm consul-template.zip

COPY conf/httpd-info.conf ${HTTPD_PREFIX}/conf/extra/
COPY conf/proxy_balancer.conf ${HTTPD_PREFIX}/conf/extra/
COPY conf/proxy_ajp.conf.ctmpl ${HTTPD_PREFIX}/conf/extra/
RUN echo > ${HTTPD_PREFIX}/conf/extra/proxy_ajp.conf

RUN sed -i -e "s/#LoadModule proxy_module /LoadModule proxy_module /" ${HTTPD_PREFIX}/conf/httpd.conf
RUN sed -i -e "s/#LoadModule proxy_ajp_module /LoadModule proxy_ajp_module /" ${HTTPD_PREFIX}/conf/httpd.conf
RUN sed -i -e "s/#LoadModule proxy_balancer_module /LoadModule proxy_balancer_module /" ${HTTPD_PREFIX}/conf/httpd.conf
RUN sed -i -e "s/#LoadModule lbmethod_byrequests_module /LoadModule lbmethod_byrequests_module /" ${HTTPD_PREFIX}/conf/httpd.conf
RUN sed -i -e "s/#LoadModule slotmem_shm_module /LoadModule slotmem_shm_module /" ${HTTPD_PREFIX}/conf/httpd.conf
RUN sed -i -e "s@#Include conf/extra/httpd-info.conf@Include conf/extra/httpd-info.conf@" ${HTTPD_PREFIX}/conf/httpd.conf
RUN echo "Include conf/extra/proxy_ajp.conf" >> ${HTTPD_PREFIX}/conf/httpd.conf
RUN echo "Include conf/extra/proxy_balancer.conf" >> ${HTTPD_PREFIX}/conf/httpd.conf

ADD entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
