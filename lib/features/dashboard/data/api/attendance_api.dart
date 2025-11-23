import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/rider_attendance.dart';

class AttendanceApi {
  final ApiClient _apiClient;

  AttendanceApi(this._apiClient);

  Future<List<RiderAttendance>> getRiders({
    String? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) {
        queryParams['date'] = date;
      }

      final response = await _apiClient.dio.get(
        AppConstants.ridersEndpoint,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      // Backend returns a list directly, not wrapped in an object
      final ridersList = response.data;
      
      // Handle both list response and object with 'riders' key (for compatibility)
      List<dynamic> items;
      if (ridersList is List) {
        items = ridersList;
      } else if (ridersList is Map<String, dynamic> && ridersList.containsKey('riders')) {
        items = ridersList['riders'] as List<dynamic>? ?? [];
      } else {
        items = [];
      }

      return items
          .map((json) => RiderAttendance.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة');
      }
      throw Exception('فشل تحميل بيانات الطيارين');
    }
  }

  Future<RiderAttendance> getRiderDetails(int riderId) async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.riderDetailsEndpoint(riderId),
      );

      return RiderAttendance.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة');
      }
      throw Exception('فشل تحميل تفاصيل الطيار');
    }
  }
}

