import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';
import 'package:rkfitness/presentation/view/attandance_calander.dart';
import 'package:rkfitness/presentation/view/helth_graph.dart';
import 'package:rkfitness/presentation/view/present_tonggle.dart';

class MemberActivityScreen extends StatefulWidget {
  @override
  _MemberActivityScreenState createState() => _MemberActivityScreenState();
}

class _MemberActivityScreenState extends State<MemberActivityScreen> {
  final UserController userController = Get.find<UserController>();
  DateTime _selectedDate = DateTime.now();
  String _selectedLabel = "Today";
  String _selectedPeriod = 'Weekly';
  bool isPresent = false;
  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Map<DateTime, bool> attendanceData =
          userController.attendanceDatas.value ?? {};
      isPresent = attendanceData[normalizeDate(DateTime.now())] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[200],
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[400]!,
                ),
              ),
              child: Column(
                children: [
                  _buildFilterSection(),
                  const SizedBox(height: 20),
                  _buildCalendar(_selectedDate),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildPresenceToggle(isPresent),
            const SizedBox(height: 20),
            _buildCalorieExpenditureGraph(context),
            const SizedBox(height: 20),
            _buildHealthCount(context),
            const SizedBox(height: 20),
            HealthGraph(),

          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    ThemeData theme = Theme.of(context);
    Color containerColor = theme.brightness == Brightness.dark
        ? Colors.grey[200]!
        : Colors.grey[200]!;
    Color textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    Color textColor2 =
        theme.brightness == Brightness.dark ? Colors.white : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Attendance',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildFilterChip('Today', theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Yesterday', theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Last 7 days', theme),
                  const SizedBox(width: 8),
                  _buildFilterChip('Last Month', theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme) {
    Color containerColor = theme.brightness == Brightness.dark
        ? Colors.grey[200]!
        : Colors.grey[200]!;
    return GestureDetector(
      onTap: () {
        setState(() {
          _updateSelectedDate(label);
        });
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _selectedLabel == label
                ? Colors.white
                : theme.brightness == Brightness.dark
                    ? Colors.grey
                    : Colors.black,
          ),
        ),
      
        backgroundColor:
            _selectedLabel == label ? AppColors.greenColor : containerColor,
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _updateSelectedDate(String label) {
    setState(() {
      _selectedLabel = label;
    });
  }

  Widget _buildCalendar(DateTime selectedDate) {
    Map<DateTime, bool> attendanceData =
        userController.attendanceDatas.value ?? {};
    return AttendanceCalendar(
        datesToShow: _getDatesToShow(_selectedLabel, selectedDate),
        attendanceData: attendanceData);
  }

  List<DateTime> _getDatesToShow(String filter, DateTime selectedDate) {
    List<DateTime> dates = [];

    switch (filter) {
      case 'Today':
        dates.add(DateTime.now());
        break;
      case 'Yesterday':
        dates.add(DateTime.now().subtract(const Duration(days: 1)));
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

  Widget _buildPresenceToggle(bool isPresent) {
    return Center(
      child: PresenceToggle(
        isPresent: isPresent,
        onChanged: (value) {
          setState(() {
            isPresent = value;
          });
        },
      ),
    );
  }

 Widget _buildCalorieExpenditureGraph(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color containerColor = theme.brightness == Brightness.dark
        ? Colors.grey[850]!
        : Colors.grey[200]!;
    Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color subTextColor = theme.brightness == Brightness.dark
        ? Colors.grey[400]!
        : Colors.grey[600]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calorie expenditure',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Burn around 2,000-3,000 calories',
            style: TextStyle(
              fontSize: 14,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 20),
   
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: containerColor,
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
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? Colors.blue[300]
                                : Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '75%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Great!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Today’s Plan is more than half done Keep her steady!',
                          style: TextStyle(
                            fontSize: 14,
                            color: subTextColor,
                          ),
                        ),
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

Widget _buildHealthCount(BuildContext context) {
  ThemeData theme = Theme.of(context);
  Color cardColor = theme.cardColor;
  Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: _buildHealthCard(
          title: 'Exercise',
          count: '12',
          subtitle: 'times/week',
          color: Colors.blue,
          icon: Icons.fitness_center,
          cardColor: cardColor,
          textColor: textColor,
        ),
      ),
      Expanded(
        child: _buildHealthCard(
          title: 'Calories',
          count: '2000',
          subtitle: 'cal/day',
          color: Colors.orange,
          icon: Icons.local_fire_department,
          cardColor: cardColor,
          textColor: textColor,
        ),
      ),
      Expanded(
        child: _buildHealthCard(
          title: 'Minutes',
          count: '150',
          subtitle: 'min/week',
          color: Colors.green,
          icon: Icons.timer,
          cardColor: cardColor,
          textColor: textColor,
        ),
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
  required Color cardColor,
  required Color textColor,
}) {
  return Card(
    color: cardColor,
    elevation: 2, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), 
      side: BorderSide(
        color: Colors.grey[300]!, 
        width: 0.5, 
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
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
              color: textColor,
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
