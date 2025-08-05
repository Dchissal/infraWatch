class UserProfile {
  final String id;
  final String userId;
  final UserRole role;
  final List<Permission> permissions;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isActive;

  UserProfile({
    required this.id,
    required this.userId,
    required this.role,
    required this.permissions,
    required this.preferences,
    required this.createdAt,
    required this.lastUpdated,
    required this.isActive,
  });

  bool hasPermission(Permission permission) => permissions.contains(permission);
  
  bool canManageUsers() => role == UserRole.admin || hasPermission(Permission.manageUsers);
  bool canManageServices() => role != UserRole.viewer || hasPermission(Permission.manageServices);
  bool canViewReports() => hasPermission(Permission.viewReports) || role != UserRole.viewer;
  bool canConfigureAlerts() => role != UserRole.viewer || hasPermission(Permission.configureAlerts);
}

enum UserRole {
  admin,
  technician,
  viewer,
  manager
}

enum Permission {
  viewDashboard,
  viewServices,
  manageServices,
  viewAlerts,
  configureAlerts,
  manageUsers,
  viewReports,
  exportData,
  systemConfiguration,
  viewSLA,
  manageSLA,
  viewAuditLogs,
  backupRestore
}

class RolePermissions {
  static const Map<UserRole, List<Permission>> defaultPermissions = {
    UserRole.admin: [
      Permission.viewDashboard,
      Permission.viewServices,
      Permission.manageServices,
      Permission.viewAlerts,
      Permission.configureAlerts,
      Permission.manageUsers,
      Permission.viewReports,
      Permission.exportData,
      Permission.systemConfiguration,
      Permission.viewSLA,
      Permission.manageSLA,
      Permission.viewAuditLogs,
      Permission.backupRestore,
    ],
    UserRole.manager: [
      Permission.viewDashboard,
      Permission.viewServices,
      Permission.viewAlerts,
      Permission.viewReports,
      Permission.exportData,
      Permission.viewSLA,
      Permission.viewAuditLogs,
    ],
    UserRole.technician: [
      Permission.viewDashboard,
      Permission.viewServices,
      Permission.manageServices,
      Permission.viewAlerts,
      Permission.configureAlerts,
      Permission.viewReports,
      Permission.viewSLA,
    ],
    UserRole.viewer: [
      Permission.viewDashboard,
      Permission.viewServices,
      Permission.viewAlerts,
      Permission.viewReports,
    ],
  };

  static List<Permission> getPermissionsForRole(UserRole role) {
    return defaultPermissions[role] ?? [];
  }
}