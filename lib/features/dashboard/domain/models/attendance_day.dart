class AttendanceDay {
  final DateTime date;
  final String value; // "1" or "" or other
  final bool isPresent; // derived: value == "1"

  AttendanceDay({
    required this.date,
    required this.value,
  }) : isPresent = value.trim() == "1";

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    // Handle date as string (ISO format: "YYYY-MM-DD")
    String dateStr = json['date'] is String 
        ? json['date'] as String 
        : json['date'].toString();
    DateTime date;
    try {
      date = DateTime.parse(dateStr);
    } catch (e) {
      // Fallback to current date if parsing fails
      date = DateTime.now();
    }
    
    // Handle value - can be null, "nan", or empty string
    String valueStr = json['value']?.toString() ?? '';
    if (valueStr.toLowerCase() == 'nan' || valueStr.isEmpty) {
      valueStr = '';
    }
    
    return AttendanceDay(
      date: date,
      value: valueStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }
}

