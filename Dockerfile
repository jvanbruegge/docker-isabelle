## Dockerfile for Isabelle2024

FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]

# packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
  apt-get install -y curl less libfontconfig1 libgomp1 openssh-client perl pwgen rlwrap && \
  apt-get clean

# user
RUN useradd -m isabelle && (echo isabelle:isabelle | chpasswd)
USER isabelle

# Isabelle
WORKDIR /home/isabelle
RUN curl -o Isabelle.tar.gz https://isabelle.in.tum.de/website-Isabelle2025-RC2/dist/Isabelle2025-RC2_linux.tar.gz && \
  tar xzf Isabelle.tar.gz && \
  mv Isabelle2025-RC2 Isabelle && \
  perl -pi -e 's,ISABELLE_HOME_USER=.*,ISABELLE_HOME_USER="\$USER_HOME/.isabelle",g;' Isabelle/etc/settings && \
  perl -pi -e 's,ISABELLE_LOGIC=.*,ISABELLE_LOGIC=HOL,g;' Isabelle/etc/settings && \
  Isabelle/bin/isabelle build -o system_heaps -b HOL && \
  rm Isabelle.tar.gz

ENTRYPOINT ["Isabelle/bin/isabelle"]
