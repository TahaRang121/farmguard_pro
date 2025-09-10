import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricLoginWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;
  final bool isAvailable;

  const BiometricLoginWidget({
    super.key,
    required this.onBiometricLogin,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        InkWell(
          onTap: onBiometricLogin,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 16.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 32,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Use Biometric',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
