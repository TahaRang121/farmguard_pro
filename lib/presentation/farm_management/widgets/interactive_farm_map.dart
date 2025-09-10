import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class InteractiveFarmMap extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final Function(Map<String, dynamic>)? onFieldTap;
  final Function(Map<String, dynamic>)? onFieldLongPress;

  const InteractiveFarmMap({
    super.key,
    required this.fields,
    this.onFieldTap,
    this.onFieldLongPress,
  });

  @override
  State<InteractiveFarmMap> createState() => _InteractiveFarmMapState();
}

class _InteractiveFarmMapState extends State<InteractiveFarmMap>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  MapType _currentMapType = MapType.hybrid;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Center of India
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _createMarkersAndPolygons();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _createMarkersAndPolygons() async {
    _markers.clear();
    _polygons.clear();

    for (int i = 0; i < widget.fields.length; i++) {
      final field = widget.fields[i];
      final fieldId = field["id"].toString();
      final coordinates = field["coordinates"] as List<dynamic>?;

      if (coordinates != null && coordinates.isNotEmpty) {
        final latLng = LatLng(
          (coordinates[0] as Map<String, dynamic>)["lat"] as double,
          (coordinates[0] as Map<String, dynamic>)["lng"] as double,
        );

        // Create animated marker
        _markers.add(
          Marker(
            markerId: MarkerId(fieldId),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                _getHealthHue(field["healthStatus"] as String? ?? "Good")),
            infoWindow: InfoWindow(
              title: field["fieldName"] as String? ?? "Field $fieldId",
              snippet:
                  "${field["cropType"] ?? "Unknown"} - ${field["area"] ?? "0"} acres",
              onTap: () => widget.onFieldTap?.call(field),
            ),
            onTap: () => widget.onFieldTap?.call(field),
          ),
        );

        // Create animated polygon if coordinates form a boundary
        if (coordinates.length > 2) {
          final polygonPoints = coordinates.map<LatLng>((coord) {
            final coordMap = coord as Map<String, dynamic>;
            return LatLng(coordMap["lat"] as double, coordMap["lng"] as double);
          }).toList();

          _polygons.add(
            Polygon(
              polygonId: PolygonId(fieldId),
              points: polygonPoints,
              strokeColor:
                  _getHealthColor(field["healthStatus"] as String? ?? "Good"),
              strokeWidth: 2,
              fillColor:
                  _getHealthColor(field["healthStatus"] as String? ?? "Good")
                      .withValues(alpha: 0.2),
              onTap: () => widget.onFieldLongPress?.call(field),
            ),
          );
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                color: theme.cardColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Loading Map...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              FadeTransition(
                opacity: _fadeAnimation,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _setMapStyle(controller, theme);
                  },
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polygons: _polygons,
                  mapType: _currentMapType,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  onTap: (LatLng position) {
                    // Handle map tap for adding new fields
                  },
                ),
              ),
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Column(
                children: [
                  _buildAnimatedMapControlButton(
                    context,
                    'my_location',
                    () => _goToCurrentLocation(),
                    'Go to my location',
                  ),
                  SizedBox(height: 1.h),
                  _buildAnimatedMapControlButton(
                    context,
                    'layers',
                    () => _toggleMapType(),
                    'Toggle map type',
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 2.h,
              left: 4.w,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: _isLoading ? const Offset(-1, 0) : Offset.zero,
                child: _buildMapLegend(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedMapControlButton(BuildContext context, String iconName,
      VoidCallback onPressed, String tooltip) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 12.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: 1.0,
            child: Tooltip(
              message: tooltip,
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapLegend(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Field Health',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          _buildLegendItem(context, 'Excellent', const Color(0xFF4CAF50)),
          _buildLegendItem(context, 'Good', const Color(0xFF8BC34A)),
          _buildLegendItem(context, 'Fair', const Color(0xFFFF9800)),
          _buildLegendItem(context, 'Poor', const Color(0xFFF44336)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 3.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied'),
            ),
          );
          return;
        }
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition();

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get current location: $e'),
        ),
      );
    }
  }

  void _toggleMapType() {
    setState(() {
      switch (_currentMapType) {
        case MapType.normal:
          _currentMapType = MapType.satellite;
          break;
        case MapType.satellite:
          _currentMapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _currentMapType = MapType.normal;
          break;
        default:
          _currentMapType = MapType.normal;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Map type changed to ${_getMapTypeName(_currentMapType)}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _getMapTypeName(MapType mapType) {
    switch (mapType) {
      case MapType.normal:
        return 'Normal';
      case MapType.satellite:
        return 'Satellite';
      case MapType.hybrid:
        return 'Hybrid';
      default:
        return 'Normal';
    }
  }

  Future<void> _setMapStyle(
      GoogleMapController controller, ThemeData theme) async {
    if (theme.brightness == Brightness.dark) {
      // Dark mode map style
      const String darkMapStyle = '''
      [
        {
          "elementType": "geometry",
          "stylers": [{"color": "#212121"}]
        },
        {
          "elementType": "labels.icon",
          "stylers": [{"visibility": "off"}]
        },
        {
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#757575"}]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [{"color": "#212121"}]
        },
        {
          "featureType": "administrative",
          "elementType": "geometry",
          "stylers": [{"color": "#757575"}]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [{"color": "#000000"}]
        }
      ]
      ''';
      controller.setMapStyle(darkMapStyle);
    } else {
      // Clear style for light mode
      controller.setMapStyle(null);
    }
  }

  double _getHealthHue(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return BitmapDescriptor.hueGreen;
      case 'good':
        return BitmapDescriptor.hueYellow;
      case 'fair':
        return BitmapDescriptor.hueOrange;
      case 'poor':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  Color _getHealthColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF8BC34A);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
