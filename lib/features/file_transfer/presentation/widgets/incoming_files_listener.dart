import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/app/router_provider.dart';
import 'package:pc_remote/core/helpers/dialog_helper.dart';

import '../providers/downloaded_files_provider.dart';
import '../providers/incoming_files_provider.dart';
import 'incoming_files_dialog.dart';

class IncomingFilesListener extends ConsumerStatefulWidget {
  const IncomingFilesListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<IncomingFilesListener> createState() =>
      _IncomingFilesListenerState();
}

class _IncomingFilesListenerState extends ConsumerState<IncomingFilesListener> {
  bool _dialogShowing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      incomingFilesProvider,
      (previous, next) {
        if (next.isEmpty || _dialogShowing) return;

        final previousLength = previous?.length ?? 0;
        if (next.length <= previousLength) return;

        _dialogShowing = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navigatorContext = rootNavigatorKey.currentContext;
          final navigatorState = rootNavigatorKey.currentState;

          if (navigatorContext == null || navigatorState == null) {
            _dialogShowing = false;
            return;
          }

          DialogHelper.showAppDialog(
            context: navigatorContext,
            barrierDismissible: false,
            child: IncomingFilesDialog(
              files: next,
              onAccept: () async {
                navigatorState.pop();

                await ref
                    .read(downloadedFilesProvider.notifier)
                    .downloadAll(next);
                ref.read(incomingFilesProvider.notifier).clear();

                _dialogShowing = false;
              },
              onReject: () {
                navigatorState.pop();
                ref.read(incomingFilesProvider.notifier).clear();
                _dialogShowing = false;
              },
            ),
          );
        });
      },
    );

    return widget.child;
  }
}