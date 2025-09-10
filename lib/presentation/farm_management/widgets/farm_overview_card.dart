import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FarmOverviewCard extends StatelessWidget {
  final Map<String, dynamic> farmData;

  const FarmOverviewCard({
    super.key,
    required this.farmData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'agriculture',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  farmData["farmName"] as String? ?? "My Farm",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getHealthStatusColor(
                          farmData["overallHealth"] as String? ?? "Good")
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  farmData["overallHealth"] as String? ?? "Good",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _getHealthStatusColor(
                        farmData["overallHealth"] as String? ?? "Good"),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  "Total Area",
                  "${farmData["totalArea"] ?? "0"} acres",
                  'landscape',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  "Fields",
                  "${farmData["totalFields"] ?? "0"}",
                  'grid_view',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  "Active Crops",
                  "${farmData["activeCrops"] ?? "0"}",
                  'eco',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  "Health Score",
                  "${farmData["healthScore"] ?? "0"}%",
                  'health_and_safety',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'good':
        return const Color(0xFF4CAF50);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
