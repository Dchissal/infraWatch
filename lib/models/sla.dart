class SLA {
  final String id;
  final String name;
  final String serviceId;
  final double targetUptime; // Percentage (e.g., 99.9)
  final double currentUptime;
  final DateTime startDate;
  final DateTime endDate;
  final List<SLAViolation> violations;
  final SLAStatus status;

  SLA({
    required this.id,
    required this.name,
    required this.serviceId,
    required this.targetUptime,
    required this.currentUptime,
    required this.startDate,
    required this.endDate,
    required this.violations,
    required this.status,
  });

  bool get isViolated => currentUptime < targetUptime;
  double get violationPercentage => targetUptime - currentUptime;
  bool get isAtRisk => currentUptime < (targetUptime + 0.5) && currentUptime >= targetUptime;
}

class SLAViolation {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String reason;
  final double impactPercentage;
  final SLAViolationType type;

  SLAViolation({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.reason,
    required this.impactPercentage,
    required this.type,
  });

  Duration get duration => endTime?.difference(startTime) ?? Duration.zero;
}

enum SLAStatus {
  healthy,
  warning,
  violated,
  unknown
}

enum SLAViolationType {
  downtime,
  performance,
  timeout,
  error
}