  
FROM alpine:latest
ENV AWSCLI_VERSION "1.19.21"
RUN apk -v --no-cache --update add \
        python3 \
        py3-pip \
        groff \
        less \
        mailcap \
        curl \
        git \
        bash \
        jq \
        openssh-client \
        && \
    pip --no-cache-dir install --upgrade awscli==${AWSCLI_VERSION} && \
    apk -v --purge del py-pip && \
    rm -rf /var/cache/apk/*

# https://github.com/aws/aws-elastic-beanstalk-cli-setup
RUN apk --no-cache add --virtual .build-dependencies build-base python-dev libffi-dev openssl-dev && \
    git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git && \
    pip install virtualenv && \
    python aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py && \
    rm -rf aws-elastic-beanstalk-cli-setup /root/.cache && \
    apk del --purge .build-dependencies

# install CCAT
RUN curl -s https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz && \
    tar -zxvf linux-amd64-1.1.0.tar.gz && \
    chmod +x linux-amd64-1.1.0/ccat && \
    mv linux-amd64-1.1.0/ccat /usr/local/bin/ccat && \
    echo "alias cat='/usr/local/bin/ccat --bg=dark'" >> /etc/profile

VOLUME /root/.aws
VOLUME /root/.kube
VOLUME /fiap
WORKDIR /usr/local/bin/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 
RUN chmod +x /usr/local/bin/kubectl
WORKDIR /fiap
