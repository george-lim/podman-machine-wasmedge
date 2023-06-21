# podman-machine-wasmedge
Provides WasmEdge supported images for Podman’s virtual machine

```sh
podman build -t podman-machine-wasmedge .
podman run --rm -v $(pwd):/dist podman-machine-wasmedge

podman machine stop
podman machine rm
podman machine init --image-path fedora-coreos-*.qcow2
podman machine start
```
