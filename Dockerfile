FROM registry.fedoraproject.org/fedora:39

ENV NAME=fedora-toolbox VERSION=39

RUN dnf group install -y "C Development Tools and Libraries" "Development Tools"

COPY extras /
RUN dnf -y install $(<extras)
RUN rm /extras

RUN dnf clean all

# Install zoxide - https://github.com/ajeetdsouza/zoxide
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install kubectl
RUN cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install aws cli
RUN cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws

# install k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

COPY bin/ /usr/local/bin/
