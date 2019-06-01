FROM alpine:latest

ENV PANDOC_VERSION 2.7.2
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/archive/$PANDOC_VERSION.tar.gz
ENV PANDOC_DOWNLOAD_SHA512 4b3a21cf76777ed269bf7c13fd09ab1d5c97ed21ec9f02bff95fd3641ac9d52bde19a6e2ffb325378e611dfbe66b8b00769d8510a8b2fb1dfda8062d79b12233
ENV PANDOC_ROOT /usr/local/pandoc

# Install basic packages.
RUN apk update && \
    apk add --no-cache wget tar gzip zip bzip2 ca-certificates \
    python2 python2-dev bzip2 file unzip curl

# Install pip and aws-cli.
RUN wget "https://bootstrap.pypa.io/get-pip.py" -O /tmp/get-pip.py \
    && python /tmp/get-pip.py \
    && pip install awscli \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Pandoc.
RUN apk add --no-cache \
    gmp \
    libffi \
 && apk add --no-cache --virtual build-dependencies \
    --repository "http://nl.alpinelinux.org/alpine/edge/community" \
    ghc \
    cabal \
    linux-headers \
    musl-dev \
    zlib-dev \
    curl \
 && mkdir -p /pandoc-build && cd /pandoc-build \
 && curl -fsSL "$PANDOC_DOWNLOAD_URL" -o pandoc.tar.gz \
 && echo "$PANDOC_DOWNLOAD_SHA512  pandoc.tar.gz" | sha512sum -c - \
 && tar -xzf pandoc.tar.gz && rm -f pandoc.tar.gz \
 && ( cd pandoc-$PANDOC_VERSION && cabal update && cabal install --only-dependencies \
    && cabal configure --prefix=$PANDOC_ROOT \
    && cabal build \
    && cabal copy \
    && cd .. ) \
 && rm -Rf pandoc-$PANDOC_VERSION/ \
 && apk del --purge build-dependencies \
 && rm -Rf /root/.cabal/ /root/.ghc/ \
 && cd / && rm -Rf /pandoc-build

ENV PATH $PATH:$PANDOC_ROOT/bin
