FROM rgibert/gosu
MAINTAINER Richard Gibert <richard@gibert.ca>

RUN \
    groupadd -g 1000 consul && \
    useradd -u 1000 -g consul consul

RUN \
    yum install -y \
        wget

COPY usr/local/bin/entrypoint /usr/local/bin/entrypoint

ENV CONSUL_ARCH="amd64"
ENV CONSUL_URL="https://releases.hashicorp.com/consul"
ENV CONSUL_VERSION=0.6.4

RUN \
    wget \
        -O /tmp/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip \
        ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip && \
    wget \
        -O /tmp/consul_${CONSUL_VERSION}_SHA256SUMS.sig \
        ${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig && \
    wget \
        -O /tmp/consul_${CONSUL_VERSION}_SHA256SUMS \
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
    unzip -d /usr/local/bin consul_${CONSUL_VERSION}_linux_${CONSUL_ARCH}.zip && \

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "consul" ]

