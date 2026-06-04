import 'package:flutter/material.dart';

class SwipeAction {
  const SwipeAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
}

class SwipeWidget extends StatefulWidget {
  const SwipeWidget({
    super.key,
    required this.child,
    required this.actions,
    this.actionWidth = 82,
    this.borderRadius = 12,
  });

  final Widget child;
  final List<SwipeAction> actions;
  final double actionWidth;
  final double borderRadius;

  @override
  State<SwipeWidget> createState() => _SwipeWidgetState();
}

class _SwipeWidgetState extends State<SwipeWidget> {
  double _dragOffset = 0;

  double get _maxOffset => widget.actions.length * widget.actionWidth;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset = (_dragOffset - details.delta.dx).clamp(0, _maxOffset);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final shouldOpen = _dragOffset > _maxOffset * 0.35;
    setState(() {
      _dragOffset = shouldOpen ? _maxOffset : 0;
    });
  }

  void _close() {
    if (_dragOffset == 0) return;
    setState(() => _dragOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actions.isEmpty) return widget.child;

    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions.map((action) {
                final background = action.backgroundColor ?? colorScheme.error;
                final foreground =
                    action.foregroundColor ?? colorScheme.onError;
                return SizedBox(
                  width: widget.actionWidth,
                  height: double.infinity,
                  child: Material(
                    color: background,
                    child: InkWell(
                      onTap: () {
                        _close();
                        action.onTap();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action.icon, color: foreground, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            action.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _close,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: AnimatedSlide(
              offset: Offset(-_dragOffset / MediaQuery.sizeOf(context).width, 0),
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
