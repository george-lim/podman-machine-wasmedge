FROM fedora:38
RUN dnf -y install git libguestfs-tools
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
