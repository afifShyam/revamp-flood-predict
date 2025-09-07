import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell; // ✅ Changed from Widget child

  const NavBar({
    super.key,
    required this.navigationShell,
  }); // ✅ Updated constructor

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
          // Only handle vertical scroll
          if (scrollInfo.metrics.axis != Axis.vertical) {
            return false;
          }

          // Define a single, consistent threshold
          const scrollThreshold = 10.0;

          // Calculate the change in scroll offset
          final scrollDelta = scrollInfo.metrics.pixels - _lastScrollOffset;

          if (scrollDelta > scrollThreshold && _isNavBarVisible) {
            // Hide the bar when scrolling down
            setState(() => _isNavBarVisible = false);
          } else if (scrollDelta < -scrollThreshold && !_isNavBarVisible) {
            // Show the bar when scrolling up
            setState(() => _isNavBarVisible = true);
          }

          // Update the last scroll offset
          _lastScrollOffset = scrollInfo.metrics.pixels;

          return false;
        },
        child: widget.navigationShell, // ✅ Use navigationShell instead of child
      ),

      // ✅ Reverse NavBar Hide/Show Logic
      bottomNavigationBar: isNavBarHidden
          ? null
          : SafeArea(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: _isNavBarVisible ? kBottomNavigationBarHeight + 10 : 0,
                child: _isNavBarVisible
                    ? _buildBottomNavBar(context)
                    : const SizedBox.shrink(),
              ),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(
            context,
            Icons.home,
            'Home',
            0,
          ), // ✅ Pass index instead of route
          _navIcon(context, Icons.shopping_cart, 'Shop', 1),
          _navIcon(context, Icons.person, 'Profile', 2),
          _navIcon(context, Icons.menu, 'Menu', 3),
        ],
      ),
    );
  }

  Widget _navIcon(
    BuildContext context,
    IconData icon,
    String label,
    int index, // ✅ Use index instead of route
  ) {
    bool isSelected =
        widget.navigationShell.currentIndex ==
        index; // ✅ Use navigationShell.currentIndex

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // ✅ Use goBranch to navigate between tabs (preserves state)
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              icon,
              size: 25,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
