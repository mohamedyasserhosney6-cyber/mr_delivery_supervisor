import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../data/api/attendance_api.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../domain/models/rider_attendance.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

// Providers
final attendanceApiProvider = Provider<AttendanceApi>((ref) {
  return AttendanceApi(ref.watch(apiClientProvider));
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.watch(attendanceApiProvider));
});

// Selected Date Provider (Default to Tomorrow)
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now().add(const Duration(days: 1)));

// Riders Attendance Provider
final ridersAttendanceProvider = FutureProvider<List<RiderAttendance>>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final dateString = DateFormat('yyyy-MM-dd').format(date);
  
  final repository = ref.watch(attendanceRepositoryProvider);
  return await repository.getRiders(date: dateString);
});

// Rider Details Provider
final riderDetailsProvider =
    FutureProvider.family<RiderAttendance, int>((ref, riderId) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return await repository.getRiderDetails(riderId);
});

