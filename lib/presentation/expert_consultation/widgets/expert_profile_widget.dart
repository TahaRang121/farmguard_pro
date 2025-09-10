import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpertProfileWidget extends StatelessWidget {
  final Map<String, dynamic> expert;
  final VoidCallback onBookConsultation;
  final VoidCallback onStartChat;

  const ExpertProfileWidget({
    super.key,
    required this.expert,
    required this.onBookConsultation,
    required this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = expert["rating"] as double? ?? 0.0;
    final totalReviews = expert["totalReviews"] as int? ?? 0;
    final experience = expert["experience"] as int? ?? 0;
    final consultationFee = expert["consultationFee"] as String? ?? "₹0";
    final isOnline = expert["isOnline"] as bool? ?? false;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expert Profile',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.textTheme.bodyLarge?.color,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context),
                  SizedBox(height: 3.h),
                  _buildStatsRow(context),
                  SizedBox(height: 3.h),
                  _buildAboutSection(context),
                  SizedBox(height: 3.h),
                  _buildSpecializationsSection(context),
                  SizedBox(height: 3.h),
                  _buildLanguagesSection(context),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(context),
                  SizedBox(height: 3.h),
                  _buildReviewsSection(context),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStartChat,
                    icon: CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: Text('Start Chat'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onBookConsultation,
                    icon: CustomIconWidget(
                      iconName: 'video_call',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Book Video Call - $consultationFee'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = expert["isOnline"] as bool? ?? false;

    return Row(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: expert["profileImage"] as String? ?? "",
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expert["name"] as String? ?? "Unknown Expert",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                expert["specialization"] as String? ?? "General Agriculture",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isOnline
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOnline ? "Online Now" : "Offline",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOnline ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final rating = expert["rating"] as double? ?? 0.0;
    final totalReviews = expert["totalReviews"] as int? ?? 0;
    final experience = expert["experience"] as int? ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            CustomIconWidget(
              iconName: 'star',
              color: Colors.amber,
              size: 24,
            ),
            rating.toStringAsFixed(1),
            '$totalReviews Reviews',
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            context,
            CustomIconWidget(
              iconName: 'work_outline',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            '$experience Years',
            'Experience',
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildStatCard(
            context,
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.secondaryLight,
              size: 24,
            ),
            expert["responseTime"] as String? ?? "N/A",
            'Response Time',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, Widget icon, String value, String label) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          expert["about"] as String? ??
              "Experienced agricultural expert with deep knowledge in crop management and farming techniques.",
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSpecializationsSection(BuildContext context) {
    final theme = Theme.of(context);
    final specializations = expert["specializations"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specializations',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: specializations
              .map((spec) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      spec as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection(BuildContext context) {
    final theme = Theme.of(context);
    final languages = expert["languages"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: languages
              .map((lang) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      lang as String,
                      style: theme.textTheme.bodySmall,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final theme = Theme.of(context);
    final availability = expert["availability"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...availability.map((slot) {
          final slotMap = slot as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "${slotMap["day"]}: ${slotMap["time"]}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final theme = Theme.of(context);
    final reviews = expert["reviews"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (reviews.length > 2)
              TextButton(
                onPressed: () {
                  // Show all reviews
                },
                child: Text('View All'),
              ),
          ],
        ),
        SizedBox(height: 1.h),
        ...reviews.take(2).map((review) {
          final reviewMap = review as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reviewMap["farmerName"] as String? ?? "Anonymous",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        final rating = reviewMap["rating"] as double? ?? 0.0;
                        return CustomIconWidget(
                          iconName: index < rating ? 'star' : 'star_border',
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  reviewMap["comment"] as String? ?? "",
                  style: theme.textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  reviewMap["date"] as String? ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}