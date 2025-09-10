import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item for CustomTabBar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? content;

  const TabItem({
    required this.label,
    this.icon,
    this.content,
  });
}

/// Custom Tab Bar for agricultural technology application
/// Implements clean data-focused interface with spatial hierarchy
class CustomTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final TabBarIndicatorSize indicatorSize;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
    this.indicatorSize = TabBarIndicatorSize.label,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.onTabChanged != null && _tabController.indexIsChanging) {
      widget.onTabChanged!(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color:
                    isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            labelColor: widget.selectedColor ?? theme.tabBarTheme.labelColor,
            unselectedLabelColor: widget.unselectedColor ??
                theme.tabBarTheme.unselectedLabelColor,
            indicatorColor:
                widget.indicatorColor ?? theme.tabBarTheme.indicatorColor,
            indicatorSize: widget.indicatorSize,
            indicatorWeight: 2,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: widget.tabs.map((tab) {
              return Tab(
                icon: tab.icon != null ? Icon(tab.icon, size: 20) : null,
                text: tab.label,
                iconMargin: tab.icon != null
                    ? const EdgeInsets.only(bottom: 4)
                    : EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) {
              return tab.content ??
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        '${tab.label} Content',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Simplified CustomTabBar for header-only usage
class CustomTabBarHeader extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const CustomTabBarHeader({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
  });

  @override
  State<CustomTabBarHeader> createState() => _CustomTabBarHeaderState();
}

class _CustomTabBarHeaderState extends State<CustomTabBarHeader>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.onTabChanged != null && _tabController.indexIsChanging) {
      widget.onTabChanged!(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? theme.tabBarTheme.labelColor,
        unselectedLabelColor:
            widget.unselectedColor ?? theme.tabBarTheme.unselectedLabelColor,
        indicatorColor:
            widget.indicatorColor ?? theme.tabBarTheme.indicatorColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) {
          return Tab(text: tab);
        }).toList(),
      ),
    );
  }
}
