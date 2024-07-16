import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class AttendanceCalendar extends StatelessWidget {
  final List<DateTime> datesToShow;
  final Map<DateTime, bool> attendanceData;

  const AttendanceCalendar(
      {super.key, required this.datesToShow, required this.attendanceData});

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> normalizedDates =
        datesToShow.map((date) => normalizeDate(date)).toList();
    normalizedDates.sort((a, b) => a.compareTo(b)); // Sort by actual date

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap:
              true, // Make the GridView take up only as much space as it needs
          physics: NeverScrollableScrollPhysics(), // Disable scrolling
          children: List.generate(normalizedDates.length, (index) {
            DateTime date = normalizedDates[index];
            bool isPresent = attendanceData[normalizeDate(date)] ?? false;
            print('Date in calendar: $date');
            print('Attendance data: ${attendanceData[normalizeDate(date)]}');
            print('Attendance data: ${attendanceData}');
            print('Is present: $isPresent');
            return buildDateBox(context, date, isPresent);
          }),
        ),
      ],
    );
  }

  Widget buildDateBox(BuildContext context, DateTime date, bool isPresent) {
    Color borderColor = isPresent ? Colors.transparent : Colors.red;
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? (isPresent ? Colors.white : Colors.black)
        : (isPresent ? Colors.white : Colors.black);

    return Container(
      decoration: BoxDecoration(
        color: isPresent ? AppColors.greenColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getDayOfWeek(date),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: textColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
