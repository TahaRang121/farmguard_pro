import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

class BookingCalendarWidget extends StatefulWidget {
  final Map<String, dynamic> expert;
  final Function(DateTime, String) onSlotBooked;

  const BookingCalendarWidget({
    super.key,
    required this.expert,
    required this.onSlotBooked,
  });

  @override
  State<BookingCalendarWidget> createState() => _BookingCalendarWidgetState();
}

class _BookingCalendarWidgetState extends State<BookingCalendarWidget> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTimeSlot;

  final Map<DateTime, List<String>> _availableSlots = {
    DateTime.now(): ['09:00 AM', '11:00 AM', '02:00 PM', '04:00 PM'],
    DateTime.now().add(const Duration(days: 1)): [
      '10:00 AM',
      '01:00 PM',
      '03:00 PM',
      '05:00 PM'
    ],
    DateTime.now().add(const Duration(days: 2)): [
      '09:00 AM',
      '12:00 PM',
      '03:00 PM'
    ],
    DateTime.now().add(const Duration(days: 3)): [
      '11:00 AM',
      '02:00 PM',
      '04:00 PM',
      '06:00 PM'
    ],
    DateTime.now().add(const Duration(days: 4)): [
      '09:00 AM',
      '01:00 PM',
      '04:00 PM'
    ],
    DateTime.now().add(const Duration(days: 7)): [
      '10:00 AM',
      '12:00 PM',
      '02:00 PM',
      '05:00 PM'
    ],
    DateTime.now().add(const Duration(days: 8)): [
      '09:00 AM',
      '11:00 AM',
      '03:00 PM'
    ],
  };

  final Set<DateTime> _bookedSlots = {
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 5)),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final consultationFee = widget.expert["consultationFee"] as String? ?? "₹0";

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
                  'Book Consultation',
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
                  _buildExpertInfo(context),
                  SizedBox(height: 3.h),
                  _buildCalendar(context),
                  SizedBox(height: 3.h),
                  _buildTimeSlots(context),
                  SizedBox(height: 3.h),
                  _buildConsultationTypes(context),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Consultation Fee:',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      consultationFee,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _selectedTimeSlot != null ? _bookConsultation : null,
                    child: Text('Book Consultation'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: widget.expert["profileImage"] as String? ?? "",
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expert["name"] as String? ?? "Expert",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.expert["specialization"] as String? ?? "Agriculture",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${widget.expert["rating"] ?? 0.0}",
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "• ${widget.expert["experience"] ?? 0} years",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: TableCalendar<String>(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            availableGestures: AvailableGestures.all,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              defaultTextStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
              selectedTextStyle: const TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ) ??
                  const TextStyle(),
              leftChevronIcon: CustomIconWidget(
                iconName: 'chevron_left',
                color: theme.textTheme.bodyLarge?.color,
                size: 24,
              ),
              rightChevronIcon: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.textTheme.bodyLarge?.color,
                size: 24,
              ),
            ),
            eventLoader: (day) {
              return _availableSlots[DateTime(day.year, day.month, day.day)] ??
                  [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedTimeSlot = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDateKey =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final availableSlots = _availableSlots[selectedDateKey] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        availableSlots.isEmpty
            ? Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'No slots available for this date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: availableSlots.map((slot) {
                  final isSelected = slot == _selectedTimeSlot;
                  final isBooked = _bookedSlots.contains(selectedDateKey);

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () {
                            setState(() => _selectedTimeSlot = slot);
                          },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isBooked
                            ? theme.colorScheme.surface.withValues(alpha: 0.5)
                            : isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isBooked
                              ? theme.dividerColor.withValues(alpha: 0.5)
                              : isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : theme.dividerColor,
                        ),
                      ),
                      child: Text(
                        slot,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isBooked
                              ? theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5)
                              : isSelected
                                  ? Colors.white
                                  : theme.textTheme.bodyMedium?.color,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildConsultationTypes(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consultation Type',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'video_call',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video Consultation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Face-to-face consultation with screen sharing',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.expert["consultationFee"] as String? ?? "₹0",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Includes: 30-minute consultation, crop analysis, and follow-up recommendations',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _bookConsultation() {
    if (_selectedTimeSlot != null) {
      widget.onSlotBooked(_selectedDay, _selectedTimeSlot!);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Consultation booked for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year} at $_selectedTimeSlot',
          ),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    }
  }
}
