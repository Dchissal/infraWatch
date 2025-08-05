class MonitoredService {
  final String id;
  final String name;
  final String url;
  final ServiceType type;
  final ServiceStatus status;
  final int responseTime;
  final DateTime lastChecked;
  final List<ServiceCheck> checkHistory;

  const MonitoredService({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.status,
    required this.responseTime,
    required this.lastChecked,
    required this.checkHistory,
  });

  factory MonitoredService.fromJson(Map<String, dynamic> json) => MonitoredService(
    id: json['id'],
    name: json['name'],
    url: json['url'],
    type: ServiceType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => ServiceType.http,
    ),
    status: ServiceStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ServiceStatus.down,
    ),
    responseTime: json['responseTime'] ?? 0,
    lastChecked: DateTime.parse(json['lastChecked']),
    checkHistory: (json['checkHistory'] as List?)
        ?.map((e) => ServiceCheck.fromJson(e))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'type': type.name,
    'status': status.name,
    'responseTime': responseTime,
    'lastChecked': lastChecked.toIso8601String(),
    'checkHistory': checkHistory.map((e) => e.toJson()).toList(),
  };
}

enum ServiceType { http, https, tcp, ping, database }
enum ServiceStatus { up, down, warning, maintenance }

class ServiceCheck {
  final DateTime timestamp;
  final ServiceStatus status;
  final int responseTime;
  final String? errorMessage;

  const ServiceCheck({
    required this.timestamp,
    required this.status,
    required this.responseTime,
    this.errorMessage,
  });

  factory ServiceCheck.fromJson(Map<String, dynamic> json) => ServiceCheck(
    timestamp: DateTime.parse(json['timestamp']),
    status: ServiceStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ServiceStatus.down,
    ),
    responseTime: json['responseTime'] ?? 0,
    errorMessage: json['errorMessage'],
  );

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'responseTime': responseTime,
    'errorMessage': errorMessage,
  };
}