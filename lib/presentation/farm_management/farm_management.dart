import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_field_fab.dart';
import './widgets/farm_overview_card.dart';
import './widgets/field_list_card.dart';
import './widgets/field_search_bar.dart';
import './widgets/filter_chips_row.dart';
import './widgets/interactive_farm_map.dart';
import '../../main.dart';

class FarmManagement extends StatefulWidget {
  const FarmManagement({super.key});

  @override
  State<FarmManagement> createState() => _FarmManagementState();
}

class _FarmManagementState extends State<FarmManagement>
    with TickerProviderStateMixin {
  List<String> _selectedFilters = ["all"];
  String _searchQuery = "";
  List<Map<String, dynamic>> _filteredFields = [];
  late AnimationController _listAnimationController;
  late AnimationController _headerAnimationController;

  // Mock farm data
  final Map<String, dynamic> _farmData = {
    "farmName": "Green Valley Farm",
    "totalArea": "45.2",
    "totalFields": "8",
    "activeCrops": "5",
    "healthScore": "87",
    "overallHealth": "Good",
  };

  // Mock fields data
  final List<Map<String, dynamic>> _fieldsData = [
    {
      "id": 1,
      "fieldName": "North Field A",
      "cropType": "Rice",
      "area": "8.5",
      "healthStatus": "Excellent",
      "plantingDate": "15 Jun 2024",
      "daysSincePlanting": "85",
      "lastIrrigation": "2 days ago",
      "growthStage": "Flowering",
      "expectedHarvest": "15 Nov 2024",
      "cropImage":
          "https://images.pexels.com/photos/2132227/pexels-photo-2132227.jpeg",
      "coordinates": [
        {"lat": 20.5937, "lng": 78.9629},
        {"lat": 20.5947, "lng": 78.9639},
        {"lat": 20.5957, "lng": 78.9629},
        {"lat": 20.5947, "lng": 78.9619},
      ],
    },
    {
      "id": 2,
      "fieldName": "South Field B",
      "cropType": "Wheat",
      "area": "6.2",
      "healthStatus": "Good",
      "plantingDate": "20 Jul 2024",
      "daysSincePlanting": "50",
      "lastIrrigation": "1 day ago",
      "growthStage": "Vegetative",
      "expectedHarvest": "20 Dec 2024",
      "cropImage":
          "https://images.pexels.com/photos/326082/pexels-photo-326082.jpeg",
      "coordinates": [
        {"lat": 20.5927, "lng": 78.9619},
        {"lat": 20.5937, "lng": 78.9629},
        {"lat": 20.5947, "lng": 78.9619},
        {"lat": 20.5937, "lng": 78.9609},
      ],
    },
    {
      "id": 3,
      "fieldName": "East Field C",
      "cropType": "Corn",
      "area": "12.8",
      "healthStatus": "Fair",
      "plantingDate": "10 May 2024",
      "daysSincePlanting": "121",
      "lastIrrigation": "5 days ago",
      "growthStage": "Maturity",
      "expectedHarvest": "25 Oct 2024",
      "cropImage":
          "https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg",
      "coordinates": [
        {"lat": 20.5957, "lng": 78.9639},
        {"lat": 20.5967, "lng": 78.9649},
        {"lat": 20.5977, "lng": 78.9639},
        {"lat": 20.5967, "lng": 78.9629},
      ],
    },
    {
      "id": 4,
      "fieldName": "West Field D",
      "cropType": "Cotton",
      "area": "9.3",
      "healthStatus": "Good",
      "plantingDate": "25 Jun 2024",
      "daysSincePlanting": "75",
      "lastIrrigation": "3 days ago",
      "growthStage": "Flowering",
      "expectedHarvest": "30 Nov 2024",
      "cropImage":
          "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg",
      "coordinates": [
        {"lat": 20.5917, "lng": 78.9609},
        {"lat": 20.5927, "lng": 78.9619},
        {"lat": 20.5937, "lng": 78.9609},
        {"lat": 20.5927, "lng": 78.9599},
      ],
    },
    {
      "id": 5,
      "fieldName": "Central Field E",
      "cropType": "Sugarcane",
      "area": "8.4",
      "healthStatus": "Poor",
      "plantingDate": "05 Apr 2024",
      "daysSincePlanting": "156",
      "lastIrrigation": "7 days ago",
      "growthStage": "Maturity",
      "expectedHarvest": "15 Jan 2025",
      "cropImage":
          "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg",
      "coordinates": [
        {"lat": 20.5947, "lng": 78.9629},
        {"lat": 20.5957, "lng": 78.9639},
        {"lat": 20.5967, "lng": 78.9629},
        {"lat": 20.5957, "lng": 78.9619},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredFields = List.from(_fieldsData);

    // Initialize animation controllers
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _onFilterToggle(String filter) {
    setState(() {
      if (filter == "all") {
        _selectedFilters = ["all"];
      } else {
        _selectedFilters.remove("all");
        if (_selectedFilters.contains(filter)) {
          _selectedFilters.remove(filter);
          if (_selectedFilters.isEmpty) {
            _selectedFilters.add("all");
          }
        } else {
          _selectedFilters.add(filter);
        }
      }
      _applyFilters();
    });
  }

  void _onClearFilters() {
    setState(() {
      _selectedFilters = ["all"];
      _applyFilters();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredFields = _fieldsData.where((field) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final fieldName = (field["fieldName"] as String? ?? "").toLowerCase();
        final cropType = (field["cropType"] as String? ?? "").toLowerCase();

        if (!fieldName.contains(searchLower) &&
            !cropType.contains(searchLower)) {
          return false;
        }
      }

      // Apply category filters
      if (_selectedFilters.contains("all")) {
        return true;
      }

      for (String filter in _selectedFilters) {
        switch (filter) {
          case "rice":
            if ((field["cropType"] as String? ?? "").toLowerCase() == "rice")
              return true;
            break;
          case "wheat":
            if ((field["cropType"] as String? ?? "").toLowerCase() == "wheat")
              return true;
            break;
          case "corn":
            if ((field["cropType"] as String? ?? "").toLowerCase() == "corn")
              return true;
            break;
          case "cotton":
            if ((field["cropType"] as String? ?? "").toLowerCase() == "cotton")
              return true;
            break;
          case "sugarcane":
            if ((field["cropType"] as String? ?? "").toLowerCase() ==
                "sugarcane") return true;
            break;
          case "recent":
            final daysSincePlanting =
                int.tryParse(field["daysSincePlanting"] as String? ?? "0") ?? 0;
            if (daysSincePlanting <= 60) return true;
            break;
          case "healthy":
            final status =
                (field["healthStatus"] as String? ?? "").toLowerCase();
            if (status == "excellent" || status == "good") return true;
            break;
          case "attention":
            final status =
                (field["healthStatus"] as String? ?? "").toLowerCase();
            if (status == "fair" || status == "poor") return true;
            break;
        }
      }
      return false;
    }).toList();
  }

  void _onFieldTap(Map<String, dynamic> field) {
    _showFieldQuickInfo(field);
  }

  void _onFieldLongPress(Map<String, dynamic> field) {
    _showFieldDetailView(field);
  }

  void _showFieldQuickInfo(Map<String, dynamic> field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(field["fieldName"] as String? ?? "Field Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Crop: ${field["cropType"] ?? "Unknown"}"),
            Text("Area: ${field["area"] ?? "0"} acres"),
            Text("Health: ${field["healthStatus"] ?? "Unknown"}"),
            Text("Growth Stage: ${field["growthStage"] ?? "Unknown"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFieldDetailView(field);
            },
            child: const Text("View Details"),
          ),
        ],
      ),
    );
  }

  void _showFieldDetailView(Map<String, dynamic> field) {
    // Navigate to detailed field view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Opening detailed view for ${field["fieldName"]}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onEditField(Map<String, dynamic> field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Edit ${field["fieldName"]}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onViewHistory(Map<String, dynamic> field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("View history for ${field["fieldName"]}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAddActivity(Map<String, dynamic> field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Add activity to ${field["fieldName"]}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSetReminder(Map<String, dynamic> field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Set reminder for ${field["fieldName"]}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAddField() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Field"),
        content: const Text(
            "GPS boundary marking tool will be launched to create a new field."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("GPS boundary marking tool launched"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Start GPS Tracking"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = ThemeProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            'Farm Management',
            key: ValueKey('title'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 2.0,
        actions: [
          AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: 1.0,
            child: IconButton(
              onPressed: () => themeProvider?.toggleTheme(),
              icon: CustomIconWidget(
                iconName: theme.brightness == Brightness.dark
                    ? 'light_mode'
                    : 'dark_mode',
                color: theme.appBarTheme.foregroundColor ?? Colors.white,
                size: 24,
              ),
              tooltip: theme.brightness == Brightness.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to farm settings
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
              size: 24,
            ),
            tooltip: 'Farm Settings',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey('main_content'),
          children: [
            // Farm Overview Card with animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _headerAnimationController,
                curve: Curves.easeOut,
              )),
              child: FadeTransition(
                opacity: _headerAnimationController,
                child: FarmOverviewCard(farmData: _farmData),
              ),
            ),

            // Interactive Map with animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _headerAnimationController,
                curve: Curves.easeOut,
              )),
              child: InteractiveFarmMap(
                fields: _fieldsData,
                onFieldTap: _onFieldTap,
                onFieldLongPress: _onFieldLongPress,
              ),
            ),

            SizedBox(height: 2.h),

            // Search Bar with animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _headerAnimationController,
                curve: Curves.easeOut,
              )),
              child: FieldSearchBar(
                onChanged: _onSearchChanged,
                onClear: () => _onSearchChanged(""),
              ),
            ),

            // Filter Chips with animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _headerAnimationController,
                curve: Curves.easeOut,
              )),
              child: FilterChipsRow(
                selectedFilters: _selectedFilters,
                onFilterToggle: _onFilterToggle,
                onClearAll: _onClearFilters,
              ),
            ),

            // Fields List Header with animation
            FadeTransition(
              opacity: _listAnimationController,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        'Fields (${_filteredFields.length})',
                        key: ValueKey(_filteredFields.length),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (_filteredFields.length != _fieldsData.length)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: 1.0,
                        child: Text(
                          'Filtered from ${_fieldsData.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Fields List with animation
            Expanded(
              child: _filteredFields.isEmpty
                  ? FadeTransition(
                      opacity: _listAnimationController,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: 1.0,
                              child: CustomIconWidget(
                                iconName: 'search_off',
                                color: theme.textTheme.bodySmall?.color ??
                                    Colors.grey,
                                size: 48,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 600),
                              opacity: 1.0,
                              child: Text(
                                'No fields found',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 700),
                              opacity: 1.0,
                              child: Text(
                                'Try adjusting your search or filters',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AnimatedList(
                      initialItemCount: _filteredFields.length,
                      itemBuilder: (context, index, animation) {
                        if (index >= _filteredFields.length) return Container();
                        final field = _filteredFields[index];
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          )),
                          child: FadeTransition(
                            opacity: animation,
                            child: FieldListCard(
                              field: field,
                              onEdit: _onEditField,
                              onViewHistory: _onViewHistory,
                              onAddActivity: _onAddActivity,
                              onSetReminder: _onSetReminder,
                              onTap: () => _onFieldTap(field),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _listAnimationController,
            curve: Curves.elasticOut,
          ),
        ),
        child: AddFieldFab(
          onPressed: _onAddField,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
