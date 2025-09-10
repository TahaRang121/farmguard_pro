import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FieldListCard extends StatelessWidget {
  final Map<String, dynamic> field;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onViewHistory;
  final Function(Map<String, dynamic>)? onAddActivity;
  final Function(Map<String, dynamic>)? onSetReminder;
  final VoidCallback? onTap;

  const FieldListCard({
    super.key,
    required this.field,
    this.onEdit,
    this.onViewHistory,
    this.onAddActivity,
    this.onSetReminder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(field["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(field),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onViewHistory?.call(field),
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              icon: Icons.history,
              label: 'History',
            ),
            SlidableAction(
              onPressed: (_) => onAddActivity?.call(field),
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
              icon: Icons.add_task,
              label: 'Activity',
            ),
            SlidableAction(
              onPressed: (_) => onSetReminder?.call(field),
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              icon: Icons.notifications,
              label: 'Remind',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: field["cropImage"] as String? ??
                              "https://images.pexels.com/photos/2132227/pexels-photo-2132227.jpeg",
                          width: 15.w,
                          height: 8.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    field["fieldName"] as String? ??
                                        "Field ${field["id"]}",
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getHealthStatusColor(
                                            field["healthStatus"] as String? ??
                                                "Good")
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    field["healthStatus"] as String? ?? "Good",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: _getHealthStatusColor(
                                          field["healthStatus"] as String? ??
                                              "Good"),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              "${field["cropType"] ?? "Unknown Crop"} • ${field["area"] ?? "0"} acres",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          'calendar_today',
                          'Planted',
                          field["plantingDate"] as String? ?? "N/A",
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          'schedule',
                          'Days',
                          "${field["daysSincePlanting"] ?? "0"} days",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          'water_drop',
                          'Last Irrigation',
                          field["lastIrrigation"] as String? ?? "N/A",
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          'eco',
                          'Growth Stage',
                          field["growthStage"] as String? ?? "N/A",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'agriculture',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Expected Harvest: ${field["expectedHarvest"] ?? "N/A"}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIconWidget(
                        iconName: 'swipe',
                        color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Swipe for actions',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String iconName, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
          size: 14,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF8BC34A);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
