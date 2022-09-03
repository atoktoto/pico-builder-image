# Pico Builder Image

Github: https://github.com/atoktoto/pico-builder-image
Docker Hub: https://hub.docker.com/repository/docker/atoktoto/pico-builder

This docker image contains all dependencies required to build and debug code using Raspberry Pico SDK. 

This includes:
- [Pico SDK](https://github.com/raspberrypi/pico-sdk)
- [Pico Extras](https://github.com/raspberrypi/pico-extras)
- [Picotool](https://github.com/raspberrypi/picotool)
- [Picoprobe](https://github.com/raspberrypi/picoprobe)
- [FreeRTOS Kernel](https://github.com/FreeRTOS/FreeRTOS-Kernel)
- [OpenOCD](https://github.com/raspberrypi/openocd) (with picoprobe support)

For convinience, it also includes:
- [Pico Examples](https://github.com/raspberrypi/pico-examples)
- [Pico Playground](https://github.com/raspberrypi/pico-playground)

## Debugging

To debug your RP2040, the docker container needs to have access to the USB device. 
The simplest way to allow the device to be used from inside of the docker container is to run in `--privileged` mode. 

On Windows you also have to use `usbipd` to attach the USB device to WSL2:
- `usbipd wsl list` to find the Picoprobe, and then
- `usbipd wsl attach --busid [ID]` to attach the device

The container needs to be started while the device is already attached or restarted after attaching the device.

## Using with VSCode

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
