import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_calendar_widget.dart';
import './widgets/consultation_chat_widget.dart';
import './widgets/expert_card_widget.dart';
import './widgets/expert_profile_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class ExpertConsultation extends StatefulWidget {
  const ExpertConsultation({super.key});

  @override
  State<ExpertConsultation> createState() => _ExpertConsultationState();
}

class _ExpertConsultationState extends State<ExpertConsultation>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> _currentFilters = {
    'cropType': 'All Crops',
    'problemCategory': 'All Problems',
    'language': 'All Languages',
    'onlineOnly': false,
    'minRating': 0.0,
  };

  final List<Map<String, dynamic>> _mockExperts = [
    {
      "id": "expert_001",
      "name": "Dr. Rajesh Kumar",
      "profileImage":
          "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg",
      "specialization": "Crop Disease Specialist",
      "specializations": [
        "Disease Diagnosis",
        "Pest Control",
        "Organic Farming",
        "Soil Health"
      ],
      "languages": ["Hindi", "English", "Punjabi"],
      "rating": 4.8,
      "totalReviews": 156,
      "experience": 12,
      "responseTime": "< 2 hours",
      "consultationFee": "₹299",
      "isOnline": true,
      "about":
          "Dr. Rajesh Kumar is a renowned agricultural scientist with over 12 years of experience in crop disease management. He specializes in integrated pest management and sustainable farming practices.",
      "availability": [
        {"day": "Monday", "time": "9:00 AM - 5:00 PM"},
        {"day": "Tuesday", "time": "10:00 AM - 6:00 PM"},
        {"day": "Wednesday", "time": "9:00 AM - 4:00 PM"},
        {"day": "Thursday", "time": "11:00 AM - 7:00 PM"},
        {"day": "Friday", "time": "9:00 AM - 5:00 PM"},
      ],
      "reviews": [
        {
          "farmerName": "Ramesh Patel",
          "rating": 5.0,
          "comment":
              "Excellent guidance on wheat disease management. My crop yield improved by 30% after following his recommendations.",
          "date": "2 days ago"
        },
        {
          "farmerName": "Sunita Devi",
          "rating": 4.5,
          "comment":
              "Very knowledgeable and patient. Helped me identify pest issues early and saved my cotton crop.",
          "date": "1 week ago"
        }
      ]
    },
    {
      "id": "expert_002",
      "name": "Prof. Meera Sharma",
      "profileImage":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg",
      "specialization": "Soil & Nutrition Expert",
      "specializations": [
        "Soil Testing",
        "Fertilizer Management",
        "Nutrient Deficiency",
        "Organic Fertilizers"
      ],
      "languages": ["Hindi", "English", "Marathi"],
      "rating": 4.9,
      "totalReviews": 203,
      "experience": 15,
      "responseTime": "< 1 hour",
      "consultationFee": "₹399",
      "isOnline": true,
      "about":
          "Prof. Meera Sharma is a soil science expert with 15 years of research experience. She helps farmers optimize soil health and nutrient management for maximum productivity.",
      "availability": [
        {"day": "Monday", "time": "8:00 AM - 4:00 PM"},
        {"day": "Wednesday", "time": "10:00 AM - 6:00 PM"},
        {"day": "Friday", "time": "9:00 AM - 5:00 PM"},
        {"day": "Saturday", "time": "10:00 AM - 2:00 PM"},
      ],
      "reviews": [
        {
          "farmerName": "Kiran Singh",
          "rating": 5.0,
          "comment":
              "Amazing soil analysis and fertilizer recommendations. My tomato yield doubled this season!",
          "date": "3 days ago"
        }
      ]
    },
    {
      "id": "expert_003",
      "name": "Dr. Amit Verma",
      "profileImage":
          "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg",
      "specialization": "Irrigation & Water Management",
      "specializations": [
        "Drip Irrigation",
        "Water Conservation",
        "Precision Farming",
        "Smart Irrigation"
      ],
      "languages": ["Hindi", "English", "Gujarati"],
      "rating": 4.7,
      "totalReviews": 89,
      "experience": 8,
      "responseTime": "< 3 hours",
      "consultationFee": "₹249",
      "isOnline": false,
      "about":
          "Dr. Amit Verma specializes in modern irrigation techniques and water management systems. He helps farmers implement efficient irrigation solutions to maximize water usage.",
      "availability": [
        {"day": "Tuesday", "time": "9:00 AM - 5:00 PM"},
        {"day": "Thursday", "time": "10:00 AM - 6:00 PM"},
        {"day": "Saturday", "time": "8:00 AM - 4:00 PM"},
      ],
      "reviews": [
        {
          "farmerName": "Prakash Joshi",
          "rating": 4.5,
          "comment":
              "Great advice on drip irrigation setup. Reduced water usage by 40% while maintaining crop quality.",
          "date": "5 days ago"
        }
      ]
    },
    {
      "id": "expert_004",
      "name": "Dr. Priya Nair",
      "profileImage":
          "https://images.pexels.com/photos/5327656/pexels-photo-5327656.jpeg",
      "specialization": "Organic Farming Consultant",
      "specializations": [
        "Organic Certification",
        "Bio-fertilizers",
        "Natural Pest Control",
        "Sustainable Farming"
      ],
      "languages": ["Hindi", "English", "Tamil", "Malayalam"],
      "rating": 4.6,
      "totalReviews": 124,
      "experience": 10,
      "responseTime": "< 4 hours",
      "consultationFee": "₹349",
      "isOnline": true,
      "about":
          "Dr. Priya Nair is an organic farming specialist who helps farmers transition to sustainable and chemical-free farming practices with proper certification guidance.",
      "availability": [
        {"day": "Monday", "time": "10:00 AM - 6:00 PM"},
        {"day": "Wednesday", "time": "9:00 AM - 5:00 PM"},
        {"day": "Friday", "time": "11:00 AM - 7:00 PM"},
      ],
      "reviews": [
        {
          "farmerName": "Lakshmi Reddy",
          "rating": 5.0,
          "comment":
              "Excellent guidance for organic certification. Now selling my produce at premium prices in organic markets.",
          "date": "1 week ago"
        }
      ]
    },
    {
      "id": "expert_005",
      "name": "Agri. Suresh Patil",
      "profileImage":
          "https://images.pexels.com/photos/5327584/pexels-photo-5327584.jpeg",
      "specialization": "Market & Price Advisor",
      "specializations": [
        "Market Analysis",
        "Price Forecasting",
        "Crop Planning",
        "Value Addition"
      ],
      "languages": ["Hindi", "English", "Marathi", "Kannada"],
      "rating": 4.4,
      "totalReviews": 67,
      "experience": 6,
      "responseTime": "< 6 hours",
      "consultationFee": "₹199",
      "isOnline": false,
      "about":
          "Suresh Patil is a market analyst who helps farmers make informed decisions about crop selection and timing based on market trends and price forecasts.",
      "availability": [
        {"day": "Tuesday", "time": "2:00 PM - 8:00 PM"},
        {"day": "Thursday", "time": "1:00 PM - 7:00 PM"},
        {"day": "Sunday", "time": "10:00 AM - 4:00 PM"},
      ],
      "reviews": [
        {
          "farmerName": "Vijay Kumar",
          "rating": 4.0,
          "comment":
              "Good market insights helped me choose the right crops for this season. Profitable advice.",
          "date": "2 weeks ago"
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> _activeConsultations = [
    {
      "id": "consultation_001",
      "expertId": "expert_001",
      "expertName": "Dr. Rajesh Kumar",
      "expertImage":
          "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg",
      "lastMessage":
          "I'll analyze your crop images and get back with recommendations.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "unreadCount": 2,
      "status": "active",
      "consultationType": "chat"
    },
    {
      "id": "consultation_002",
      "expertId": "expert_002",
      "expertName": "Prof. Meera Sharma",
      "expertImage":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg",
      "lastMessage":
          "Your soil test results show nitrogen deficiency. Let's discuss the solution.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "unreadCount": 0,
      "status": "scheduled",
      "consultationType": "video",
      "scheduledTime": DateTime.now().add(const Duration(hours: 3)),
    },
  ];

  List<Map<String, dynamic>> _filteredExperts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredExperts = List.from(_mockExperts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredExperts = _mockExperts.where((expert) {
        // Apply crop type filter
        if (_currentFilters['cropType'] != 'All Crops') {
          final specializations = expert['specializations'] as List;
          if (!specializations.any((spec) => spec
              .toString()
              .toLowerCase()
              .contains(
                  _currentFilters['cropType'].toString().toLowerCase()))) {
            return false;
          }
        }

        // Apply problem category filter
        if (_currentFilters['problemCategory'] != 'All Problems') {
          final specializations = expert['specializations'] as List;
          if (!specializations.contains(_currentFilters['problemCategory'])) {
            return false;
          }
        }

        // Apply language filter
        if (_currentFilters['language'] != 'All Languages') {
          final languages = expert['languages'] as List;
          if (!languages.contains(_currentFilters['language'])) {
            return false;
          }
        }

        // Apply online filter
        if (_currentFilters['onlineOnly'] == true) {
          if (expert['isOnline'] != true) {
            return false;
          }
        }

        // Apply rating filter
        final rating = expert['rating'] as double? ?? 0.0;
        if (rating < (_currentFilters['minRating'] as double)) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _searchExperts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredExperts = List.from(_mockExperts);
      } else {
        _filteredExperts = _mockExperts.where((expert) {
          final name = expert['name'].toString().toLowerCase();
          final specialization =
              expert['specialization'].toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) ||
              specialization.contains(searchQuery);
        }).toList();
      }
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expert Consultation',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showEmergencyConsultation(context),
            icon: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'emergency',
                color: Colors.red,
                size: 20,
              ),
            ),
            tooltip: 'Emergency Consultation',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.lightTheme.primaryColor,
              unselectedLabelColor:
                  theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              indicatorColor: AppTheme.lightTheme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Find Experts'),
                Tab(text: 'My Consultations'),
                Tab(text: 'History'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFindExpertsTab(context),
                _buildMyConsultationsTab(context),
                _buildHistoryTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindExpertsTab(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Search experts by name or specialization...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.7),
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                        ),
                        onChanged: _searchExperts,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  GestureDetector(
                    onTap: () => _showFilterBottomSheet(context),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'filter_list',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    '${_filteredExperts.length} experts available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  if (_hasActiveFilters())
                    GestureDetector(
                      onTap: _clearFilters,
                      child: Text(
                        'Clear filters',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredExperts.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 2.h),
                  itemCount: _filteredExperts.length,
                  itemBuilder: (context, index) {
                    final expert = _filteredExperts[index];
                    return ExpertCardWidget(
                      expert: expert,
                      onTap: () => _showExpertProfile(context, expert),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMyConsultationsTab(BuildContext context) {
    final theme = Theme.of(context);

    return _activeConsultations.isEmpty
        ? _buildEmptyConsultationsState(context)
        : ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: _activeConsultations.length,
            itemBuilder: (context, index) {
              final consultation = _activeConsultations[index];
              return _buildConsultationCard(context, consultation);
            },
          );
  }

  Widget _buildHistoryTab(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No consultation history',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your past consultations will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(
      BuildContext context, Map<String, dynamic> consultation) {
    final theme = Theme.of(context);
    final timestamp = consultation["timestamp"] as DateTime;
    final unreadCount = consultation["unreadCount"] as int;
    final status = consultation["status"] as String;
    final consultationType = consultation["consultationType"] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _openConsultationChat(context, consultation),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: consultation["expertImage"] as String,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (status == "active")
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.cardColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              consultation["expertName"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (consultationType == "video")
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'video_call',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 12,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Video',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        consultation["lastMessage"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            _formatTimestamp(timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                          if (consultation["scheduledTime"] != null) ...[
                            Text(
                              " • Scheduled: ${_formatScheduledTime(consultation["scheduledTime"] as DateTime)}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No experts found',
              style: theme.textTheme.titleLarge?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search criteria or filters to find the right expert for your needs.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyConsultationsState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No active consultations',
              style: theme.textTheme.titleLarge?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start a consultation with an expert to get personalized farming advice.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: Text('Find Experts'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() => _currentFilters = filters);
          _applyFilters();
        },
      ),
    );
  }

  void _showExpertProfile(BuildContext context, Map<String, dynamic> expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExpertProfileWidget(
        expert: expert,
        onBookConsultation: () {
          Navigator.pop(context);
          _showBookingCalendar(context, expert);
        },
        onStartChat: () {
          Navigator.pop(context);
          _startChatConsultation(context, expert);
        },
      ),
    );
  }

  void _showBookingCalendar(BuildContext context, Map<String, dynamic> expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingCalendarWidget(
        expert: expert,
        onSlotBooked: (date, timeSlot) {
          // Handle booking confirmation
          _addScheduledConsultation(expert, date, timeSlot);
        },
      ),
    );
  }

  void _startChatConsultation(
      BuildContext context, Map<String, dynamic> expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ConsultationChatWidget(
        expert: expert,
        consultationId: "consultation_${DateTime.now().millisecondsSinceEpoch}",
      ),
    );
  }

  void _openConsultationChat(
      BuildContext context, Map<String, dynamic> consultation) {
    final expert = _mockExperts.firstWhere(
      (e) => e["id"] == consultation["expertId"],
      orElse: () => {},
    );

    if (expert.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => ConsultationChatWidget(
          expert: expert,
          consultationId: consultation["id"] as String,
        ),
      );
    }
  }

  void _showEmergencyConsultation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: Colors.red,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Emergency Consultation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get immediate expert help for critical crop issues.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Consultation Features:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• Priority access to available experts\n• Immediate notification to experts\n• 24/7 availability for critical issues\n• Additional fee: ₹199',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initiateEmergencyConsultation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Start Emergency Chat'),
          ),
        ],
      ),
    );
  }

  void _addScheduledConsultation(
      Map<String, dynamic> expert, DateTime date, String timeSlot) {
    setState(() {
      _activeConsultations.insert(0, {
        "id": "consultation_${DateTime.now().millisecondsSinceEpoch}",
        "expertId": expert["id"],
        "expertName": expert["name"],
        "expertImage": expert["profileImage"],
        "lastMessage": "Consultation scheduled for $timeSlot",
        "timestamp": DateTime.now(),
        "unreadCount": 0,
        "status": "scheduled",
        "consultationType": "video",
        "scheduledTime": DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(timeSlot.split(':')[0]),
            int.parse(timeSlot.split(':')[1].split(' ')[0])),
      });
    });
  }

  void _initiateEmergencyConsultation() {
    // Find first available online expert
    final availableExpert = _mockExperts.firstWhere(
      (expert) => expert["isOnline"] == true,
      orElse: () => _mockExperts.first,
    );

    _startChatConsultation(context, availableExpert);
  }

  bool _hasActiveFilters() {
    return _currentFilters['cropType'] != 'All Crops' ||
        _currentFilters['problemCategory'] != 'All Problems' ||
        _currentFilters['language'] != 'All Languages' ||
        _currentFilters['onlineOnly'] == true ||
        (_currentFilters['minRating'] as double) > 0.0;
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = {
        'cropType': 'All Crops',
        'problemCategory': 'All Problems',
        'language': 'All Languages',
        'onlineOnly': false,
        'minRating': 0.0,
      };
      _searchController.clear();
      _filteredExperts = List.from(_mockExperts);
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatScheduledTime(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    }
  }
}
