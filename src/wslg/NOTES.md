## Requirements

This Feature is intended for dev containers running in WSL 2 with Docker Desktop and WSLg enabled. It expects the host to provide:

- `/usr/lib/wsl`
- `/mnt/host/wslg`

Those paths are bind-mounted into the container by the Feature metadata.

## Ubuntu Package Installation

The installer currently installs packages only on Ubuntu-based images:

- `mesa-utils`
- `mesa-vulkan-drivers`
- `vulkan-tools`

On non-Ubuntu images, the install script exits without installing packages. The Feature metadata still applies the WSLg mounts, environment variables, and post-create command.

## Mesa and Vulkan Notes

The Feature sets `GALLIUM_DRIVER=d3d12` to use D3D12 Mesa's Gallium backend driver.

For the `dzn` Vulkan-to-D3D12 driver, Mesa 26.0 or later is required. The optional `useKisakPpa` setting adds the kisak Mesa PPA before installing Mesa and Vulkan packages:

```jsonc
{
  "features": {
    "ghcr.io/silenaker/devcontainer-features/wslg:1": {
      "useKisakPpa": true
    }
  }
}
```

The kisak Mesa PPA publishes packages for Ubuntu Noble 24.04 and later. If you need newer Mesa or `dzn` support, use an Ubuntu 24.04 or newer base image, for example:

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04"
}
```
