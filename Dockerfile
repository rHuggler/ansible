FROM ubuntu:jammy AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS huggler
RUN addgroup --gid 1000 huggler
RUN adduser --gecos huggler --uid 1000 --gid 1000 --disabled-password huggler
RUN usermod -aG sudo huggler
RUN echo huggler:1234 | chpasswd
USER huggler
WORKDIR /home/huggler

FROM huggler
ARG TAGS
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS setup.yml"]

