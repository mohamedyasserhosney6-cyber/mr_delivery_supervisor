import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/rider_attendance.dart';
import '../providers/attendance_providers.dart';

class StatsCard extends ConsumerWidget {
  final List<RiderAttendance> riders;

  const StatsCard({super.key, required this.riders});

  int getTotalRiders() => riders.length;

  int getPresentCount(DateTime selectedDate) {
    return riders.where((rider) {
      final attendance = rider.getAttendanceForDate(selectedDate);
      return attendance?.isPresent ?? false;
    }).length;
  }

  int getAbsentCount(DateTime selectedDate) {
    return getTotalRiders() - getPresentCount(selectedDate);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final presentCount = getPresentCount(selectedDate);
    final absentCount = getAbsentCount(selectedDate);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'إجمالي الطيارين',
              value: getTotalRiders().toString(),
              icon: Icons.people,
              color: Colors.blue,
            ),
            _StatItem(
              label: 'حاضر',
              value: presentCount.toString(),
              icon: Icons.check_circle,
              color: const Color(0xFF00c853),
            ),
            _StatItem(
              label: 'غياب',
              value: absentCount.toString(),
              icon: Icons.cancel,
              color: const Color(0xFFFF5252),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

