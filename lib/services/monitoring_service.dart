import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infrawatch/models/server.dart';
import 'package:infrawatch/models/service.dart';
import 'package:infrawatch/models/alert.dart';
import 'package:infrawatch/models/report.dart';
import 'package:infrawatch/models/sla.dart';

class MonitoringService {
  static final MonitoringService _instance = MonitoringService._internal();
  factory MonitoringService() => _instance;
  MonitoringService._internal() {
    _generateMockData();
  }

  List<Server> _servers = [];
  List<MonitoredService> _services = [];
  List<Alert> _alerts = [];
  List<Report> _reports = [];
  List<SLA> _slas = [];
  AlertConfiguration? _alertConfig;

  List<Server> get servers => _servers;
  List<MonitoredService> get services => _services;
  List<Alert> get alerts => _alerts;
  List<Report> get reports => _reports;
  List<SLA> get slas => _slas;
  AlertConfiguration? get alertConfiguration => _alertConfig;

  List<Report> getReports() => _reports;
  List<SLA> getSLAs() => _slas;

  void _generateMockData() {
    final random = Random();
    final now = DateTime.now();

    // Generate mock servers
    _servers = [
      Server(
        id: '1',
        name: 'Web Server 01',
        ipAddress: '192.168.1.10',
        status: ServerStatus.up,
        cpuUsage: 45.2 + random.nextDouble() * 10,
        memoryUsage: 68.7 + random.nextDouble() * 15,
        diskUsage: 82.3 + random.nextDouble() * 8,
        lastChecked: now.subtract(Duration(minutes: random.nextInt(5))),
        uptimeHistory: _generateUptimeHistory(),
      ),
      Server(
        id: '2',
        name: 'Database Server',
        ipAddress: '192.168.1.20',
        status: ServerStatus.warning,
        cpuUsage: 75.8 + random.nextDouble() * 10,
        memoryUsage: 89.2 + random.nextDouble() * 8,
        diskUsage: 45.6 + random.nextDouble() * 10,
        lastChecked: now.subtract(Duration(minutes: random.nextInt(5))),
        uptimeHistory: _generateUptimeHistory(),
      ),
      Server(
        id: '3',
        name: 'File Server',
        ipAddress: '192.168.1.30',
        status: ServerStatus.up,
        cpuUsage: 25.4 + random.nextDouble() * 10,
        memoryUsage: 42.1 + random.nextDouble() * 15,
        diskUsage: 95.7 + random.nextDouble() * 4,
        lastChecked: now.subtract(Duration(minutes: random.nextInt(5))),
        uptimeHistory: _generateUptimeHistory(),
      ),
      Server(
        id: '4',
        name: 'Mail Server',
        ipAddress: '192.168.1.40',
        status: ServerStatus.down,
        cpuUsage: 0.0,
        memoryUsage: 0.0,
        diskUsage: 0.0,
        lastChecked: now.subtract(Duration(minutes: 15 + random.nextInt(10))),
        uptimeHistory: _generateUptimeHistory(),
      ),
    ];

    // Generate mock services
    _services = [
      MonitoredService(
        id: '1',
        name: 'Main Website',
        url: 'https://www.company.com',
        type: ServiceType.https,
        status: ServiceStatus.up,
        responseTime: 150 + random.nextInt(100),
        lastChecked: now.subtract(Duration(minutes: random.nextInt(3))),
        checkHistory: _generateServiceCheckHistory(),
      ),
      MonitoredService(
        id: '2',
        name: 'API Endpoint',
        url: 'https://api.company.com/health',
        type: ServiceType.https,
        status: ServiceStatus.up,
        responseTime: 85 + random.nextInt(50),
        lastChecked: now.subtract(Duration(minutes: random.nextInt(3))),
        checkHistory: _generateServiceCheckHistory(),
      ),
      MonitoredService(
        id: '3',
        name: 'Database Connection',
        url: '192.168.1.20:5432',
        type: ServiceType.database,
        status: ServiceStatus.warning,
        responseTime: 1200 + random.nextInt(300),
        lastChecked: now.subtract(Duration(minutes: random.nextInt(3))),
        checkHistory: _generateServiceCheckHistory(),
      ),
      MonitoredService(
        id: '4',
        name: 'Email Service',
        url: '192.168.1.40:25',
        type: ServiceType.tcp,
        status: ServiceStatus.down,
        responseTime: 0,
        lastChecked: now.subtract(Duration(minutes: 12 + random.nextInt(8))),
        checkHistory: _generateServiceCheckHistory(),
      ),
    ];

    // Generate mock alerts
    _alerts = [
      Alert(
        id: '1',
        title: 'High CPU Usage',
        description: 'Database Server CPU usage is above 75%',
        level: AlertLevel.warning,
        type: AlertType.server,
        timestamp: now.subtract(const Duration(minutes: 5)),
        sourceId: '2',
        sourceName: 'Database Server',
      ),
      Alert(
        id: '2',
        title: 'Service Down',
        description: 'Email Service is not responding',
        level: AlertLevel.critical,
        type: AlertType.service,
        timestamp: now.subtract(const Duration(minutes: 12)),
        sourceId: '4',
        sourceName: 'Email Service',
      ),
      Alert(
        id: '3',
        title: 'Disk Space Warning',
        description: 'File Server disk usage is above 95%',
        level: AlertLevel.warning,
        type: AlertType.server,
        timestamp: now.subtract(const Duration(minutes: 8)),
        sourceId: '3',
        sourceName: 'File Server',
      ),
      Alert(
        id: '4',
        title: 'Server Offline',
        description: 'Mail Server is not reachable',
        level: AlertLevel.critical,
        type: AlertType.server,
        timestamp: now.subtract(const Duration(minutes: 15)),
        sourceId: '4',
        sourceName: 'Mail Server',
      ),
    ];

    // Default alert configuration
    _alertConfig = const AlertConfiguration(
      id: '1',
      name: 'Default Configuration',
      emailEnabled: true,
      emailAddress: 'admin@company.com',
      smsEnabled: false,
    );

    // Generate mock reports
    _reports = [
      Report(
        id: '1',
        title: 'Relatório de Uptime Semanal',
        description: 'Análise completa do uptime de todos os serviços na última semana',
        type: ReportType.uptime,
        period: ReportPeriod.weekly,
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now,
        generatedAt: now.subtract(const Duration(hours: 2)),
        generatedBy: 'Admin',
        status: ReportStatus.completed,
        metrics: [
          ReportMetric(
            name: 'Uptime Médio',
            value: '99.2%',
            unit: '%',
            numericValue: 99.2,
            trend: MetricTrend.stable,
            previousValue: '99.1%',
          ),
          ReportMetric(
            name: 'Incidentes',
            value: '3',
            unit: 'count',
            numericValue: 3,
            trend: MetricTrend.declining,
            previousValue: '5',
          ),
        ],
      ),
      Report(
        id: '2',
        title: 'Análise de Performance Mensal',
        description: 'Métricas detalhadas de performance e tempo de resposta',
        type: ReportType.performance,
        period: ReportPeriod.monthly,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now,
        generatedAt: now.subtract(const Duration(days: 1)),
        generatedBy: 'TechLead',
        status: ReportStatus.completed,
        metrics: [
          ReportMetric(
            name: 'Tempo Resposta Médio',
            value: '185ms',
            unit: 'ms',
            numericValue: 185,
            trend: MetricTrend.improving,
            previousValue: '220ms',
          ),
        ],
      ),
      Report(
        id: '3',
        title: 'Relatório SLA Q1 2024',
        description: 'Análise de cumprimento dos SLAs no primeiro trimestre',
        type: ReportType.sla,
        period: ReportPeriod.quarterly,
        startDate: now.subtract(const Duration(days: 90)),
        endDate: now,
        generatedAt: now,
        generatedBy: 'System',
        status: ReportStatus.generating,
        metrics: [],
      ),
    ];

    // Generate mock SLAs
    _slas = [
      SLA(
        id: '1',
        name: 'SLA Website Principal',
        serviceId: '1',
        targetUptime: 99.9,
        currentUptime: 99.4,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 30)),
        status: SLAStatus.warning,
        violations: [
          SLAViolation(
            id: '1',
            startTime: now.subtract(const Duration(days: 2, hours: 3)),
            endTime: now.subtract(const Duration(days: 2, hours: 1)),
            reason: 'Manutenção não programada do servidor',
            impactPercentage: 0.3,
            type: SLAViolationType.downtime,
          ),
        ],
      ),
      SLA(
        id: '2',
        name: 'SLA API Endpoint',
        serviceId: '2',
        targetUptime: 99.5,
        currentUptime: 99.8,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 30)),
        status: SLAStatus.healthy,
        violations: [],
      ),
      SLA(
        id: '3',
        name: 'SLA Base de Dados',
        serviceId: '3',
        targetUptime: 99.0,
        currentUptime: 98.2,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 30)),
        status: SLAStatus.violated,
        violations: [
          SLAViolation(
            id: '2',
            startTime: now.subtract(const Duration(days: 5, hours: 6)),
            endTime: now.subtract(const Duration(days: 5, hours: 2)),
            reason: 'Falha no disco rígido',
            impactPercentage: 0.8,
            type: SLAViolationType.downtime,
          ),
          SLAViolation(
            id: '3',
            startTime: now.subtract(const Duration(days: 1, hours: 2)),
            endTime: null,
            reason: 'Lentidão nas consultas',
            impactPercentage: 0.3,
            type: SLAViolationType.performance,
          ),
        ],
      ),
    ];
  }

  List<UptimeRecord> _generateUptimeHistory() {
    final List<UptimeRecord> history = [];
    final random = Random();
    final now = DateTime.now();

    for (int i = 23; i >= 0; i--) {
      history.add(UptimeRecord(
        timestamp: now.subtract(Duration(hours: i)),
        isUp: random.nextDouble() > 0.1, // 90% uptime
        responseTime: 50 + random.nextInt(200),
      ));
    }
    return history;
  }

  List<ServiceCheck> _generateServiceCheckHistory() {
    final List<ServiceCheck> history = [];
    final random = Random();
    final now = DateTime.now();

    for (int i = 23; i >= 0; i--) {
      final isUp = random.nextDouble() > 0.15; // 85% uptime
      history.add(ServiceCheck(
        timestamp: now.subtract(Duration(hours: i)),
        status: isUp ? ServiceStatus.up : ServiceStatus.down,
        responseTime: isUp ? 100 + random.nextInt(300) : 0,
        errorMessage: isUp ? null : 'Connection timeout',
      ));
    }
    return history;
  }

  Future<void> saveAlertConfiguration(AlertConfiguration config) async {
    _alertConfig = config;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('alert_config', jsonEncode(config.toJson()));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadAlertConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString('alert_config');
      if (configJson != null) {
        _alertConfig = AlertConfiguration.fromJson(jsonDecode(configJson));
      }
    } catch (e) {
      // Handle error - use default config
    }
  }

  Future<void> markAlertAsRead(String alertId) async {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isRead: true);
    }
  }

  int get unreadAlertsCount => _alerts.where((alert) => !alert.isRead).length;

  List<Alert> get criticalAlerts => _alerts.where((alert) => alert.level == AlertLevel.critical).toList();

  Map<String, int> get statusSummary {
    int upServers = _servers.where((s) => s.status == ServerStatus.up).length;
    int downServers = _servers.where((s) => s.status == ServerStatus.down).length;
    int warningServers = _servers.where((s) => s.status == ServerStatus.warning).length;
    
    int upServices = _services.where((s) => s.status == ServiceStatus.up).length;
    int downServices = _services.where((s) => s.status == ServiceStatus.down).length;
    int warningServices = _services.where((s) => s.status == ServiceStatus.warning).length;

    return {
      'upServers': upServers,
      'downServers': downServers,
      'warningServers': warningServers,
      'upServices': upServices,
      'downServices': downServices,
      'warningServices': warningServices,
    };
  }

  // SLA related methods
  List<SLA> get violatedSLAs => _slas.where((sla) => sla.isViolated).toList();
  List<SLA> get healthySLAs => _slas.where((sla) => sla.status == SLAStatus.healthy).toList();
  double get averageSLACompliance {
    if (_slas.isEmpty) return 0.0;
    return _slas.map((sla) => sla.currentUptime).reduce((a, b) => a + b) / _slas.length;
  }

  // Report related methods
  List<Report> get completedReports => _reports.where((report) => report.status == ReportStatus.completed).toList();
  List<Report> get pendingReports => _reports.where((report) => report.status == ReportStatus.generating || report.status == ReportStatus.scheduled).toList();
  
  Future<Report> generateReport(ReportType type, ReportPeriod period, DateTime startDate, DateTime endDate) async {
    // Simulate report generation
    await Future.delayed(const Duration(seconds: 2));
    
    final newReport = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Relatório ${_getReportTypeLabel(type)}',
      description: 'Relatório gerado automaticamente para o período selecionado',
      type: type,
      period: period,
      startDate: startDate,
      endDate: endDate,
      generatedAt: DateTime.now(),
      generatedBy: 'Sistema',
      status: ReportStatus.completed,
      metrics: _generateReportMetrics(type),
    );
    
    _reports.insert(0, newReport);
    return newReport;
  }

  String _getReportTypeLabel(ReportType type) {
    switch (type) {
      case ReportType.uptime:
        return 'de Uptime';
      case ReportType.performance:
        return 'de Performance';
      case ReportType.sla:
        return 'de SLA';
      case ReportType.alerts:
        return 'de Alertas';
      case ReportType.usage:
        return 'de Uso';
      case ReportType.security:
        return 'de Segurança';
      case ReportType.comprehensive:
        return 'Completo';
    }
  }

  List<ReportMetric> _generateReportMetrics(ReportType type) {
    final random = Random();
    switch (type) {
      case ReportType.uptime:
        return [
          ReportMetric(
            name: 'Uptime Médio',
            value: '${(98.0 + random.nextDouble() * 2).toStringAsFixed(1)}%',
            unit: '%',
            trend: MetricTrend.stable,
          ),
        ];
      case ReportType.performance:
        return [
          ReportMetric(
            name: 'Tempo de Resposta',
            value: '${(150 + random.nextInt(100))}ms',
            unit: 'ms',
            trend: MetricTrend.improving,
          ),
        ];
      default:
        return [];
    }
  }
}