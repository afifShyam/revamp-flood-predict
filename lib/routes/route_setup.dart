import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flood_prediction_fyp/routes/navbar.dart';
import 'package:flood_prediction_fyp/screen/homepage.dart';
import 'package:flood_prediction_fyp/screen/menu.dart';
import 'package:flood_prediction_fyp/screen/profile.dart';
import 'package:flood_prediction_fyp/screen/shopping.dart';
import 'package:flood_prediction_fyp/screen/shopping_item.dart';

// ✅ Global navigator key for handling back navigation results
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// ✅ Simple solution: Use StatefulShellRoute to automatically preserve state
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  restorationScopeId: 'router',
  initialLocation: '/shopping',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => _ErrorPage(error: state.error.toString()),

  routes: [
    // ✅ StatefulShellRoute automatically keeps all tab states alive!
    StatefulShellRoute.indexedStack(
      restorationScopeId: 'mainShell',
      pageBuilder: (context, state, navigationShell) {
        return MaterialPage(
          restorationId: 'mainShellPage',
          child: NavBar(
            navigationShell: navigationShell,
          ), // Pass navigationShell to NavBar
        );
      },
      branches: [
        // ✅ Home branch
        StatefulShellBranch(
          restorationScopeId: 'homeBranch',
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              pageBuilder: (context, state) => _buildPageWithTransition(
                key: state.pageKey,
                child: const HomepageScreen(),
                transitionType: TransitionType.fade,
                restorationId: 'homePage',
              ),
            ),
          ],
        ),

        // ✅ Shopping branch
        StatefulShellBranch(
          restorationScopeId: 'shoppingBranch',
          routes: [
            GoRoute(
              path: '/shopping',
              name: 'shopping',
              pageBuilder: (context, state) => _buildPageWithTransition(
                key: state.pageKey,
                child: const ShoppingScreen(),
                transitionType: TransitionType.fade,
                restorationId: 'shoppingPage',
              ),
            ),
          ],
        ),

        // ✅ Profile branch
        StatefulShellBranch(
          restorationScopeId: 'profileBranch',
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => _buildPageWithTransition(
                key: state.pageKey,
                child: const ProfileScreen(),
                transitionType: TransitionType.fade,
                restorationId: 'profilePage',
              ),
            ),
          ],
        ),

        // ✅ Menu branch
        StatefulShellBranch(
          restorationScopeId: 'menuBranch',
          routes: [
            GoRoute(
              path: '/menu',
              name: 'menu',
              pageBuilder: (context, state) => _buildPageWithTransition(
                key: state.pageKey,
                child: const MenuScreen(),
                transitionType: TransitionType.fade,
                restorationId: 'menuPage',
              ),
            ),
          ],
        ),
      ],
    ),

    // ✅ Shopping item route (outside shell - no bottom nav)
    GoRoute(
      path: '/shopping/item/:itemId',
      name: 'shopping_item',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final itemId = state.pathParameters['itemId']!;
        final extra = state.extra as Map<String, dynamic>?;

        return _buildPageWithTransition(
          key: state.pageKey,
          child: ShoppingItemScreen(itemId: itemId),
          transitionType: TransitionType.slideFromRight,
          restorationId: 'shoppingItemPage_$itemId',
        );
      },
    ),
  ],
);

// Rest of your code remains exactly the same...
enum TransitionType { fade, slideFromRight, slideFromBottom, scale, rotation }

Page<dynamic> _buildPageWithTransition({
  required LocalKey key,
  required Widget child,
  TransitionType transitionType = TransitionType.fade,
  Duration duration = const Duration(milliseconds: 300),
  String? restorationId,
}) {
  return CustomTransitionPage<dynamic>(
    key: key,
    child: child,
    restorationId: restorationId,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _getTransition(
        transitionType,
        animation,
        secondaryAnimation,
        child,
      );
    },
  );
}

Widget _getTransition(
  TransitionType type,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  switch (type) {
    case TransitionType.fade:
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );

    case TransitionType.slideFromRight:
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(
        tween.chain(CurveTween(curve: Curves.easeInOut)),
      );
      return SlideTransition(position: offsetAnimation, child: child);

    case TransitionType.slideFromBottom:
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(
        tween.chain(CurveTween(curve: Curves.easeInOut)),
      );
      return SlideTransition(position: offsetAnimation, child: child);

    case TransitionType.scale:
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: FadeTransition(opacity: animation, child: child),
      );

    case TransitionType.rotation:
      return RotationTransition(
        turns: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        ),
      );
  }
}

class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

extension NavigationHelper on BuildContext {
  void goToShoppingItem(String itemId, [Map<String, dynamic>? data]) {
    go('/shopping/item/$itemId', extra: data);
  }

  void popWithResult<T>(T result) {
    if (canPop()) {
      pop(result);
    } else {
      go('/shopping');
    }
  }

  void safeGo(String route) {
    try {
      go(route);
    } catch (e) {
      log('Navigation error: $e');
      go('/');
    }
  }
}

class RouteInfo {
  static const String home = '/';
  static const String shopping = '/shopping';
  static const String profile = '/profile';
  static const String menu = '/menu';
  static const String shoppingItem = '/shopping/item';

  static String shoppingItemPath(String itemId) => '$shoppingItem/$itemId';

  static bool isMainRoute(String route) {
    return [home, shopping, profile, menu].contains(route);
  }

  static bool isShoppingSubRoute(String route) {
    return route.startsWith('$shopping/') && route != shopping;
  }
}
