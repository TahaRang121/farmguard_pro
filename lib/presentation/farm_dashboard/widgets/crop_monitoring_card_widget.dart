import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CropMonitoringCardWidget extends StatelessWidget {
  final Map<String, dynamic> cropData;
  final VoidCallback? onTakePhoto;
  final VoidCallback? onViewHistory;
  final VoidCallback? onSetReminder;
  final VoidCallback? onEditDetails;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onShareReport;

  const CropMonitoringCardWidget({
    super.key,
    required this.cropData,
    this.onTakePhoto,
    this.onViewHistory,
    this.onSetReminder,
    this.onEditDetails,
    this.onViewAnalytics,
    this.onShareReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onTakePhoto?.call(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.camera_alt,
            label: 'Photo',
          ),
          SlidableAction(
            onPressed: (_) => onViewHistory?.call(),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            icon: Icons.history,
            label: 'History',
          ),
          SlidableAction(
            onPressed: (_) => onSetReminder?.call(),
            backgroundColor: const Color(0xFFFF8F00),
            foregroundColor: Colors.white,
            icon: Icons.alarm,
            label: 'Remind',
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: cropData["image"] as String,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cropData["name"] as String,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "Field ${cropData["fieldSection"]}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildHealthStatus(
                            context, cropData["healthStatus"] as String),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: "schedule",
                          size: 4.w,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Last inspected: ${cropData["lastInspection"]}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: "straighten",
                          size: 4.w,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "${cropData["area"]} acres",
                          style: theme.textTheme.bodySmall,
                        ),
                        SizedBox(width: 4.w),
                        CustomIconWidget(
                          iconName: "eco",
                          size: 4.w,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Stage: ${cropData["growthStage"]}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthStatus(BuildContext context, String status) {
    final theme = Theme.of(context);
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'healthy':
        statusColor = AppTheme.lightTheme.colorScheme.secondary;
        statusIcon = Icons.check_circle;
        break;
      case 'warning':
        statusColor = const Color(0xFFFF8F00);
        statusIcon = Icons.warning;
        break;
      case 'critical':
        statusColor = theme.colorScheme.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = theme.colorScheme.onSurfaceVariant;
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 4.w,
            color: statusColor,
          ),
          SizedBox(width: 1.w),
          Text(
            status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                cropData["name"] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildContextMenuItem(
                context,
                Icons.edit,
                "Edit Details",
                onEditDetails,
              ),
              _buildContextMenuItem(
                context,
                Icons.analytics,
                "View Analytics",
                onViewAnalytics,
              ),
              _buildContextMenuItem(
                context,
                Icons.share,
                "Share Report",
                onShareReport,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback? onTap,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
}
