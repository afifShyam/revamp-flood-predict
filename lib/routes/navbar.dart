import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _isNavBarVisible = true;
  double _lastScrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    // ✅ Hide NavBar for subpages (not main pages)
    bool isNavBarHidden = _shouldHideNavBar(location);

    return Scaffold(
      extendBody: true,

      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double currentOffset = scrollInfo.metrics.pixels;

          if (scrollInfo.metrics.axis == Axis.vertical) {
            if (currentOffset - _lastScrollOffset > 10) {
              // ✅ Hide NavBar when scrolling up
              if (_isNavBarVisible) setState(() => _isNavBarVisible = false);
            } else if (_lastScrollOffset - currentOffset > 10) {
              // ✅ Show NavBar when scrolling down
              if (!_isNavBarVisible) setState(() => _isNavBarVisible = true);
            }
          }

          _lastScrollOffset = currentOffset;
          return false;
        },
        child: widget.child,
      ),

      // ✅ Reverse NavBar Hide/Show Logic
      bottomNavigationBar: isNavBarHidden
          ? null
          : AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isNavBarVisible
                  ? Platform.isAndroid
                      ? kBottomNavigationBarHeight
                      : 76
                  : 0,
              child: _isNavBarVisible ? _buildBottomNavBar(context) : const SizedBox(),
            ),
    );
  }

  /// ✅ Determines if NavBar should be hidden
  bool _shouldHideNavBar(String location) {
    return (location.startsWith('/shopping/') && location != '/shopping') ||
        (location.startsWith('/profile/') && location != '/profile') ||
        (location.startsWith('/menu/') && location != '/menu');
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(context, Icons.home, 'Home', '/', 0),
          _navIcon(context, Icons.shopping_cart, 'Shop', '/shopping', 1),
          _navIcon(context, Icons.person, 'Profile', '/profile', 2),
          _navIcon(context, Icons.menu, 'Menu', '/menu', 3),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, String label, String route, int index) {
    bool isSelected = _getSelectedIndex(context) == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icon, size: 25, color: isSelected ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  /// ✅ Correctly detects which tab should be highlighted
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location == '/' || location.startsWith('/home')) return 0; // Home
    if (location == '/shopping') return 1; // Shop (Only highlight on /shopping)
    if (location == '/profile') return 2; // Profile
    if (location == '/menu') return 3; // Menu
    return 0; // Default to Home
  }
}
