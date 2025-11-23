import '../api/attendance_api.dart';
import '../../domain/models/rider_attendance.dart';

class AttendanceRepository {
  final AttendanceApi _attendanceApi;

  AttendanceRepository(this._attendanceApi);

  Future<List<RiderAttendance>> getRiders({String? date}) async {
    return await _attendanceApi.getRiders(date: date);
  }

  Future<RiderAttendance> getRiderDetails(int riderId) async {
    return await _attendanceApi.getRiderDetails(riderId);
  }
}

