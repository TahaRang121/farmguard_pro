import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/alert_banner_widget.dart';
import './widgets/crop_monitoring_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/farm_overview_widget.dart';
import './widgets/weather_card_widget.dart';

class FarmDashboard extends StatefulWidget {
  const FarmDashboard({super.key});

  @override
  State<FarmDashboard> createState() => _FarmDashboardState();
}

class _FarmDashboardState extends State<FarmDashboard> {
  bool _isLoading = false;
  bool _isOffline = false;
  DateTime _lastSyncTime = DateTime.now();

  // Mock data for weather
  final Map<String, dynamic> _weatherData = {
    "location": "Pune, Maharashtra",
    "temperature": 28,
    "condition": "Partly Cloudy",
    "icon": "wb_cloudy",
    "humidity": 65,
    "windSpeed": 12,
    "visibility": 8,
  };

  // Mock data for farm overview
  final Map<String, dynamic> _farmData = {
    "totalArea": 15.5,
    "activeCrops": 4,
    "healthScore": 85,
  };

  // Mock data for crops
  final List<Map<String, dynamic>> _cropsList = [
    {
      "id": 1,
      "name": "Wheat Field A",
      "fieldSection": "A1",
      "healthStatus": "Healthy",
      "lastInspection": "2 days ago",
      "area": 4.2,
      "growthStage": "Flowering",
      "image":
          "https://images.pexels.com/photos/2589457/pexels-photo-2589457.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "id": 2,
      "name": "Tomato Greenhouse",
      "fieldSection": "B2",
      "healthStatus": "Warning",
      "lastInspection": "1 day ago",
      "area": 2.8,
      "growthStage": "Fruiting",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "id": 3,
      "name": "Rice Paddy",
      "fieldSection": "C1",
      "healthStatus": "Healthy",
      "lastInspection": "3 days ago",
      "area": 6.5,
      "growthStage": "Tillering",
      "image":
          "https://images.pexels.com/photos/1459339/pexels-photo-1459339.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "id": 4,
      "name": "Sugarcane Field",
      "fieldSection": "D1",
      "healthStatus": "Critical",
      "lastInspection": "5 days ago",
      "area": 2.0,
      "growthStage": "Maturation",
      "image":
          "https://images.pexels.com/photos/2589063/pexels-photo-2589063.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
  ];

  // Mock data for alerts
  final List<Map<String, dynamic>> _alertsList = [
    {
      "id": 1,
      "type": "disease",
      "title": "Disease Detected",
      "message":
          "Leaf blight detected in Tomato Greenhouse B2. Immediate action required.",
      "timestamp": "2 hours ago",
      "cropId": 2,
    },
    {
      "id": 2,
      "type": "irrigation",
      "title": "Irrigation Needed",
      "message":
          "Soil moisture low in Rice Paddy C1. Schedule irrigation within 24 hours.",
      "timestamp": "4 hours ago",
      "cropId": 3,
    },
    {
      "id": 3,
      "type": "weather",
      "title": "Weather Alert",
      "message":
          "Heavy rainfall expected tomorrow. Protect sensitive crops and check drainage.",
      "timestamp": "6 hours ago",
      "cropId": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isOffline = false; // Mock online status
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastSyncTime = DateTime.now();
    });

    Fluttertoast.showToast(
      msg: "Farm data updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onScanCrop() {
    Navigator.pushNamed(context, '/crop-health-scanner');
  }

  void _onAddCrop() {
    Navigator.pushNamed(context, '/farm-management');
  }

  void _onTakePhoto(Map<String, dynamic> cropData) {
    Navigator.pushNamed(context, '/crop-health-scanner');
  }

  void _onViewHistory(Map<String, dynamic> cropData) {
    Fluttertoast.showToast(
      msg: "Viewing history for ${cropData["name"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onSetReminder(Map<String, dynamic> cropData) {
    Fluttertoast.showToast(
      msg: "Reminder set for ${cropData["name"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onEditDetails(Map<String, dynamic> cropData) {
    Navigator.pushNamed(context, '/farm-management');
  }

  void _onViewAnalytics(Map<String, dynamic> cropData) {
    Fluttertoast.showToast(
      msg: "Analytics for ${cropData["name"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onShareReport(Map<String, dynamic> cropData) {
    Fluttertoast.showToast(
      msg: "Sharing report for ${cropData["name"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onAlertTap(Map<String, dynamic> alertData) {
    final cropId = alertData["cropId"];
    if (cropId != null) {
      final crop = _cropsList.firstWhere(
        (crop) => crop["id"] == cropId,
        orElse: () => {},
      );
      if (crop.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Navigating to ${crop["name"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  void _onDismissAlert(Map<String, dynamic> alertData) {
    setState(() {
      _alertsList.removeWhere((alert) => alert["id"] == alertData["id"]);
    });

    Fluttertoast.showToast(
      msg: "Alert dismissed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "FarmGuard Pro",
        showBackButton: false,
        actions: [
          if (_isOffline)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName: "cloud_off",
                size: 6.w,
                color: theme.colorScheme.error,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: CustomIconWidget(
              iconName: "gps_fixed",
              size: 6.w,
              color: theme.colorScheme.primary,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: CustomIconWidget(
              iconName: "signal_cellular_4_bar",
              size: 6.w,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child:
            _cropsList.isEmpty ? _buildEmptyState() : _buildDashboardContent(),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onScanCrop,
        icon: CustomIconWidget(
          iconName: "camera_alt",
          size: 6.w,
          color: theme.floatingActionButtonTheme.foregroundColor,
        ),
        label: Text(
          "Scan Crop",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.floatingActionButtonTheme.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          WeatherCardWidget(weatherData: _weatherData),
          SizedBox(height: 20.h),
          EmptyStateWidget(onAddCrop: _onAddCrop),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Offline indicator
          if (_isOffline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: "cloud_off",
                    size: 4.w,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "Offline mode - Last sync: ${_formatTime(_lastSyncTime)}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),

          // Weather card
          WeatherCardWidget(weatherData: _weatherData),

          // Farm overview
          FarmOverviewWidget(farmData: _farmData),

          // Critical alerts
          if (_alertsList.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: "warning",
                    size: 5.w,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "Critical Alerts",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            ..._alertsList.map((alert) => AlertBannerWidget(
                  alertData: alert,
                  onTap: () => _onAlertTap(alert),
                  onDismiss: () => _onDismissAlert(alert),
                )),
          ],

          // Crop monitoring section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Crop Monitoring",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/farm-management'),
                  child: Text(
                    "View All",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Crop cards
          ..._cropsList.map((crop) => CropMonitoringCardWidget(
                cropData: crop,
                onTakePhoto: () => _onTakePhoto(crop),
                onViewHistory: () => _onViewHistory(crop),
                onSetReminder: () => _onSetReminder(crop),
                onEditDetails: () => _onEditDetails(crop),
                onViewAnalytics: () => _onViewAnalytics(crop),
                onShareReport: () => _onShareReport(crop),
              )),

          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }
}
