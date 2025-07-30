import 'dart:developer';

import 'package:flood_prediction_fyp/routes/navbar.dart';
import 'package:flood_prediction_fyp/routes/pop_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart'; // ✅ Needed to exit app properly

import 'package:flood_prediction_fyp/screen/homepage.dart';
import 'package:flood_prediction_fyp/screen/menu.dart';
import 'package:flood_prediction_fyp/screen/profile.dart';
import 'package:flood_prediction_fyp/screen/shopping.dart';
import 'package:flood_prediction_fyp/screen/shopping_item.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/shopping',
  routes: [
    // ✅ Main Pages with Bottom Navigation (ShellRoute)
    ShellRoute(
      builder: (context, state, child) => _wrapWithBackHandler(
        context,
        NavBar(child: child),
      ),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: HomepageScreen(),
          ),
        ),
        GoRoute(
          path: '/shopping',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: ShoppingScreen(),
          ),
          routes: [
            // ✅ Shopping Item Page (OUTSIDE SHELLROUTE)
            GoRoute(
              path: '/item/:itemId',
              pageBuilder: (context, state) {
                final itemId = state.pathParameters['itemId']!;
                return _buildPageWithTransition(
                  child: ShoppingItemScreen(itemId: itemId),
                  transitionType: TransitionType.slide, // Slide animation
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: ProfileScreen(),
          ),
        ),
        GoRoute(
          path: '/menu',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: MenuScreen(),
          ),
        ),
      ],
    ),
  ],
);

/// ✅ Ensures Proper Back Navigation Between `ShellRoute` and Outside Pages
Widget _wrapWithBackHandler(BuildContext context, Widget child) {
  return
      // WillPopScope(
      //   onWillPop: () async {
      //     final GoRouter router = GoRouter.of(context);
      //     if (router.canPop()) {
      //       router.pop('kk');
      //       return false;
      //     } else {
      //       _showExitDialog(context);
      //       return true;
      //     }
      //   },
      //   child: child,
      // );
      PopScope(
    canPop: !GoRouter.of(context).canPop(),
    onPopInvokedWithResult: (didPop, result1) {
      final GoRouter router = GoRouter.of(context);
      // final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();
      // final String currentPath = GoRouterState.of(context).uri.toString(); // ✅ Get current route

      // final backHandler = BackResultHandler.takeResultForRoute(currentRoute);
      // log('what is backHandler: $backHandler');
      // if (backHandler != null) {
      //   final backData = backHandler;
      //   log('what is result12: $backData');
      //   router.pop(backData);
      // context.pop('kk'); // ✅ Navigate back if possible
      // }

      log('what is result1: $result1');
      if (!didPop) {
        if (router.canPop()) {
          router.pop('lllll'); // ✅ Navigate back if possible
        } else {
          _showExitDialog(context); // ✅ Exit confirmation if at home
        }
      }
    },
    child: child,
  );
}

/// ✅ Show Exit Confirmation Dialog Before Closing App
void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Exit App"),
      content: const Text("Are you sure you want to exit?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(), // Exit App
          child: const Text("Exit"),
        ),
      ],
    ),
  );
}

/// ✅ Helper Function for Custom Transitions (with Auto Back Handling)
Page<dynamic> _buildPageWithTransition({
  required Widget child,
  TransitionType transitionType = TransitionType.fade, // Default is fade transition
}) {
  return CustomTransitionPage(
    key: ValueKey(child.runtimeType),
    child: Builder(
      builder: (context) => _wrapWithBackHandler(context, child), // ✅ Apply back handling
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case TransitionType.slide:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide from right
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.scale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: child,
          );
        case TransitionType.cupertino:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Cupertino-style slide
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      }
    },
  );
}

/// ✅ Enum for Different Transition Types
enum TransitionType { fade, slide, scale, cupertino }
