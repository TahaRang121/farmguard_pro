import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AlertBannerWidget extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AlertBannerWidget({
    super.key,
    required this.alertData,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertType = alertData["type"] as String;

    Color alertColor;
    IconData alertIcon;

    switch (alertType.toLowerCase()) {
      case 'disease':
        alertColor = theme.colorScheme.error;
        alertIcon = Icons.bug_report;
        break;
      case 'irrigation':
        alertColor = const Color(0xFF2196F3);
        alertIcon = Icons.water_drop;
        break;
      case 'weather':
        alertColor = const Color(0xFFFF8F00);
        alertIcon = Icons.cloud;
        break;
      case 'fertilizer':
        alertColor = const Color(0xFF4CAF50);
        alertIcon = Icons.eco;
        break;
      default:
        alertColor = theme.colorScheme.error;
        alertIcon = Icons.warning;
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alertColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: alertColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    alertIcon,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alertData["title"] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: alertColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        alertData["message"] as String,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        alertData["timestamp"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDismiss != null) ...[
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: onDismiss,
                    icon: CustomIconWidget(
                      iconName: "close",
                      size: 5.w,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 8.w,
                      minHeight: 8.w,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
