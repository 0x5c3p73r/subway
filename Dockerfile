# syntax = docker/dockerfile:1.2
ARG VARIANT=3.0.3
FROM ruby:${VARIANT} as builder

# Install ruby on rails dependencies:
ARG BUILD_PACKAGES="gzip libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpam0g libpq5 libreadline-dev libreadline8 libsasl2-2 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libxml2 procps zlib1g"
ARG PROJECT_PACKAGES="sudo tar ca-certificates tzdata git zsh curl postgresql-client"
ARG APP_ROOT=/app

ARG REPLACE_CHINA_MIRROR="true"
ARG ORIGINAL_REPO_URL="deb.debian.org"
ARG MIRROR_REPO_URL="mirrors.ustc.edu.cn"
ARG RUBYGEMS_SOURCE="https://gems.ruby-china.com/"
ARG RUBY_GEMS="bundler:2.3.7"

ENV TZ="Asia/Shanghai" \
    BUNDLE_APP_CONFIG="$APP_ROOT/.bundle" \
    RAILS_ENV="production"

# System dependencies
RUN set -ex && \
    if [ "$REPLACE_CHINA_MIRROR" == "true" ]; then \
      sed -i "s/$ORIGINAL_REPO_URL/$MIRROR_REPO_URL/g" /etc/apt/sources.list && \
      gem sources --add $RUBYGEMS_SOURCE --remove https://rubygems.org/ && \
      bundle config mirror.https://rubygems.org $RUBYGEMS_SOURCE; \
    fi && \
    apt-get update -qq && apt-get install -y $BUILD_PACKAGES $PROJECT_PACKAGES && \
    gem install -N $RUBY_GEMS

WORKDIR $APP_ROOT

COPY Gemfile Gemfile.lock $APP_ROOT
RUN bundle config --global frozen 1 && \
    bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

COPY . $APP_ROOT

RUN --mount=type=secret,id=master_key,target=/app/config/master.key,required=true bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf docker tmp/cache spec .devcontainer .github .gitignore .gitattributes \
    .tool-versions Procfile.dev && \
    cd /app/vendor/bundle/ruby/3.0.0 && \
      rm -rf cache/*.gem && \
      find gems/ -name "*.c" -delete && \
      find gems/ -name "*.o" -delete

##################################################################################

FROM ruby:${VARIANT}

ARG BUILD_DATE
ARG VCS_REF

ARG SUBWAY_VERSION="0.1.0"
ARG REPLACE_CHINA_MIRROR="true"
ARG ORIGINAL_REPO_URL="deb.debian.org"
ARG MIRROR_REPO_URL="mirrors.ustc.edu.cn"
ARG RUBYGEMS_SOURCE="https://gems.ruby-china.com/"
ARG PROJECT_PACKAGES="openssl tzdata git postgresql-client"
ARG RUBY_GEMS="bundler:2.3.7"
ARG RAILS_SERVE_STATIC_FILES=true
ARG APP_ROOT=/app

LABEL org.opencontainers.image.title="Subway" \
      org.opencontainers.image.authors="0x5c3p73r <0x5c3p73r@gmail.com>" \
      org.opencontainers.image.source="https://github.com/0x5c3p73r/subway" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.version=$SUBWAY_VERSION

ENV TZ="Asia/Shanghai" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    BUNDLE_APP_CONFIG="$APP_ROOT/.bundle" \
    RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES} \
    RAILS_LOG_TO_STDOUT=true \
    SUBWAY_VCS_REF="$VCS_REF" \
    SUBWAY_VERSION="$SUBWAY_VERSION" \
    SUBWAY_BUILD_DATE="$BUILD_DATE"

# System dependencies
RUN set -ex && \
    if [ "$REPLACE_CHINA_MIRROR" == "true" ]; then \
      sed -i "s/$ORIGINAL_REPO_URL/$MIRROR_REPO_URL/g" /etc/apt/sources.list && \
      gem sources --add $RUBYGEMS_SOURCE --remove https://rubygems.org/ && \
      bundle config mirror.https://rubygems.org $RUBYGEMS_SOURCE; \
    fi && \
    apt-get update -qq && apt-get install -y $PROJECT_PACKAGES && \
    gem install -N $RUBY_GEMS

ARG S6_OVERLAY_VERSION="3.1.2.1"
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

WORKDIR $APP_ROOT

COPY docker/rootfs /
COPY --from=builder $APP_ROOT $APP_ROOT

RUN ln -s /app/bin/rails /usr/local/bin/

EXPOSE 3000

ENTRYPOINT ["/init"]
