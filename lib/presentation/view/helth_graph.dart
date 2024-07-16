import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthGraph extends StatefulWidget {
  @override
  _HealthGraphState createState() => _HealthGraphState();
}

class _HealthGraphState extends State<HealthGraph> {
  String _selectedPeriod = 'Weekly';

  Widget _buildHealthGraph() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final containerColor = theme.cardColor;
    final borderColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Graph',
            style: theme.textTheme.bodyLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calorie expenditure over time',
                style: theme.textTheme.labelLarge,
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                items:
                    <String>['Weekly', 'Monthly', 'Yearly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: theme.textTheme.bodyLarge),
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
              color: containerColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black54 : Colors.black12,
                  spreadRadius: 0.5,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: borderColor,
                width: 0.5,
              ),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300]!,
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
                        return Text(text,
                            style: style.copyWith(color: primaryTextColor));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        return Text(value.toString(),
                            style: style.copyWith(color: primaryTextColor));
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 2),
                      FlSpot(2, 3),
                      FlSpot(3, 5),
                      FlSpot(4, 1),
                      FlSpot(5, 4),
                      FlSpot(6, 7),
                      FlSpot(7, 3),
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

  @override
  Widget build(BuildContext context) {
    return _buildHealthGraph();
  }
}
