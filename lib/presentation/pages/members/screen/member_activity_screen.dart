import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/view/attandance_calander.dart';

class MemberActivityScreen extends StatefulWidget {
  @override
  _MemberActivityScreenState createState() => _MemberActivityScreenState();
}

class _MemberActivityScreenState extends State<MemberActivityScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedLabel = "Today";
  String _selectedPeriod = 'Weekly';

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
            _buildHealthCount(),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Filters:',
            style: AppStyle.headingBlack,
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _updateSelectedDate(label);
        });
      },
      child: Chip(
        label: Text(label),
        backgroundColor:
            _selectedLabel == label ? AppColors.primaryColor : Colors.blue[100],
        labelStyle: TextStyle(
            color: _selectedLabel == label ? Colors.white : Colors.blue[900]),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _updateSelectedDate(String label) {
    setState(() {
      _selectedLabel = label;
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
    });
  }

  Widget _buildCalendar(DateTime selectedDate) {
    return AttandanceCalendar(
        datesToShow: _getDatesToShow(_selectedLabel, selectedDate));
  }

  List<DateTime> _getDatesToShow(String filter, DateTime selectedDate) {
    List<DateTime> dates = [];

    switch (filter) {
      case 'Today':
        dates.add(selectedDate);
        break;
      case 'Yesterday':
        dates.add(selectedDate.subtract(const Duration(days: 1)));
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
    return dates.reversed.toList();
  }

  Widget _buildPresenceToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }

  Widget _buildCalorieExpenditureGraph() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calorie expenditure',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Burn around 2,000-3,000 calories',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '75%',
                              style: AppStyle.whiteText18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Great!',
                          style: AppStyle.headingBlack,
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Today’s Plan is more than half done Keep her steady!',
                            style: AppStyle.body),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHealthCard(
          title: 'Exercise',
          count: '12',
          subtitle: 'times/week',
          color: Colors.blue,
          icon: Icons.fitness_center,
        ),
        _buildHealthCard(
          title: 'Calories',
          count: '2000',
          subtitle: 'cal/day',
          color: Colors.orange,
          icon: Icons.local_fire_department,
        ),
        _buildHealthCard(
          title: 'Minutes',
          count: '150',
          subtitle: 'min/week',
          color: Colors.green,
          icon: Icons.timer,
        ),
      ],
    );
  }

  Widget _buildHealthCard({
    required String title,
    required String count,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthGraph() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Graph',
            style: AppStyle.heading2Black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calorie expenditure over time',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                items:
                    <String>['Weekly', 'Monthly', 'Yearly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      _selectedPeriod = newValue;
                      // Handle change here to update the graph based on the selected period
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 1:
                            text = 'Mon';
                            break;
                          case 2:
                            text = 'Tue';
                            break;
                          case 3:
                            text = 'Wed';
                            break;
                          case 4:
                            text = 'Thu';
                            break;
                          case 5:
                            text = 'Fri';
                            break;
                          case 6:
                            text = 'Sat';
                            break;
                          case 7:
                            text = 'Sun';
                            break;
                          default:
                            text = '';
                            break;
                        }
                        return Text(text, style: style);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        return Text(value.toString(), style: style);
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(1, 2),
                      const FlSpot(2, 3),
                      const FlSpot(3, 5),
                      const FlSpot(4, 1),
                      const FlSpot(5, 4),
                      const FlSpot(6, 7),
                      const FlSpot(7, 3),
                    ],
                    isCurved: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
