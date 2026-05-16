# Dev Container Features

This repository publishes dev container Features for the `silenaker/devcontainer-features` collection.

## Features

### `wslg`

Enables WSLg GUI and GPU acceleration support inside a dev container running under WSL 2 with Docker Desktop.

The Feature:

- bind-mounts the host WSL libraries from `/usr/lib/wsl` into the container
- bind-mounts WSLg runtime files from `/mnt/host/wslg` to `/mnt/wslg`
- configures `DISPLAY`, `WAYLAND_DISPLAY`, `XDG_RUNTIME_DIR`, `LD_LIBRARY_PATH`, and `GALLIUM_DRIVER`
- links `/tmp/.X11-unix` to the WSLg X11 socket directory after container creation
- installs `mesa-utils`, `mesa-vulkan-drivers`, and `vulkan-tools` on Ubuntu images
- optionally enables the kisak Mesa PPA for newer Mesa and Vulkan packages

Example `devcontainer.json`:

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/silenaker/devcontainer-features/wslg:1": {
      "useKisakPpa": true
    }
  }
}
```

After the container is created, GUI and GPU tools such as `glxinfo`, `glxgears`, and `vulkaninfo` can be used for smoke testing, depending on the installed packages and host support.

## Options

| Feature | Option        | Type    | Default | Description                                                         |
| ------- | ------------- | ------- | ------- | ------------------------------------------------------------------- |
| `wslg`  | `useKisakPpa` | boolean | `false` | Adds the kisak Mesa PPA before installing Mesa and Vulkan packages. |

## Runtime Assumptions

This collection is currently focused on WSL 2 + Docker Desktop. The `wslg` Feature relies on host paths that are provided by WSLg and mounted into Docker Desktop containers:

- `/usr/lib/wsl`
- `/mnt/host/wslg`

The install script only installs packages on Ubuntu-based images. Other distributions are left unchanged by the installer, although the Feature metadata still contributes the mounts, environment variables, and post-create command.

## Validation and Release

The repository includes GitHub Actions workflows for:

- validating Feature metadata with `devcontainers/action`
- publishing Features to GitHub Container Registry
- generating per-Feature documentation from `devcontainer-feature.json` and `NOTES.md`

Releases are published manually via the release workflow on the `main` branch.
