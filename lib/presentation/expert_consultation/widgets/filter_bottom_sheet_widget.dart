import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _cropTypes = [
    'All Crops',
    'Rice',
    'Wheat',
    'Cotton',
    'Sugarcane',
    'Maize',
    'Soybean',
    'Pulses',
    'Vegetables',
    'Fruits',
  ];

  final List<String> _problemCategories = [
    'All Problems',
    'Disease Diagnosis',
    'Pest Control',
    'Soil Health',
    'Irrigation',
    'Fertilizer',
    'Weather Issues',
    'Crop Planning',
    'Market Guidance',
  ];

  final List<String> _languages = [
    'All Languages',
    'Hindi',
    'English',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Punjabi',
    'Bengali',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
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
                  'Filter Experts',
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
                  _buildFilterSection(
                    context,
                    'Crop Type',
                    _cropTypes,
                    _filters['cropType'] as String? ?? 'All Crops',
                    (value) => setState(() => _filters['cropType'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    context,
                    'Problem Category',
                    _problemCategories,
                    _filters['problemCategory'] as String? ?? 'All Problems',
                    (value) =>
                        setState(() => _filters['problemCategory'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    context,
                    'Language',
                    _languages,
                    _filters['language'] as String? ?? 'All Languages',
                    (value) => setState(() => _filters['language'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildAvailabilityFilter(context),
                  SizedBox(height: 3.h),
                  _buildRatingFilter(context),
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
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    child: Text('Clear All'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter(BuildContext context) {
    final theme = Theme.of(context);
    final onlineOnly = _filters['onlineOnly'] as bool? ?? false;

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
        CheckboxListTile(
          title: Text(
            'Show only online experts',
            style: theme.textTheme.bodyMedium,
          ),
          value: onlineOnly,
          onChanged: (value) =>
              setState(() => _filters['onlineOnly'] = value ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    final theme = Theme.of(context);
    final minRating = _filters['minRating'] as double? ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: minRating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                label: minRating.toStringAsFixed(1),
                onChanged: (value) =>
                    setState(() => _filters['minRating'] = value),
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    minRating.toStringAsFixed(1),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'cropType': 'All Crops',
        'problemCategory': 'All Problems',
        'language': 'All Languages',
        'onlineOnly': false,
        'minRating': 0.0,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
