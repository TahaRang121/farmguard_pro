import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsRow extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;
  final VoidCallback? onClearAll;

  const FilterChipsRow({
    super.key,
    required this.selectedFilters,
    required this.onFilterToggle,
    this.onClearAll,
  });

  static const List<Map<String, dynamic>> _filterOptions = [
    {"label": "All Crops", "value": "all", "icon": "select_all"},
    {"label": "Rice", "value": "rice", "icon": "grass"},
    {"label": "Wheat", "value": "wheat", "icon": "agriculture"},
    {"label": "Corn", "value": "corn", "icon": "eco"},
    {"label": "Cotton", "value": "cotton", "icon": "local_florist"},
    {"label": "Sugarcane", "value": "sugarcane", "icon": "nature"},
    {"label": "Recent", "value": "recent", "icon": "schedule"},
    {"label": "Healthy", "value": "healthy", "icon": "health_and_safety"},
    {"label": "Needs Attention", "value": "attention", "icon": "warning"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = selectedFilters.contains(filter["value"]);

                return _buildFilterChip(
                  context,
                  filter["label"] as String,
                  filter["value"] as String,
                  filter["icon"] as String,
                  isSelected,
                );
              },
            ),
          ),
          if (selectedFilters.isNotEmpty) ...[
            SizedBox(width: 2.w),
            _buildClearButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String value,
    String iconName,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFilterToggle(value),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : theme.dividerColor,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color ?? Colors.grey,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClearAll,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.error,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'clear',
                color: theme.colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                'Clear',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
