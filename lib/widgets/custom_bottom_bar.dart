import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item for CustomBottomBar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar for agricultural technology application
/// Optimized for one-handed operation and field conditions
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 4.0,
  });

  // Hardcoded navigation items for agricultural app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/farm-dashboard',
    ),
    BottomNavItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt,
      label: 'Scanner',
      route: '/crop-health-scanner',
    ),
    BottomNavItem(
      icon: Icons.agriculture_outlined,
      activeIcon: Icons.agriculture,
      label: 'Farm',
      route: '/farm-management',
    ),
    BottomNavItem(
      icon: Icons.support_agent_outlined,
      activeIcon: Icons.support_agent,
      label: 'Expert',
      route: '/expert-consultation',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile-settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x26FFFFFF) : const Color(0x1A000000),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (onTap != null) {
            onTap!(index);
          }
          // Navigate to the selected route
          Navigator.pushNamed(context, _navItems[index].route);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: selectedItemColor ??
            theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: unselectedItemColor ??
            theme.bottomNavigationBarTheme.unselectedItemColor,
        elevation: elevation,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        items: _navItems.map((item) {
          final isSelected = _navItems.indexOf(item) == currentIndex;
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(
                isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                size: 24,
              ),
            ),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }
}
