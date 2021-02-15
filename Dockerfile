# Pandoc team is keeping their images up to date, so we start there...
FROM pandoc/crossref:latest AS build-pandoc

# Then build our own image from its output.
FROM alpine:latest

# Install basic packages.
RUN apk update && \
    apk --no-cache add wget tar gzip zip bzip2 ca-certificates \
    python3 python3-dev py3-pip bzip2 file unzip curl

# Reinstall any system packages required for runtime.
RUN apk --no-cache add \
        gmp \
        libffi \
        lua5.3 \
        lua5.3-lpeg

# Install aws-cli.
RUN pip install awscli \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy pandoc from the build image.
COPY --from=build-pandoc /usr/local/bin/pandoc /usr/local/bin/pandoc-crossref /usr/local/bin/

# Make sure it is in the path.
ENV PATH $PATH:/usr/local/bin
