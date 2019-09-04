# ScratchBrowser
ScratchBrowser is an iOS application has web browser and [Scratch Link](https://github.com/LLK/scratch-link) function. You can use BLE devices in Scratch 3.0 on your iOS device.

## Requirements
- iOS 11 or higher
- iOS device supporting Bluetooth Low Energy (BLE)
- BLE device supported by Scratch 3.0

## How to build
1. Install [Xcode 10.3](https://developer.apple.com/xcode/)
2. Clone this repository with `ScratchLink/Sources/ScratchLink/scratch-link` submodule
3. Run `swift package resolve` command in `ScratchLink` directory
4. Put `scratch-device-manager.pem` somehow :sweat:
5. Open `ScratchBrowser.xcodeproj` and build

## ToDo
- [ ] Improve stability and error handlings
- [ ] Get rid of `Scratch` from the name
- [ ] Enable to change the URL of Scratch 3.0
- [ ] Enable to change the scale
- [ ] Support file loading and saving

## Demo
https://youtu.be/znrkpbhUhr8
