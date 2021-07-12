# 
# Reference considered from Docker file for fluentd elastic amd mongo
# https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/docker-image/v1.9/debian-elasticsearch7/Dockerfile
# https://github.com/nec-baas/docker-fluentd-mongo/
#
# base fluentd:v1.4 image docker file
# https://github.com/fluent/fluentd-docker-image/blob/master/v1.4/alpine/Dockerfile
#
#
#
# FROM fluent/fluentd:v1.4
# 
# USER root
# # add mongo plugin
# RUN apk add --no-cache bash make gcc libc-dev ruby-dev \
#     && gem install fluent-plugin-mongo \
#     && apk del make gcc libc-dev ruby-dev \
#     && rm -rf /var/cache/apk/* \
#     && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
# 
# # Overwrite ENTRYPOINT to run fluentd as root for /var/log / /var/lib
# ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
# CMD ["fluentd"]
#
#
# Fluentd with mongo
# https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v1.9/debian-forward
# kubernetes daemonset has preinstalled kubernetes filter plugins that fetches information like podID, namespace, nodeName and others
#
#
FROM fluent/fluentd-kubernetes-daemonset:v1.9-debian-forward-1

USER root

RUN buildDeps="sudo make gcc g++ libc-dev libffi-dev" \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends $buildDeps net-tools \
    && gem install fluent-plugin-mongo
    && SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && gem sources --clear-all \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
