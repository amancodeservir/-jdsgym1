import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class AttandanceCalendar extends StatelessWidget {
  final List<DateTime> datesToShow;

  AttandanceCalendar({required this.datesToShow});

  @override
  Widget build(BuildContext context) {
    datesToShow.sort((a, b) => a.weekday.compareTo(b.weekday));

    return Container(
      height: 200,
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: datesToShow.length,
        itemBuilder: (context, index) {
          return buildDateBox(index, datesToShow[index]);
        },
      ),
    );
  }

  Widget buildDateBox(int index, DateTime date) {
    bool isPresent = index % 2 == 0;
    bool isAbsent = index % 3 == 0;

    return Container(
      decoration: BoxDecoration(
        color: isPresent ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isAbsent ? Colors.red : Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getDayOfWeek(date),
            style: TextStyle(
                color: isPresent ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}',
            style: const TextStyle(fontWeight: FontWeight.bold),
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
