import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/models/rider_attendance.dart';

class AttendancePieChart extends StatelessWidget {
  final List<RiderAttendance> riders;

  const AttendancePieChart({
    super.key,
    required this.riders,
  });

  @override
  Widget build(BuildContext context) {
    final presentCount = riders.where((r) => r.days.any((d) => d.isPresent)).length;
    final absentCount = riders.length - presentCount;
    
    // Avoid division by zero
    if (riders.isEmpty) {
      return const Center(
        child: Text('لا توجد بيانات لعرضها'),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.green.shade400,
            value: presentCount.toDouble(),
            title: '$presentCount',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.red.shade400,
            value: absentCount.toDouble(),
            title: '$absentCount',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
