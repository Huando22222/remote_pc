# Remote PC Mobile

Remote PC Mobile is the phone client for controlling a desktop computer over the local network. It connects to Remote PC Server and provides touchpad, keyboard, and file transfer tools.

## Features

- Connect to a desktop by IP address.
- Scan the server QR code for faster setup.
- Keep a history of connected PCs for quick reconnection.
- Touchpad controls:
  - mouse move
  - left click
  - right click
  - double click
  - drag
  - two-finger scroll
  - three-finger swipe
- Keyboard controls:
  - realtime text input
  - Unicode and Vietnamese text support
  - common keys
  - function keys
  - modifier combinations
  - mobile keyboard backspace and enter forwarding
- File transfer:
  - receive files from desktop
  - send selected files to desktop
  - open, share, and save downloaded files
- Settings:
  - language
  - mouse sensitivity
  - scroll sensitivity

## Basic Usage

1. Start Remote PC Server on the desktop computer.
2. Make sure the phone and desktop are on the same local network.
3. Open Remote PC Mobile.
4. Enter the desktop IP address or scan the QR code from the server.
5. Use Touchpad, Keyboard, or File Transfer after connecting.

## Connected PC History

The connection screen includes a connected PC list. Tap a saved PC to fill its IP address and connect quickly.

Device information is updated by IP when the server sends new device metadata.

## Keyboard Notes

Realtime text input sends text as UTF-8 base64 JSON to avoid socket issues with special characters. Physical keys and shortcuts are sent as separate keyboard events.

Mobile keyboard backspace is forwarded even when the local text field is visually empty.

## File Transfer Notes

Downloaded files are shown on the connection screen. Tap the downloaded files entry to open the file list and choose available actions.

## Notes

- Auto-connect is temporarily disabled while the reconnect flow is being stabilized.
- Clipboard features are intentionally hidden until they are production-ready.
- Troubleshooting notes and implementation logs live in `DEVELOPMENT_LOG.md`.
