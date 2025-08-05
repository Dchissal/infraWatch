class Server {
  final String id;
  final String name;
  final String ipAddress;
  final ServerStatus status;
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final DateTime lastChecked;
  final List<UptimeRecord> uptimeHistory;

  const Server({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.status,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.lastChecked,
    required this.uptimeHistory,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    id: json['id'],
    name: json['name'],
    ipAddress: json['ipAddress'],
    status: ServerStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ServerStatus.down,
    ),
    cpuUsage: json['cpuUsage']?.toDouble() ?? 0.0,
    memoryUsage: json['memoryUsage']?.toDouble() ?? 0.0,
    diskUsage: json['diskUsage']?.toDouble() ?? 0.0,
    lastChecked: DateTime.parse(json['lastChecked']),
    uptimeHistory: (json['uptimeHistory'] as List?)
        ?.map((e) => UptimeRecord.fromJson(e))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ipAddress': ipAddress,
    'status': status.name,
    'cpuUsage': cpuUsage,
    'memoryUsage': memoryUsage,
    'diskUsage': diskUsage,
    'lastChecked': lastChecked.toIso8601String(),
    'uptimeHistory': uptimeHistory.map((e) => e.toJson()).toList(),
  };
}

enum ServerStatus { up, down, warning, maintenance }

class UptimeRecord {
  final DateTime timestamp;
  final bool isUp;
  final int responseTime;

  const UptimeRecord({
    required this.timestamp,
    required this.isUp,
    required this.responseTime,
  });

  factory UptimeRecord.fromJson(Map<String, dynamic> json) => UptimeRecord(
    timestamp: DateTime.parse(json['timestamp']),
    isUp: json['isUp'],
    responseTime: json['responseTime'],
  );

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'isUp': isUp,
    'responseTime': responseTime,
  };
}