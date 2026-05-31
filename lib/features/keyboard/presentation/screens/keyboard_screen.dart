import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pc_remote/core/theme/app_spacing.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';
import 'package:pc_remote/features/keyboard/domain/usecases/send_keyboard_key_usecase.dart';
import 'package:pc_remote/features/keyboard/domain/usecases/send_keyboard_shortcut_usecase.dart';
import 'package:pc_remote/features/keyboard/domain/usecases/send_keyboard_text_usecase.dart';

class KeyboardScreen extends ConsumerStatefulWidget {
  const KeyboardScreen({super.key});

  @override
  ConsumerState<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends ConsumerState<KeyboardScreen> {
  final _textController = TextEditingController();
  final Set<String> _heldKeys = {};
  String _lastRealtimeText = '';
  bool _ignoreNextTextChange = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onRealtimeTextChanged(String value) async {
    if (_ignoreNextTextChange) {
      _ignoreNextTextChange = false;
      _lastRealtimeText = value;
      return;
    }

    final previous = _lastRealtimeText;
    _lastRealtimeText = value;

    if (value == previous) return;

    if (value.length > previous.length && value.startsWith(previous)) {
      final inserted = value.substring(previous.length);
      if (inserted.isNotEmpty) {
        await ref.read(sendKeyboardTextUseCaseProvider)(inserted);
      }
      return;
    }

    if (value.length < previous.length && previous.startsWith(value)) {
      final deleteCount = previous.length - value.length;
      final sendKey = ref.read(sendKeyboardKeyUseCaseProvider);
      for (var i = 0; i < deleteCount; i++) {
        await sendKey('backspace');
      }
    }
  }

  void _clearLocalText() {
    _ignoreNextTextChange = true;
    _textController.clear();
    _lastRealtimeText = '';
  }

  void _toggleHeldKey(String key) {
    setState(() {
      if (_heldKeys.contains(key)) {
        _heldKeys.remove(key);
      } else {
        _heldKeys.add(key);
      }
    });
  }

  void _clearHeldKeys() {
    setState(_heldKeys.clear);
  }

  Future<void> _releaseHeldKeys() async {
    if (_heldKeys.isEmpty) return;

    final keys = _orderedHeldKeys();
    _clearHeldKeys();

    if (keys.length == 1) {
      await ref.read(sendKeyboardKeyUseCaseProvider)(keys.first);
      return;
    }

    await ref.read(sendKeyboardShortcutUseCaseProvider)(keys);
  }

  List<String> _orderedHeldKeys() {
    const modifierOrder = ['ctrl', 'alt', 'shift', 'cmd', 'win'];
    final modifiers = [
      for (final key in modifierOrder)
        if (_heldKeys.contains(key)) key,
    ];
    final normalKeys = [
      for (final key in _heldKeys)
        if (!modifierOrder.contains(key)) key,
    ];

    return [...modifiers, ...normalKeys];
  }

  @override
  Widget build(BuildContext context) {
    final remoteDevices = ref.watch(remoteDeviceProvider);
    final serverPlatform = remoteDevices.firstOrNull?.platform.toLowerCase();
    final isMac = serverPlatform == 'macos' || serverPlatform == 'darwin';
    final metaKey = isMac ? 'cmd' : 'win';
    final metaLabel = isMac ? 'Cmd' : 'Win';
    final metaIcon =
        isMac ? Icons.keyboard_command_key_rounded : FontAwesomeIcons.windows;

    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                children: [
                  _Header(platformLabel: isMac ? 'macOS' : 'Windows'),
                  const SizedBox(height: AppSpacing.md),
                  _RealtimeTextPanel(
                    controller: _textController,
                    onChanged: _onRealtimeTextChanged,
                    onClear: _clearLocalText,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _HoldPanel(
                    heldKeys: _heldKeys,
                    metaKey: metaKey,
                    metaLabel: metaLabel,
                    metaIcon: metaIcon,
                    onToggle: _toggleHeldKey,
                    onClear: _clearHeldKeys,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _KeySection(
                    title: 'Editing keys',
                    keys: const [
                      _KeyboardKey('A', 'a', Icons.text_fields_rounded),
                      _KeyboardKey('C', 'c', Icons.content_copy_rounded),
                      _KeyboardKey('V', 'v', Icons.content_paste_rounded),
                      _KeyboardKey('X', 'x', Icons.content_cut_rounded),
                      _KeyboardKey('Z', 'z', Icons.undo_rounded),
                      _KeyboardKey('Y', 'y', Icons.redo_rounded),
                    ],
                    heldKeys: _heldKeys,
                    onToggle: _toggleHeldKey,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _KeySection(
                    title: 'Common keys',
                    keys: const [
                      _KeyboardKey('Esc', 'escape', FontAwesomeIcons.eject),
                      _KeyboardKey('Tab', 'tab', FontAwesomeIcons.rightLeft),
                      _KeyboardKey('Shot', 'printScreen',
                          Icons.screenshot_monitor_rounded),
                      _KeyboardKey(
                          'Back', 'backspace', Icons.backspace_rounded),
                      _KeyboardKey(
                          'Del', 'delete', Icons.delete_outline_rounded),
                      _KeyboardKey(
                          'Enter', 'enter', Icons.keyboard_return_rounded),
                      _KeyboardKey('Space', 'space', Icons.space_bar_rounded),
                    ],
                    heldKeys: _heldKeys,
                    onToggle: _toggleHeldKey,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _NavigationSection(
                    heldKeys: _heldKeys,
                    onToggle: _toggleHeldKey,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FunctionKeySection(
                    heldKeys: _heldKeys,
                    onToggle: _toggleHeldKey,
                  ),
                ],
              ),
            ),
            _ReleaseBar(
              heldKeys: _heldKeys,
              metaKey: metaKey,
              metaLabel: metaLabel,
              onRelease: _releaseHeldKeys,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.platformLabel});

  final String platformLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            Icons.keyboard_rounded,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keyboard',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Target: $platformLabel',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RealtimeTextPanel extends StatelessWidget {
  const _RealtimeTextPanel({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Realtime typing',
      trailing: IconButton(
        onPressed: onClear,
        icon: const Icon(Icons.clear_rounded),
        tooltip: 'Clear local text',
      ),
      child: TextField(
        controller: controller,
        minLines: 2,
        maxLines: 4,
        onChanged: onChanged,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(
          hintText: 'Text is sent while you type',
          prefixIcon: Icon(Icons.text_fields_rounded),
        ),
      ),
    );
  }
}

class _HoldPanel extends StatelessWidget {
  const _HoldPanel({
    required this.heldKeys,
    required this.metaKey,
    required this.metaLabel,
    required this.metaIcon,
    required this.onToggle,
    required this.onClear,
  });

  final Set<String> heldKeys;
  final String metaKey;
  final String metaLabel;
  final IconData metaIcon;
  final ValueChanged<String> onToggle;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final modifiers = [
      _KeyboardKey('Ctrl', 'ctrl', FontAwesomeIcons.sliders),
      _KeyboardKey('Alt', 'alt', FontAwesomeIcons.circleNodes),
      _KeyboardKey('Shift', 'shift', FontAwesomeIcons.arrowUp),
      _KeyboardKey(metaLabel, metaKey, metaIcon),
    ];

    return _Panel(
      title: heldKeys.isEmpty ? 'Hold keys' : heldKeys.map(_label).join(' + '),
      trailing: heldKeys.isEmpty
          ? null
          : TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear_rounded, size: AppSpacing.iconSm),
              label: const Text('Clear'),
            ),
      child: Row(
        children: [
          for (final item in modifiers) ...[
            Expanded(
              child: _SelectableKeyButton(
                label: item.label,
                icon: item.icon,
                selected: heldKeys.contains(item.key),
                onPressed: () => onToggle(item.key),
              ),
            ),
            if (item != modifiers.last) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  String _label(String key) {
    if (key == metaKey) return metaLabel;
    return switch (key) {
      'ctrl' => 'Ctrl',
      'alt' => 'Alt',
      'shift' => 'Shift',
      'escape' => 'Esc',
      'backspace' => 'Back',
      'delete' => 'Del',
      'pageUp' => 'Pg Up',
      'pageDown' => 'Pg Dn',
      _ => key.toUpperCase(),
    };
  }
}

class _ReleaseBar extends StatelessWidget {
  const _ReleaseBar({
    required this.heldKeys,
    required this.metaKey,
    required this.metaLabel,
    required this.onRelease,
  });

  final Set<String> heldKeys;
  final String metaKey;
  final String metaLabel;
  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedLabel = heldKeys.isEmpty
        ? 'No keys selected'
        : heldKeys.map(_label).join(' + ');

    return Material(
      color: colorScheme.surface,
      elevation: 8,
      shadowColor: colorScheme.shadow.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: heldKeys.isEmpty
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      fontWeight:
                          heldKeys.isEmpty ? FontWeight.w500 : FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            FilledButton.icon(
              onPressed: heldKeys.isEmpty ? null : onRelease,
              icon: const Icon(Icons.keyboard_double_arrow_down_rounded),
              label: const Text('Release'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(132, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(String key) {
    if (key == metaKey) return metaLabel;
    return switch (key) {
      'ctrl' => 'Ctrl',
      'alt' => 'Alt',
      'shift' => 'Shift',
      'escape' => 'Esc',
      'backspace' => 'Back',
      'delete' => 'Del',
      'pageUp' => 'Pg Up',
      'pageDown' => 'Pg Dn',
      _ => key.toUpperCase(),
    };
  }
}

class _KeySection extends StatelessWidget {
  const _KeySection({
    required this.title,
    required this.keys,
    required this.heldKeys,
    required this.onToggle,
  });

  final String title;
  final List<_KeyboardKey> keys;
  final Set<String> heldKeys;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: title,
      child: _GeneratedKeyRows(
        keys: keys,
        columnCount: 3,
        heldKeys: heldKeys,
        onToggle: onToggle,
      ),
    );
  }
}

class _NavigationSection extends StatelessWidget {
  const _NavigationSection({
    required this.heldKeys,
    required this.onToggle,
  });

  final Set<String> heldKeys;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final sideKeys = const [
      _KeyboardKey('Home', 'home', Icons.first_page_rounded),
      _KeyboardKey('End', 'end', Icons.last_page_rounded),
      _KeyboardKey('Pg Up', 'pageUp', Icons.keyboard_double_arrow_up_rounded),
      _KeyboardKey(
          'Pg Dn', 'pageDown', Icons.keyboard_double_arrow_down_rounded),
    ];

    return _Panel(
      title: 'Navigation',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                for (final item in sideKeys) ...[
                  _SelectableKeyButton(
                    label: item.label,
                    icon: item.icon,
                    selected: heldKeys.contains(item.key),
                    onPressed: () => onToggle(item.key),
                  ),
                  if (item != sideKeys.last)
                    const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 208,
            child: Column(
              children: [
                _ArrowKey(
                  icon: Icons.keyboard_arrow_up_rounded,
                  selected: heldKeys.contains('arrowUp'),
                  onPressed: () => onToggle('arrowUp'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ArrowKey(
                      icon: Icons.keyboard_arrow_left_rounded,
                      selected: heldKeys.contains('arrowLeft'),
                      onPressed: () => onToggle('arrowLeft'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ArrowKey(
                      icon: Icons.keyboard_arrow_down_rounded,
                      selected: heldKeys.contains('arrowDown'),
                      onPressed: () => onToggle('arrowDown'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ArrowKey(
                      icon: Icons.keyboard_arrow_right_rounded,
                      selected: heldKeys.contains('arrowRight'),
                      onPressed: () => onToggle('arrowRight'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FunctionKeySection extends StatelessWidget {
  const _FunctionKeySection({
    required this.heldKeys,
    required this.onToggle,
  });

  final Set<String> heldKeys;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final keys = List.generate(
      12,
      (index) => _KeyboardKey('F${index + 1}', 'f${index + 1}', Icons.keyboard),
    );

    return _Panel(
      title: 'Function keys',
      child: _GeneratedKeyRows(
        keys: keys,
        columnCount: 4,
        heldKeys: heldKeys,
        onToggle: onToggle,
        compact: true,
      ),
    );
  }
}

class _GeneratedKeyRows extends StatelessWidget {
  const _GeneratedKeyRows({
    required this.keys,
    required this.columnCount,
    required this.heldKeys,
    required this.onToggle,
    this.compact = false,
  });

  final List<_KeyboardKey> keys;
  final int columnCount;
  final Set<String> heldKeys;
  final ValueChanged<String> onToggle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rowCount = (keys.length / columnCount).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        final start = rowIndex * columnCount;
        final rowKeys = keys.skip(start).take(columnCount).toList();

        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex == rowCount - 1 ? 0 : AppSpacing.sm,
          ),
          child: Row(
            children: List.generate(columnCount, (columnIndex) {
              if (columnIndex >= rowKeys.length) {
                return const Expanded(child: SizedBox.shrink());
              }

              final item = rowKeys[columnIndex];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: columnIndex == columnCount - 1 ? 0 : AppSpacing.sm,
                  ),
                  child: _SelectableKeyButton(
                    label: item.label,
                    icon: item.icon,
                    selected: heldKeys.contains(item.key),
                    onPressed: () => onToggle(item.key),
                    compact: compact,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _SelectableKeyButton extends StatelessWidget {
  const _SelectableKeyButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppSpacing.iconSm),
      label: FittedBox(child: Text(label)),
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(compact ? 44 : 50),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        backgroundColor: selected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        foregroundColor:
            selected ? colorScheme.onPrimary : colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}

class _ArrowKey extends StatelessWidget {
  const _ArrowKey({
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 64,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          foregroundColor:
              selected ? colorScheme.onPrimary : colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Icon(icon, size: AppSpacing.iconLg),
      ),
    );
  }
}

class _KeyboardKey {
  const _KeyboardKey(this.label, this.key, this.icon);

  final String label;
  final String key;
  final IconData icon;
}
