FROM rgibert/gosu:alpine
MAINTAINER Richard Gibert <richard@gibert.ca>

ENV \
    CONSUL_USER="consul" \
    CONSUL_GROUP="consul" \
    CONSUL_HOME="/usr/local/share/consul" \
    CONSUL_ARCH="amd64" \
    CONSUL_URL="https://releases.hashicorp.com/consul"

RUN \
    adduser -D -s /bin/false -g ${CONSUL_GROUP} ${CONSUL_USER} && \
    apk --update add openssl && \
    mkdir -p ${CONSUL_HOME}

COPY \
    usr/local/bin/entrypoint \
    /usr/local/bin/entrypoint

ENV \
    CONSUL_VERSION=0.6.4

RUN \
    wget \
        -O ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip \
        ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip && \
    wget \
        -O ${CONSUL_HOME}/consul_${CONSUL_VERSION}_SHA256SUMS.sig \
        ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig && \
    wget \
        -O ${CONSUL_HOME}/consul_${CONSUL_VERSION}_SHA256SUMS \
        ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS && \
    gpg \
        --batch \
        --verify \
        /tmp/consul_${CONSUL_VERSION}_SHA256SUMS.sig \
        /tmp/consul_${CONSUL_VERSION}_SHA256SUMS && \
    grep \
        consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip \
        consul_${CONSUL_VERSION}_SHA256SUMS \
        | sha256sum -c && \
    unzip -d ${CONSUL_HOME} ${CONSUL_HOME}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip && \
    chown -r ${CONSUL_USER}:${CONSUL_GROUP} ${CONSUL_HOME} && \
    chmod 755 ${CONSUL_HOME}/consul

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "consul" ]

