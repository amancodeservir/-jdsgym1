import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rkfitness/presentation/view/attandance_calander.dart';

class StaffActivityScreen extends StatefulWidget {
  @override
  _StaffActivityScreenState createState() => _StaffActivityScreenState();
}

class _StaffActivityScreenState extends State<StaffActivityScreen> {
  DateTime _selectedDate = DateTime.now();
  var _selectedLable = "Today";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(),
            const SizedBox(height: 20),
            _buildCalendar(_selectedDate),
            const SizedBox(height: 20),
            _buildPresenceToggle(),
            const SizedBox(height: 20),
            _buildCalorieExpenditureGraph(),
            const SizedBox(height: 20),
            _buildHealthGraph(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              _buildFilterChip('Today'),
              const SizedBox(width: 8),
              _buildFilterChip('Yesterday'),
              const SizedBox(width: 8),
              _buildFilterChip('Last 7 days'),
              const SizedBox(width: 8),
              _buildFilterChip('Last Month'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return CupertinoButton(
      onPressed: () {
        setState(() {
          _updateSelectedDate(label);
        });
      },
      padding: EdgeInsets.zero,
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.blue[100],
        labelStyle: TextStyle(color: Colors.blue[900]),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _updateSelectedDate(String label) {
    switch (label) {
      case 'Today':
        _selectedDate = DateTime.now();
        break;
      case 'Yesterday':
        _selectedDate = DateTime.now().subtract(const Duration(days: 1));
        break;
      case 'Last 7 days':
        _selectedDate = DateTime.now().subtract(const Duration(days: 7));
        break;
      case 'Last Month':
        _selectedDate = DateTime.now().subtract(const Duration(days: 31));
        break;
      default:
        break;
    }
  }

  Widget _buildCalendar(DateTime selectedDate) {
    return AttandanceCalendar(
        datesToShow: _getDatesToShow('Today', selectedDate));
  }

  List<DateTime> _getDatesToShow(String filter, DateTime selectedDate) {
    List<DateTime> dates = [];

    switch (filter) {
      case 'Today':
        dates.add(selectedDate);
        break;
      case 'Yesterday':
        dates.add(selectedDate
            .subtract(const Duration(days: 1))); // Add only yesterday
        break;
      case 'Last 7 days':
        for (int i = 0; i < 7; i++) {
          dates.add(selectedDate.subtract(Duration(days: i)));
        }
        break;
      case 'Last Month':
        DateTime firstDayOfMonth =
            DateTime(selectedDate.year, selectedDate.month, 1);
        DateTime lastDayOfPreviousMonth =
            firstDayOfMonth.subtract(const Duration(days: 1));
        int daysInPreviousMonth = lastDayOfPreviousMonth.day;
        for (int i = 0; i < daysInPreviousMonth; i++) {
          dates.add(lastDayOfPreviousMonth.subtract(Duration(days: i)));
        }
        break;
      default:
        break;
    }

    return dates.reversed
        .toList(); // Reverse the list to display dates in ascending order
  }

  Widget _buildPresenceToggle() {
    return Container(
      child: Row(
        children: [
          const Text('Present'),
          Switch(
            value: false,
            onChanged: (value) {
              // Handle toggle change
            },
          ),
          const Text('Absent'),
        ],
      ),
    );
  }

  Widget _buildCalorieExpenditureGraph() {
    // Implement calorie expenditure graph widget here
    return Container(
      height: 200,
      color: Colors.grey[200],
      // Your calorie expenditure graph widget goes here
    );
  }

  Widget _buildHealthGraph() {
    // Implement health graph widget here
    return Container(
      height: 200,
      color: Colors.grey[200],
      // Your health graph widget goes here
    );
  }
}
