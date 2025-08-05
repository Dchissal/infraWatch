import 'package:flutter/material.dart';
import 'package:infrawatch/screens/dashboard_screen.dart';
import 'package:infrawatch/screens/services_screen.dart';
import 'package:infrawatch/screens/alerts_config_screen.dart';
import 'package:infrawatch/screens/reports_screen.dart';
import 'package:infrawatch/screens/login_screen.dart';
import 'package:infrawatch/services/auth_service.dart';
import 'package:infrawatch/services/monitoring_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    DashboardScreen(),
    ServicesScreen(),
    ReportsScreen(),
    AlertsConfigScreen(),
  ];

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.monitor_outlined,
      selectedIcon: Icons.monitor,
      label: 'Services',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Reports',
    ),
    NavigationItem(
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      label: 'Alerts',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await _showLogoutDialog();
    if (confirmed == true && mounted) {
      await AuthService().logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService().currentUser;
    final unreadAlerts = MonitoringService().unreadAlertsCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.monitor_heart,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('InfraWatch'),
          ],
        ),
        actions: [
          if (unreadAlerts > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Badge(
                label: Text('$unreadAlerts'),
                backgroundColor: theme.colorScheme.error,
                textColor: theme.colorScheme.onError,
                child: IconButton(
                  icon: const Icon(Icons.notifications_active),
                  onPressed: () => _onNavigationTap(3),
                ),
              ),
            ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user?.name.split(' ').map((n) => n[0]).take(2).join() ?? 'U',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Unknown User',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: _handleLogout,
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationTap,
        destinations: _navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          Widget destination = NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );

          // Add badge for alerts tab
          if (index == 3 && unreadAlerts > 0) {
            destination = Badge(
              label: Text('$unreadAlerts'),
              backgroundColor: theme.colorScheme.error,
              textColor: theme.colorScheme.onError,
              child: destination,
            );
          }

          return destination;
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}