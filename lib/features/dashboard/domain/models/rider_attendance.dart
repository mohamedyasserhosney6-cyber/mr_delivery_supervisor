import 'rider.dart';
import 'attendance_day.dart';

class RiderAttendance {
  final Rider rider;
  final List<AttendanceDay> days;
  final int grandTotal; // sum of "1"s across days
  final int? selectedHours; // اختيار الساعات
  final int? actualHours; // الساعات الفعلية
  final int? delays; // عدد التأخيرات
  final double? breaks; // استراحة
  final double? bonus; // بونص
  final String? comments; // ملاحظات

  RiderAttendance({
    required this.rider,
    required this.days,
    required this.grandTotal,
    this.selectedHours,
    this.actualHours,
    this.delays,
    this.breaks,
    this.bonus,
    this.comments,
  });

  factory RiderAttendance.fromJson(Map<String, dynamic> json) {
    return RiderAttendance(
      rider: Rider.fromJson(json['rider'] as Map<String, dynamic>),
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => AttendanceDay.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      // Handle both snake_case (Backend) and camelCase (local)
      grandTotal: (json['grand_total'] as int?) ?? (json['grandTotal'] as int?) ?? 0,
      selectedHours: json['selected_hours'] as int? ?? json['selectedHours'] as int?,
      actualHours: json['actual_hours'] as int? ?? json['actualHours'] as int?,
      delays: json['delays'] as int?,
      breaks: json['breaks'] != null ? (json['breaks'] as num).toDouble() : null,
      bonus: json['bonus'] != null ? (json['bonus'] as num).toDouble() : null,
      comments: json['comments'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider': rider.toJson(),
      'days': days.map((d) => d.toJson()).toList(),
      'grandTotal': grandTotal,
      'selectedHours': selectedHours,
      'actualHours': actualHours,
      'delays': delays,
      'breaks': breaks,
      'bonus': bonus,
      'comments': comments,
    };
  }

  // Helper to get attendance for a specific date
  AttendanceDay? getAttendanceForDate(DateTime date) {
    try {
      return days.firstWhere(
        (day) =>
            day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}

