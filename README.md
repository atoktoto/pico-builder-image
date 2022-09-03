# Pico Builder Image

Github: https://github.com/atoktoto/pico-builder-image/

This docker image contains all dependencies required to build and debug code using Raspberry Pico SDK. 

This includes:
- Pico SDK
- Pico Extras
- Picotool
- Picoprobe
- FreeRTOS Kernel
- OpenOCD (with picoprobe support)

For convinience, it also includes:
- Pico Examples
- Pico Playground

## Debugging

To debug your RP2040, the docker container needs to have access to the USB device. 
The simplest way to allow the device to be used from inside of the docker container is to run in `--privileged` mode. 

On Windows you also have to use `usbipd` to attach the USB device to WSL2:
- `usbipd wsl list` to find the Picoprobe, and then
- `usbipd wsl attach --busid [ID]` to attach the device

The container needs to be started while the device is already attached or restarted after attaching the device.

## Usage with VSCode

To easily edit the code locally but build, debug and run inside container you can use [developer containers](https://code.visualstudio.com/docs/remote/containers).
To enable this in your project, create a `.devcontainer.json` file in a root of a project with the following contents:
```
{
  "image": "atoktoto/pico-builder:latest",
  "customizations": {
      "vscode": {
        "extensions": ["marus25.cortex-debug", "ms-vscode.cmake-tools", "ms-vscode.cpptools"]
      }
  },

  "runArgs": ["--privileged"]
}
```
