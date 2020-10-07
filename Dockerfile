FROM fedora:31

LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"

RUN curl -o /etc/yum.repos.d/fedora.repo http://mirrors.aliyun.com/repo/fedora.repo && \
    curl -o /etc/yum.repos.d/fedora-updates.repo http://mirrors.aliyun.com/repo/fedora-updates.repo && \
    yum makecache

RUN dnf install -y dnf-plugins-core && \
    dnf copr enable -y @kubevirt/libvirt-6.6.0-2 && \
    dnf copr enable -y @kubevirt/qemu-5.1.0-5 && \
    dnf install -y \
      libvirt-daemon-driver-qemu-6.6.0-2.fc31 \
      libvirt-client-6.6.0-2.fc31 \
      libvirt-daemon-driver-storage-core-6.6.0-2.fc31 \
      qemu-kvm-5.1.0-5.fc31 \
      genisoimage \
      selinux-policy selinux-policy-targeted \
      nftables \
      iptables \
      augeas && \
    dnf update -y libgcrypt && \
    dnf clean all

COPY augconf /augconf
RUN augtool -f /augconf

COPY libvirtd.sh /libvirtd.sh
RUN chmod a+x /libvirtd.sh

RUN for qemu in /usr/bin/qemu-system-*; do setcap CAP_NET_BIND_SERVICE=+eip $qemu; done
# RUN setcap CAP_NET_BIND_SERVICE=+eip "/usr/libexec/qemu-kvm"

CMD ["/libvirtd.sh"]
