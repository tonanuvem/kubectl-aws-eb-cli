FROM ubuntu:latest

RUN sudo apt-get -y install unzip jq > /dev/null

# Python
RUN sudo add-apt-repository universe && \
    sudo apt-get install -y python3-pip > /dev/null && \
    python3 -m pip install --upgrade --force-reinstall pip && \
    sudo apt-get install -y python3-venv > /dev/null && \
    pip3 install --upgrade pip && \
    sudo ln -s /usr/bin/python3 /usr/bin/python
    
# AWS CLI
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && ./aws/install

# https://github.com/aws/aws-elastic-beanstalk-cli-setup
RUN pip3 install awsebcli cryptography==3.3.1 

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
