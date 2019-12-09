FROM buildpack-deps:stretch AS jsonnet

RUN apt update && \
    apt install --no-install-recommends -y \
        git \
	build-essential \
    # clean up
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/google/jsonnet && \
    cd jsonnet && \
    git checkout v0.14.0 && \
    make

FROM swaggerapi/swagger-codegen-cli-v3:3.0.14 AS swagger-codegen

FROM node:12-stretch
RUN apt update && \
    apt install --no-install-recommends -y \
	bash \
	git \
	make \
        # install Chinese fonts
        # this list was copied from https://github.com/jim3ma/docker-leanote
        fonts-arphic-bkai00mp \
        fonts-arphic-bsmi00lp \
        fonts-arphic-gbsn00lp \
        fonts-arphic-gkai00mp \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        libasound2 \
        libgconf-2-4 \
        libgtk-3-0 \
        libgtk2.0-0 \
        libnotify-dev \
        libnss3 \
        libxss1 \
        libxtst6 \
        openjdk-8-jdk \
        ttf-wqy-microhei \
        ttf-wqy-zenhei \
        xauth \
        xfonts-wqy \
        xvfb \
    # clean up
    && rm -rf /var/lib/apt/lists/*

COPY --from=jsonnet /opt/jsonnet/jsonnet /usr/local/bin
COPY --from=jsonnet /opt/jsonnet/jsonnetfmt /usr/local/bin
COPY --from=swagger-codegen /opt/swagger-codegen-cli/ /opt/swagger-codegen-cli/

ENTRYPOINT []
