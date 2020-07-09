FROM debian:stretch

RUN apt-get update && apt-get install -y wget curl git lsb-release sudo
#https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
ENV KUBECTL_VERSION=v1.16.0
ENV HELM_VERSION=v3.2.1
ENV HELM_LOCATION="https://get.helm.sh"
ENV HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    tar zxf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

RUN mkdir -p $(helm home)/plugins
RUN helm plugin install https://github.com/databus23/helm-diff --version 2.10.0+1
#ENV TARBALL_URL https://github.com/databus23/helm-diff/releases/download/v2.10.0%2B1/helm-diff-linux.tgz
#RUN wget -O- $TARBALL_URL | tar -C $(helm home)/plugins -xzv

#### helm-secrets not working with Alpine
####work around distro detection
RUN helm plugin install https://github.com/futuresimple/helm-secrets

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl


CMD ["helm"]
