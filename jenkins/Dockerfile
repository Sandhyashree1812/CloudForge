FROM docker:cli AS docker-cli

FROM jenkins/jenkins:lts-jdk21

USER root

# Copy the official Docker CLI into Jenkins
COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker

USER jenkins