import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_providers.dart';
import '../../domain/models/rider_attendance.dart';
import '../../domain/models/attendance_day.dart';
import '../../domain/models/rider.dart';

class RiderDetailsScreen extends ConsumerWidget {
  final int riderId;

  const RiderDetailsScreen({super.key, required this.riderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riderDetailsAsync = ref.watch(riderDetailsProvider(riderId));

    return Scaffold(
      appBar: AppBar(
        title: riderDetailsAsync.when(
          data: (data) => Text(data.rider.name),
          loading: () => const Text('تحميل...'),
          error: (_, __) => const Text('تفاصيل الطيار'),
        ),
      ),
      body: riderDetailsAsync.when(
        data: (riderAttendance) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rider Info Card
                _RiderInfoCard(rider: riderAttendance.rider),
                
                const SizedBox(height: 16),
                
                // Attendance Section
                _AttendanceSection(days: riderAttendance.days),
                
                const SizedBox(height: 16),
                
                // Details Section
                _DetailsSection(riderAttendance: riderAttendance),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ في تحميل البيانات',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(riderDetailsProvider(riderId));
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiderInfoCard extends StatelessWidget {
  final Rider rider;

  const _RiderInfoCard({required this.rider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الطيار',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _InfoRow(label: 'الاسم', value: rider.name),
            _InfoRow(label: 'رقم الهاتف', value: rider.phone),
            _InfoRow(label: 'المنطقة', value: rider.zone),
            _InfoRow(label: 'رقم التعريف', value: rider.id.toString()),
            _InfoRow(label: 'اسم العقد', value: rider.contractName),
            _InfoRow(label: 'الحالة', value: rider.status),
            _InfoRow(label: 'المشرف', value: rider.supervisorName),
            if (rider.notes != null && rider.notes!.isNotEmpty)
              _InfoRow(label: 'ملاحظات', value: rider.notes!),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceSection extends StatelessWidget {
  final List<AttendanceDay> days;

  const _AttendanceSection({required this.days});

  @override
  Widget build(BuildContext context) {
    // Get last 14 days
    final last14Days = <DateTime>[];
    final today = DateTime.now();
    for (int i = 0; i < 14; i++) {
      last14Days.add(today.subtract(Duration(days: i)));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الحضور',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: last14Days.map((date) {
                AttendanceDay? attendance;
                try {
                  attendance = days.firstWhere(
                    (day) =>
                        day.date.year == date.year &&
                        day.date.month == date.month &&
                        day.date.day == date.day,
                  );
                } catch (e) {
                  attendance = null;
                }
                
                final isPresent = attendance?.isPresent ?? false;
                
                return Chip(
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('dd', 'ar').format(date),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM', 'ar').format(date),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: isPresent
                      ? const Color(0xFF00c853)
                      : const Color(0xFFFF5252),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final RiderAttendance riderAttendance;

  const _DetailsSection({required this.riderAttendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل إضافية',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            if (riderAttendance.selectedHours != null)
              _DetailRow(
                icon: Icons.access_time,
                label: 'الساعات المختارة',
                value: riderAttendance.selectedHours.toString(),
              ),
            if (riderAttendance.actualHours != null)
              _DetailRow(
                icon: Icons.timer,
                label: 'الساعات الفعلية',
                value: riderAttendance.actualHours.toString(),
              ),
            if (riderAttendance.delays != null)
              _DetailRow(
                icon: Icons.schedule,
                label: 'التأخيرات',
                value: riderAttendance.delays.toString(),
              ),
            if (riderAttendance.breaks != null)
              _DetailRow(
                icon: Icons.coffee,
                label: 'الاستراحة',
                value: riderAttendance.breaks!.toString(),
              ),
            if (riderAttendance.bonus != null)
              _DetailRow(
                icon: Icons.attach_money,
                label: 'البونص',
                value: riderAttendance.bonus!.toStringAsFixed(2),
              ),
            if (riderAttendance.comments != null &&
                riderAttendance.comments!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        riderAttendance.comments!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const Icon(Icons.calculate, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'إجمالي الحضور: ${riderAttendance.grandTotal}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

