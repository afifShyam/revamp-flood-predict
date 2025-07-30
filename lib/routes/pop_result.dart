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
}

class _BackResultHandlerState extends State<BackResultHandler> {
  static final Map<String, Object?> _backResults = {};

  late final String _location;

  @override
  void initState() {
    super.initState();

    // ✅ Cache the correct location immediately when the widget is built
    _location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    log('🧭 Cached location for back result: $_location');
  }

  @override
  void deactivate() {
    if (widget.onBackWithResult != null) {
      _backResults[_location] = widget.onBackWithResult!.call();
      log('📦 Stored back result for $_location: ${_backResults[_location]}');
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
