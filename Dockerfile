FROM  quay.io/containers/buildah:v1.23.1
LABEL maintainer="Okky Hendriansyah <okky.htf@gmail.com>"

# Tool versions;
ENV OC_VERSION=4.10.6

# Install basic dependencies
#RUN dnf install -y curl git

# Install additional container tools
RUN dnf install -y buildah skopeo podman

# Install OpenShift & Kubernetes CLI
RUN curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz \
 && tar xvvzpf openshift-client-linux.tar.gz \
 && install -o root -g root -m 0755 oc /usr/local/bin/oc \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && rm -f openshift-client-linux.tar.gz oc kubectl README.md

# https://github.com/containers/buildah/blob/main/docs/tutorials/05-openshift-rootless-build.md

# Prepare for container image building
RUN touch /etc/subgid /etc/subuid \
 && chmod g=u /etc/subgid /etc/subuid /etc/passwd \
 && echo build:10000:65536 > /etc/subuid \
 && echo build:10000:65536 > /etc/subgid

# Use chroot since the default runc does not work when running rootless
RUN echo "export BUILDAH_ISOLATION=chroot" >> /home/build/.bashrc

# Use VFS since fuse does not work
RUN mkdir -p /home/build/.config/containers \
 && (echo '[storage]';echo 'driver = "vfs"') > /home/build/.config/containers/storage.conf

USER build
WORKDIR /home/build

