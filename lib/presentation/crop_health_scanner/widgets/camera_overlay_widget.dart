import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraOverlayWidget extends StatelessWidget {
  const CameraOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent overlay
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.3),
        ),

        // Center guide frame
        Center(
          child: Container(
            width: 70.w,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Corner guides
                Positioned(
                  top: -1,
                  left: -1,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                        left: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                        right: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  left: -1,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                        left: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                        right: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Instruction text
        Positioned(
          bottom: 35.h,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Position the affected leaf within the frame for accurate disease detection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
