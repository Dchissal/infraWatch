class Report {
  final String id;
  final String title;
  final String description;
  final ReportType type;
  final ReportPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime generatedAt;
  final String generatedBy;
  final List<ReportMetric> metrics;
  final ReportStatus status;
  final String? filePath;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.generatedAt,
    required this.generatedBy,
    required this.metrics,
    required this.status,
    this.filePath,
  });
}

class ReportMetric {
  final String name;
  final String value;
  final String unit;
  final double? numericValue;
  final MetricTrend trend;
  final String? previousValue;

  ReportMetric({
    required this.name,
    required this.value,
    required this.unit,
    this.numericValue,
    required this.trend,
    this.previousValue,
  });
}

enum ReportType {
  uptime,
  performance,
  sla,
  alerts,
  usage,
  security,
  comprehensive
}

enum ReportPeriod {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom
}

enum ReportStatus {
  generating,
  completed,
  failed,
  scheduled
}

enum MetricTrend {
  improving,
  declining,
  stable,
  unknown
}

class ReportTemplate {
  final String id;
  final String name;
  final String description;
  final ReportType type;
  final List<String> includedMetrics;
  final Map<String, dynamic> configuration;
  final bool isDefault;
  final DateTime createdAt;
  final String createdBy;

  ReportTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.includedMetrics,
    required this.configuration,
    required this.isDefault,
    required this.createdAt,
    required this.createdBy,
  });
}