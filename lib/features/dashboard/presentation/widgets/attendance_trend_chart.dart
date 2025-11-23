import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;
import '../../domain/models/rider_attendance.dart';

class AttendanceTrendChart extends StatelessWidget {
  final List<RiderAttendance> riders;

  const AttendanceTrendChart({
    super.key,
    required this.riders,
  });

  @override
  Widget build(BuildContext context) {
    if (riders.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات لعرضها'),
      );
    }

    // Get all unique dates from all riders
    final Set<DateTime> allDates = {};
    for (var rider in riders) {
      for (var day in rider.days) {
        allDates.add(day.date);
      }
    }

    if (allDates.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات حضور'),
      );
    }

    final sortedDates = allDates.toList()..sort();
    final Map<DateTime, int> attendanceCounts = {};

    // Count attendance for each date
    for (var date in sortedDates) {
      int count = 0;
      for (var rider in riders) {
        if (rider.days.any((d) => d.date == date && d.isPresent)) {
          count++;
        }
      }
      attendanceCounts[date] = count;
    }

    // Take last 7 days
    final recentDates = sortedDates.length > 7
        ? sortedDates.sublist(sortedDates.length - 7)
        : sortedDates;

    final spots = recentDates
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              attendanceCounts[entry.value]!.toDouble(),
            ))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= recentDates.length) {
                  return const Text('');
                }
                final date = recentDates[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    intl.DateFormat('dd/MM').format(date),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        minX: 0,
        maxX: (recentDates.length - 1).toDouble(),
        minY: 0,
        maxY: (riders.length + 2).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green.shade400,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green.shade400,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.shade400.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
