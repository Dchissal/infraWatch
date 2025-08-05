# InfraWatch - Architecture Documentation

## Overview
InfraWatch is a comprehensive Flutter-based infrastructure monitoring system designed for IT professionals. It provides real-time monitoring of servers, services, and network links with intuitive dashboards, detailed service views, and customizable alerts.

## Core Features
- **JWT Authentication**: Secure login system with role-based access
- **Real-time Dashboard**: Status cards, charts, and system overview
- **Server Monitoring**: CPU, memory, disk usage tracking with historical data
- **Service Monitoring**: HTTP/HTTPS, database, TCP, ping monitoring
- **Alert System**: Configurable notifications with multiple criticality levels
- **Dark/Light Mode**: Professional UI supporting both themes
- **Responsive Design**: Works across different screen sizes

## Architecture Structure

### Data Models (`/lib/models/`)
- **User**: Authentication and user management
- **Server**: Server infrastructure with resource metrics
- **Service**: Monitored services with uptime tracking
- **Alert**: Alert system with configurable notifications

### Services (`/lib/services/`)
- **AuthService**: JWT authentication, session management
- **MonitoringService**: Mock data generation, alert management

### Screens (`/lib/screens/`)
- **LoginScreen**: JWT authentication with demo credentials
- **MainScreen**: Navigation hub with bottom navigation
- **DashboardScreen**: System overview with charts and metrics
- **ServicesScreen**: Tabbed view for servers and services
- **AlertsConfigScreen**: Alert management and configuration

### Widgets (`/lib/widgets/`)
- **StatusCard**: Reusable metric display cards
- **UptimeChart**: Real-time uptime visualization using fl_chart
- **AlertListTile**: Alert display with priority indicators
- **ServerCard**: Server status and resource usage display
- **ServiceCard**: Service monitoring display with uptime

## Technology Stack
- **Flutter**: Cross-platform mobile development
- **fl_chart**: Chart and graph visualization
- **shared_preferences**: Local data persistence
- **dio**: HTTP client for API communication
- **intl**: Internationalization and date formatting
- **google_fonts**: Professional typography

## Theme System
Professional IT monitoring color scheme:
- **Light Theme**: Blue primary (#1565C0) with clean surfaces
- **Dark Theme**: Optimized for 24/7 monitoring environments
- **Status Colors**: Green (up), Orange (warning), Red (down), Blue (maintenance)

## Data Flow
1. **Authentication**: JWT-based login with persistent sessions
2. **Data Generation**: Mock monitoring data with realistic patterns
3. **Real-time Updates**: Simulated live data with refresh capabilities
4. **Alert Processing**: Configurable alert levels and notification channels
5. **Local Storage**: Preferences and configuration persistence

## Sample Data
- **4 Servers**: Web, Database, File, Mail servers with varied statuses
- **4 Services**: Website, API, Database, Email with different protocols
- **Alert Types**: Critical, Warning, Info levels across system components
- **Uptime History**: 24-hour tracking with realistic availability patterns

## Security Features
- JWT token-based authentication
- Session persistence with expiration handling
- Role-based access control (Admin, Technician, Viewer)
- Secure credential validation

## Monitoring Capabilities
- **Server Metrics**: CPU, Memory, Disk usage with thresholds
- **Service Health**: Response time, uptime percentage, status tracking
- **Network Monitoring**: Connectivity and performance tracking
- **Alert Management**: Multi-level criticality with notification routing

## Demo Credentials
- **Admin**: admin@infrawatch.com / admin123
- **Technician**: tech@infrawatch.com / tech123

This architecture provides a solid foundation for a professional infrastructure monitoring system that can be extended with real backend integration, additional monitoring protocols, and enterprise features.