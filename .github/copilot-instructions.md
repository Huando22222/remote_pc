# PC Remote - Copilot Instructions

## Project Overview
**PC Remote** is a Flutter cross-platform application that enables remote desktop control through a socket-based communication protocol. The app runs on mobile/desktop platforms and communicates with a PC server over TCP sockets at port 4040.

### Key Technologies
- **Framework**: Flutter 3.11+ (Dart 3.11+)
- **State Management**: Flutter Riverpod 3.2.1
- **Networking**: socket_io_client 3.1.4, raw TCP sockets
- **Native Integration**: Method channels for mouse/keyboard control

---

## Architecture Overview

### Feature-Based Clean Architecture
The project follows **Clean Architecture with feature isolation**:

```
lib/
├── core/                          # Shared infrastructure
│   ├── native/                    # Platform-specific APIs via method channels
│   │   └── native_mouse_datasource.dart  # Delegates to native mouse control
│   ├── network/                   # Network services
│   │   ├── ip_service.dart        # Local IP discovery (IPv4, excludes loopback)
│   │   └── socket_server.dart     # TCP server binding at 0.0.0.0:4040
│   └── providers/                 # Core Riverpod providers
│       └── core_providers.dart    # Shared providers (IpService, localIp)
└── features/                      # Feature modules (isolated by domain)
    ├── connection/                # Connection establishment & QR code display
    │   └── presentation/
    │       ├── pages/
    │       │   └── desktop_home_page.dart  # QR code UI for IP:4040
    │       └── providers/
    └── remote_control/            # Remote control operations (mouse, keyboard)
        ├── domain/
        │   ├── entities/
        │   │   └── mouse_move.dart  # Data model: dx, dy
        │   ├── repositories/        # Abstract interfaces
        │   │   └── remote_repository.dart  # moveMouse(MouseMove), click()
        │   └── usecases/
        │       └── move_mouse_usecase.dart  # Call(dx, dy) -> repository.moveMouse()
        ├── data/
        │   ├── datasources/        # Platform-specific implementations
        │   └── repositories/
        │       └── remote_repository_impl.dart  # Concrete impl using NativeMouseDatasource
        └── presentation/
            ├── pages/
            ├── widgets/
            └── providers/
                └── remote_providers.dart  # Dependency graph: datasource → repo → usecase → socket_server
```

### Data Flow for Remote Commands
1. **Socket Server** (port 4040) receives TCP messages (e.g., "move", "click")
2. **MoveMouseUseCase** is invoked with dx, dy parameters
3. **RemoteRepository** abstracts over platform implementation
4. **NativeMouseDatasource** invokes native code via MethodChannel `'remote.control'`

---

## Critical Developer Workflows

### Build & Run
```bash
# Debug build (all platforms)
flutter run

# iOS-specific
flutter run -d iphone

# Android-specific
flutter run -d android

# Desktop (Linux/macOS/Windows) - select device
flutter devices
flutter run -d <device_id>
```

### Testing & Analysis
```bash
# Static analysis
flutter analyze

# Format code (uses flutter_lints)
dart format lib/

# Run tests
flutter test
```

### Hot Reload
- **Hot Reload** (Shift+R): Updates UI/logic without app restart; preserves state
- **Hot Restart** (Shift+Ctrl+R): Full app restart; clears state
- Socket connections may require restart after code changes

---

## Key Conventions & Patterns

### 1. Riverpod Provider Dependency Injection
All dependencies flow through providers. Example from `remote_providers.dart`:
```dart
final nativeDatasourceProvider = Provider((ref) => NativeMouseDatasource());
final remoteRepositoryProvider = Provider(
  (ref) => RemoteRepositoryImpl(ref.read(nativeDatasourceProvider)),
);
```
- **Use `ref.read()` for providers** inside other providers (not in widgets)
- **Use `ref.watch()` in widgets** (ConsumerWidget/ConsumerStatefulWidget)
- **Never instantiate service classes directly**; always declare a provider first

### 2. Feature Module Isolation
Each feature (`connection/`, `remote_control/`) is independent:
- Features should not import from other features directly; use providers or interfaces
- Place Riverpod providers in `presentation/providers/` for feature-level state
- Core utilities go in `lib/core/` only

### 3. Native Platform Integration
Mouse control uses MethodChannel `'remote.control'`:
```dart
// In NativeMouseDatasource
static const _channel = MethodChannel('remote.control');
await _channel.invokeMethod('moveMouse', {'dx': dx, 'dy': dy});
```
- **Native implementations** required in native code (Kotlin for Android, Swift for iOS, etc.)
- Channel name `'remote.control'` must match native platform setup
- Always use Future-based async for cross-platform compatibility

### 4. Socket Communication Protocol
- **Server**: Listens at `0.0.0.0:4040` (all interfaces)
- **Messages**: Plain text (e.g., "move", "click")
- **TODO**: Message protocol is incomplete (see TODOs in `socket_server.dart`)
- Clients connect from mobile device to PC via QR code (displays `IP:4040`)

### 5. Async/Await Patterns
All async operations use `Future<T>`:
```dart
// ✓ Correct
Future<void> moveMouse(double dx, double dy) async { }

// All network/native calls must be awaited
await datasource.moveMouse(20, 0);
```

---

## Important Cross-File Integration Points

### IP Discovery → Socket Server → Remote Control
1. **IpService.getLocalIp()** → gets device IP (excludes loopback)
2. **SocketServer.start()** → binds TCP server, listens for commands
3. **MoveMouseUseCase** → processes "move" command into native call

### QR Code UI Integration
`desktop_home_page.dart` displays QR code encoding `$ip:4040`:
- Fetches IP via `localIpProvider` (Riverpod FutureProvider)
- Updates when network changes (FutureProvider auto-rebuilds)

---

## Development Tips

### Adding a New Remote Command
1. Create usecase in `remote_control/domain/usecases/` (e.g., `click_usecase.dart`)
2. Add method to `RemoteRepository` abstract class
3. Implement in `RemoteRepositoryImpl` → calls `NativeMouseDatasource`
4. Add provider in `remote_control/presentation/providers/remote_providers.dart`
5. Add handler in `SocketServer.start()` for new message type
6. Implement native code for each platform

### Debugging Socket Communication
- Server logs connect/messages to console: `print("Server started at...")`
- Use `flutter run` with `-v` flag for verbose output
- TCP traffic inspection on port 4040: `lsof -i :4040`

---

## Platform-Specific Notes

- **Android/iOS**: Use `flutter_test` for unit tests; native code requires separate testing
- **Desktop (Linux/macOS/Windows)**: Platform plugins may need native library linking
- **iOS/macOS**: Review Info.plist for network access permissions

---

## Common Pitfalls

❌ **Don't** import features from other features  
❌ **Don't** instantiate providers manually (e.g., `MoveMouseUseCase()` directly)  
❌ **Don't** use `ref.read()` in widget build (use `ref.watch()`)  
❌ **Don't** modify socket server without understanding protocol contract  

✅ **Do** use providers consistently for DI  
✅ **Do** keep features modular and independent  
✅ **Do** test usecases and repositories independently  
