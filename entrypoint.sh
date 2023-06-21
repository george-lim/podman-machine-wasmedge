#!/bin/bash

set -e

image_url=$(
    curl -sSf https://builds.coreos.fedoraproject.org/streams/stable.json \
        | jq ".architectures.$(uname -m).artifacts.qemu.formats.\"qcow2.xz\".disk.location" \
        | xargs
)

image_path="/dist/$(basename -s .xz $image_url)"

curl -sSfL $image_url | unxz > $image_path
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr

deploy=$(
    LIBGUESTFS_BACKEND=direct guestfish -a $image_path -m /dev/sda4 ls /ostree/deploy/fedora-coreos/deploy \
        | head -n 1
)

root_path="/ostree/deploy/fedora-coreos/deploy/$deploy"

LIBGUESTFS_BACKEND=direct guestfish -a $image_path -m /dev/sda4 << END
upload /usr/lib/libwasmedge.so $root_path/usr/lib/libwasmedge.so.0.0.0
ln-s /usr/lib/libwasmedge.so.0.0.0 $root_path/usr/lib/libwasmedge.so.0
ln-s /usr/lib/libwasmedge.so.0.0.0 $root_path/usr/lib/libwasmedge.so
command "$root_path/sbin/ldconfig -r $root_path"
END
