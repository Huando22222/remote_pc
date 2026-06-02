# Development Log

## Current Debug Notes

### Auto-Connect

Auto-connect is temporarily disabled. The old startup auto-connect flow caused reconnect loops while the disconnect/navigation flow was still being stabilized.

The setting can stay in storage for now, but the connection screen does not automatically call connect on startup.

### Duplicate GlobalKey During Disconnect

Observed issue:

```text
Duplicate GlobalKey detected in widget tree
```

Current handling:

- GoRouter dynamic redirects were removed.
- Connection state navigation is handled by `ConnectionRouteListener` after the frame.
- Drawer disconnect waits for the drawer animation before disconnecting.
- Socket reconnection is disabled in the mobile socket client.

### Keyboard Text

Text input is sent as a JSON string containing UTF-8 base64:

```json
{"encoding":"utf8.base64","textBase64":"..."}
```

This avoids socket/parser issues with special characters such as `₫`, `%`, `&`, Vietnamese text, and emoji.

Backspace behavior:

- Deleting local text sends `keyboard_key = backspace`.
- An invisible sentinel allows the mobile keyboard to keep sending backspace even when the local text field is visually empty.
- The clear button only clears local text and does not delete remote text.

### Connected PC History

Connected PC history is stored in SharedPreferences as JSON under `connection_history`.

History is keyed by IP. When server device info arrives, the entry for the connected IP is updated with:

- device name
- platform
- OS version
- last seen time

### macOS Keyboard Target

The keyboard screen decides whether to show `Cmd` or `Win` based on the currently connected server device platform.

If Mac shows Windows controls, check:

1. `remoteDeviceProvider` was cleared before reconnect.
2. The server sent fresh device info.
3. The connected PC history did not update the wrong IP.

### File Upload Target IP

Mobile-to-desktop file upload now uses the actual connected IP from settings first, then falls back to the remote device IP.

This prevents upload requests from going to a stale device IP.
