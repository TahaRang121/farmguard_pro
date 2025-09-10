import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FarmOverviewWidget extends StatelessWidget {
  final Map<String, dynamic> farmData;

  const FarmOverviewWidget({
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
          Text(
            "Farm Overview",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  context,
                  "landscape",
                  "Total Area",
                  "${farmData["totalArea"]} acres",
                  theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewItem(
                  context,
                  "agriculture",
                  "Active Crops",
                  "${farmData["activeCrops"]}",
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildHealthScore(context, farmData["healthScore"] as int),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context,
    String iconName,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 6.w,
            color: color,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScore(BuildContext context, int score) {
    final theme = Theme.of(context);
    Color scoreColor;
    String scoreText;

    if (score >= 80) {
      scoreColor = AppTheme.lightTheme.colorScheme.secondary;
      scoreText = "Excellent";
    } else if (score >= 60) {
      scoreColor = const Color(0xFFFF8F00);
      scoreText = "Good";
    } else {
      scoreColor = theme.colorScheme.error;
      scoreText = "Needs Attention";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Farm Health Score",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$score/100",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: scoreColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
          minHeight: 8,
        ),
        SizedBox(height: 0.5.h),
        Text(
          scoreText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scoreColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
