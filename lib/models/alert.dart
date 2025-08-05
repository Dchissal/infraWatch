class Alert {
  final String id;
  final String title;
  final String description;
  final AlertLevel level;
  final AlertType type;
  final DateTime timestamp;
  final bool isRead;
  final String? sourceId;
  final String? sourceName;

  const Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.sourceId,
    this.sourceName,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    level: AlertLevel.values.firstWhere(
      (e) => e.name == json['level'],
      orElse: () => AlertLevel.info,
    ),
    type: AlertType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AlertType.system,
    ),
    timestamp: DateTime.parse(json['timestamp']),
    isRead: json['isRead'] ?? false,
    sourceId: json['sourceId'],
    sourceName: json['sourceName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'level': level.name,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'sourceId': sourceId,
    'sourceName': sourceName,
  };

  Alert copyWith({
    String? id,
    String? title,
    String? description,
    AlertLevel? level,
    AlertType? type,
    DateTime? timestamp,
    bool? isRead,
    String? sourceId,
    String? sourceName,
  }) => Alert(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    level: level ?? this.level,
    type: type ?? this.type,
    timestamp: timestamp ?? this.timestamp,
    isRead: isRead ?? this.isRead,
    sourceId: sourceId ?? this.sourceId,
    sourceName: sourceName ?? this.sourceName,
  );
}

enum AlertLevel { critical, warning, info }
enum AlertType { server, service, network, system }

class AlertConfiguration {
  final String id;
  final String name;
  final bool emailEnabled;
  final bool smsEnabled;
  final String? emailAddress;
  final String? phoneNumber;
  final Set<AlertLevel> enabledLevels;
  final Set<AlertType> enabledTypes;

  const AlertConfiguration({
    required this.id,
    required this.name,
    this.emailEnabled = false,
    this.smsEnabled = false,
    this.emailAddress,
    this.phoneNumber,
    this.enabledLevels = const {AlertLevel.critical, AlertLevel.warning, AlertLevel.info},
    this.enabledTypes = const {AlertType.server, AlertType.service, AlertType.network, AlertType.system},
  });

  factory AlertConfiguration.fromJson(Map<String, dynamic> json) => AlertConfiguration(
    id: json['id'],
    name: json['name'],
    emailEnabled: json['emailEnabled'] ?? false,
    smsEnabled: json['smsEnabled'] ?? false,
    emailAddress: json['emailAddress'],
    phoneNumber: json['phoneNumber'],
    enabledLevels: (json['enabledLevels'] as List?)
        ?.map((e) => AlertLevel.values.firstWhere((level) => level.name == e))
        .toSet() ?? {AlertLevel.critical, AlertLevel.warning, AlertLevel.info},
    enabledTypes: (json['enabledTypes'] as List?)
        ?.map((e) => AlertType.values.firstWhere((type) => type.name == e))
        .toSet() ?? {AlertType.server, AlertType.service, AlertType.network, AlertType.system},
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emailEnabled': emailEnabled,
    'smsEnabled': smsEnabled,
    'emailAddress': emailAddress,
    'phoneNumber': phoneNumber,
    'enabledLevels': enabledLevels.map((e) => e.name).toList(),
    'enabledTypes': enabledTypes.map((e) => e.name).toList(),
  };
}