class Rider {
  final int id;
  final String name;
  final String phone;
  final String zone;
  final String contractName;
  final String status;
  final String supervisorName;
  final String? notes;

  Rider({
    required this.id,
    required this.name,
    required this.phone,
    required this.zone,
    required this.contractName,
    required this.status,
    required this.supervisorName,
    this.notes,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    // Handle id as both int and string (Backend returns string)
    int riderId;
    if (json['id'] is int) {
      riderId = json['id'] as int;
    } else {
      riderId = int.tryParse(json['id'].toString()) ?? 0;
    }
    
    return Rider(
      id: riderId,
      name: json['name'] as String,
      phone: json['phone'] as String,
      zone: json['zone'] as String? ?? '',
      // Handle both snake_case (Backend) and camelCase (local)
      contractName: json['contract_name'] as String? ?? json['contractName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      supervisorName: json['supervisor_name'] as String? ?? json['supervisorName'] as String? ?? '',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'zone': zone,
      'contractName': contractName,
      'status': status,
      'supervisorName': supervisorName,
      'notes': notes,
    };
  }
}

