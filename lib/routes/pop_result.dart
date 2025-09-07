import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class BackResultHandler extends StatefulWidget {
  final Widget child;
  final Object? Function()? onBackWithResult;

  const BackResultHandler({
    super.key,
    required this.child,
    this.onBackWithResult,
  });

  @override
  State<BackResultHandler> createState() => _BackResultHandlerState();

  static Object? takeResultForRoute(String location) {
    return _BackResultHandlerState._backResults.remove(location);
  }

  static void clearAllResults() {
    _BackResultHandlerState._backResults.clear();
  }

  static Map<String, Object?> getAllResults() {
    return Map.from(_BackResultHandlerState._backResults);
  }
}

class _BackResultHandlerState extends State<BackResultHandler>
    with RestorationMixin {
  static final Map<String, Object?> _backResults = {};
  late final String _location;

  @override
  String? get restorationId => 'back_result_handler_${_location.hashCode}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    log('🔄 Restoring BackResultHandler state for $_location');
  }

  @override
  void initState() {
    super.initState();
    _location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    log('🧭 Cached location for back result: $_location');
  }

  @override
  void deactivate() {
    if (widget.onBackWithResult != null) {
      final result = widget.onBackWithResult!.call();
      if (result != null) {
        _backResults[_location] = result;
        log('📦 Stored back result for $_location: $result');
      }
    }
    super.deactivate();
  }

  void _handleBackNavigation(BuildContext context, Object? result) {
    if (result != null) {
      _backResults[_location] = result;
      log('📦 Stored result via back press for $_location: $result');
    }

    if (context.canPop()) {
      context.pop(result);
    } else {
      context.go('/'); // fallback route, you can change this
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // intercept all back presses
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final backResult = widget.onBackWithResult?.call();
          _handleBackNavigation(
            context,
            backResult ?? '🔙 Back from $_location',
          );
        }
      },
      child: widget.child,
    );
  }
}
