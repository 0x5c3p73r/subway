# syntax = docker/dockerfile:1.3
ARG VARIANT=3.2.2

FROM alpine:3.17 as s6overlay-builder

# install packages
RUN apk add --no-cache xz

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="3.1.5.0"
ARG S6_OVERLAY_ARCH="x86_64"

RUN set -ex && \
    mkdir /root-out && \
    echo "Setting variables for ${TARGETARCH}" && \
    case "$TARGETARCH" in \
    "amd64") \
      S6_OVERLAY_ARCH="x86_64" \
    ;; \
    "arm64") \
      S6_OVERLAY_ARCH="aarch64" \
    ;; \
    "linux/arm/v7" | "arm") \
      S6_OVERLAY_ARCH="arm" \
    ;; \
    *) \
        echo "Doesn't support $TARGETARCH architecture" \
        exit 1 \
    ;; \
    esac

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

# add s6 optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

# builder stage
FROM ruby:${VARIANT} as builder

# Install ruby on rails dependencies:
ARG BUILD_PACKAGES="libpq-dev yarnpkg git zlib1g-dev build-essential libssl-dev libreadline-dev \
                    libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev \
                    software-properties-common libffi-dev"
ARG PROJECT_PACKAGES="sudo tar ca-certificates tzdata git zsh curl postgresql-client"
ARG APP_ROOT=/app

ARG ENABLE_DEBIAN_MIRROR="true"
ARG ORIGINAL_REPO_URL="deb.debian.org"
ARG MIRROR_REPO_URL="mirrors.ustc.edu.cn"
ARG RUBYGEMS_SOURCE="https://gems.ruby-china.com/"
ARG RUBY_GEMS="bundler:2.4.21"

ENV TZ="Asia/Shanghai" \
    BUNDLE_APP_CONFIG="$APP_ROOT/.bundle" \
    RAILS_ENV="production"

# System dependencies
RUN set -ex && \
    if [ "$ENABLE_DEBIAN_MIRROR" == "true" ]; then \
      sed -i "s/$ORIGINAL_REPO_URL/$MIRROR_REPO_URL/g" /etc/apt/sources.list.d/debian.sources && \
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

RUN --mount=type=secret,id=master_key,target=/app/config/master.key,required=true \
    --mount=type=secret,id=credentials_data,target=/app/config/credentials.yml.enc,required=true \
    bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf docker tmp/cache spec .devcontainer .github .gitignore .gitattributes \
    .tool-versions Procfile.dev && \
    cd /app/vendor/bundle/ruby/3.2.0 && \
      rm -rf cache/*.gem && \
      find gems/ -name "*.c" -delete && \
      find gems/ -name "*.o" -delete

# runtime stage
FROM ruby:${VARIANT}-slim

ARG ENABLE_DEBIAN_MIRROR="true"
ARG ORIGINAL_REPO_URL="deb.debian.org"
ARG MIRROR_REPO_URL="mirrors.ustc.edu.cn"
ARG RUBYGEMS_SOURCE="https://gems.ruby-china.com/"
ARG PROJECT_PACKAGES="openssl tzdata git postgresql-client xz-utils"
ARG RUBY_GEMS="bundler:2.4.21"
ARG RAILS_SERVE_STATIC_FILES=true
ARG APP_ROOT=/app

ENV TZ="Asia/Shanghai" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_VERBOSITY=1 \
    BUNDLE_APP_CONFIG="$APP_ROOT/.bundle" \
    RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES} \
    RAILS_LOG_TO_STDOUT=true

# System dependencies
RUN set -ex && \
    if [ "$ENABLE_DEBIAN_MIRROR" == "true" ]; then \
      sed -i "s/$ORIGINAL_REPO_URL/$MIRROR_REPO_URL/g" /etc/apt/sources.list.d/debian.sources && \
      gem sources --add $RUBYGEMS_SOURCE --remove https://rubygems.org/ && \
      bundle config mirror.https://rubygems.org $RUBYGEMS_SOURCE; \
    fi && \
    apt-get update -qq && apt-get install -y $PROJECT_PACKAGES && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    gem install -N $RUBY_GEMS

WORKDIR $APP_ROOT

COPY --from=s6overlay-builder /root-out/ /
COPY docker/rootfs /
COPY --from=builder $APP_ROOT $APP_ROOT

RUN ln -s /app/bin/rails /usr/local/bin/

EXPOSE 3000

ENTRYPOINT ["/init"]
