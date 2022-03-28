FROM registry.access.redhat.com/ubi8/ubi:8.5
LABEL maintainer="Okky Hendriansyah <okky.htf@gmail.com>"

# Tool versions
ENV OC_VERSION=4.10.6

# Upgrade system
RUN dnf upgrade -y

# Install basic dependencies
RUN dnf install -y curl git

# Install container tools
RUN dnf install -y buildah skopeo podman

# Install OpenShift & Kubernetes CLI
RUN curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz
RUN tar xvvzpf openshift-client-linux.tar.gz
RUN install -o root -g root -m 0755 oc /usr/local/bin/oc
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN rm -f openshift-client-linux.tar.gz oc kubectl README.md

# # Prepare regular user dedicated for cicd
# RUN adduser cicd -u 1001
# USER 1001
# WORKDIR /home/cicd
