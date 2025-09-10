import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraHeaderWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onFlashToggle;
  final VoidCallback onCameraSwitch;
  final bool isFlashOn;
  final bool hasMultipleCameras;

  const CameraHeaderWidget({
    super.key,
    required this.onClose,
    required this.onFlashToggle,
    required this.onCameraSwitch,
    required this.isFlashOn,
    required this.hasMultipleCameras,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Close button
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),

              // Title
              Text(
                'Crop Health Scanner',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              // Camera controls
              Row(
                children: [
                  // Flash toggle
                  GestureDetector(
                    onTap: onFlashToggle,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isFlashOn
                            ? AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: isFlashOn ? 'flash_on' : 'flash_off',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),

                  if (hasMultipleCameras) ...[
                    SizedBox(width: 2.w),
                    // Camera switch
                    GestureDetector(
                      onTap: onCameraSwitch,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'flip_camera_ios',
                          color: Colors.white,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
