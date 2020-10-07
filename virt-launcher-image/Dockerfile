FROM kubevirt/virt-launcher@sha256:9ac34444fa8aa08a70a3ccc2009766473bdd5ae706f75dddb36513d63f2eacb2 AS binary-base

FROM registry.cn-shanghai.aliyuncs.com/droidvirt/libvirt:qemu-5.1.0-5

WORKDIR /usr/bin

COPY --from=binary-base /.version /.version

COPY --from=binary-base /usr/bin/virt-launcher /usr/bin/virt-launcher

COPY --from=binary-base /usr/bin/container-disk /usr/bin/container-disk

ENTRYPOINT ["/usr/bin/virt-launcher"]

