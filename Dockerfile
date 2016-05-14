FROM rgibert/gosu:alpine
MAINTAINER Richard Gibert <richard@gibert.ca>

ENV \
    CONSUL_USER="consul" \
    CONSUL_GROUP="consul" \
    CONSUL_HOME="/usr/local/share/consul" \
    CONSUL_ARCH="amd64" \
    CONSUL_URL="https://releases.hashicorp.com/consul"

# Default Consul settings
ENV \
    CONSUL_BOOTSTRAP_EXPECT="1" \
    CONSUL_DC="consul"

RUN \
    adduser \
        -D \
        -s /bin/false \
        -g ${CONSUL_GROUP} \
        ${CONSUL_USER} && \
    apk \
        --no-cache \
        add \
            ca-certificates \
            openssl \
        && \
    mkdir -p ${CONSUL_HOME}/data

COPY \
    usr/local/bin/entrypoint \
    /usr/local/bin/entrypoint

ENV \
    CONSUL_VERSION="0.6.4" \
    CONSUL_SHA256="abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627"

ADD \
    ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip \
    ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip

RUN \
    echo "${CONSUL_SHA256}  ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip" > ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.sha256 && \
    sha256sum -c ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.sha256 && \
    unzip -d ${CONSUL_HOME} ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip && \
    rm ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.sha256 && \
    chown -R ${CONSUL_USER}:${CONSUL_GROUP} ${CONSUL_HOME} && \
    chmod 755 ${CONSUL_HOME}/consul

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "consul-server" ]

