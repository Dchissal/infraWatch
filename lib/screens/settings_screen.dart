import 'package:flutter/material.dart';
import 'package:infrawatch/models/system_config.dart';
import 'package:infrawatch/models/profile.dart';
import 'package:infrawatch/utils/gradients.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient(brightness),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Configurações',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gerencie configurações do sistema e preferências',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                      indicatorWeight: 3,
                      isScrollable: true,
                      labelStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Monitoramento'),
                        Tab(text: 'Notificações'),
                        Tab(text: 'Segurança'),
                        Tab(text: 'Interface'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonitoringTab(),
                _buildNotificationsTab(),
                _buildSecurityTab(),
                _buildInterfaceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configurações de Monitoramento', Icons.monitor_heart),
          const SizedBox(height: 20),
          _buildSettingCard(
            'Intervalo de Verificação',
            'Tempo entre verificações de status',
            '60 segundos',
            Icons.timer,
            onTap: () => _showIntervalDialog(),
          ),
          _buildSettingCard(
            'Timeout de Conexão',
            'Tempo limite para conexões',
            '30 segundos',
            Icons.access_time,
            onTap: () => _showTimeoutDialog(),
          ),
          _buildSettingCard(
            'Tentativas de Retry',
            'Número de tentativas antes de marcar como falha',
            '3 tentativas',
            Icons.refresh,
            onTap: () => _showRetryDialog(),
          ),
          _buildToggleCard(
            'Dados Históricos',
            'Armazenar histórico de métricas',
            true,
            Icons.history,
            (value) => {},
          ),
          _buildSettingCard(
            'Retenção de Dados',
            'Tempo de armazenamento dos dados',
            '90 dias',
            Icons.storage,
            onTap: () => _showRetentionDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configurações de Notificação', Icons.notifications),
          const SizedBox(height: 20),
          _buildToggleCard(
            'Notificações por Email',
            'Receber alertas por email',
            true,
            Icons.email,
            (value) => {},
          ),
          _buildSettingCard(
            'Email Principal',
            'Endereço para receber alertas',
            'admin@infrawatch.com',
            Icons.alternate_email,
            onTap: () => _showEmailDialog(),
          ),
          _buildToggleCard(
            'Notificações SMS',
            'Receber alertas por SMS',
            false,
            Icons.sms,
            (value) => {},
          ),
          _buildToggleCard(
            'Webhooks',
            'Enviar notificações via webhook',
            true,
            Icons.webhook,
            (value) => {},
          ),
          _buildSettingCard(
            'Escalação de Alertas',
            'Tempo para escalação automática',
            '30 minutos',
            Icons.trending_up,
            onTap: () => _showEscalationDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configurações de Segurança', Icons.security),
          const SizedBox(height: 20),
          _buildToggleCard(
            'Autenticação 2FA',
            'Habilitar autenticação de dois fatores',
            false,
            Icons.verified_user,
            (value) => {},
          ),
          _buildSettingCard(
            'Expiração de Senha',
            'Tempo para expiração de senhas',
            '90 dias',
            Icons.password,
            onTap: () => _showPasswordExpiryDialog(),
          ),
          _buildSettingCard(
            'Timeout de Sessão',
            'Tempo limite de inatividade',
            '30 minutos',
            Icons.access_time_filled,
            onTap: () => _showSessionTimeoutDialog(),
          ),
          _buildToggleCard(
            'Log de Auditoria',
            'Registrar ações dos usuários',
            true,
            Icons.description,
            (value) => {},
          ),
          _buildToggleCard(
            'Requer SSL',
            'Forçar conexões SSL/TLS',
            true,
            Icons.lock,
            (value) => {},
          ),
        ],
      ),
    );
  }

  Widget _buildInterfaceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Configurações de Interface', Icons.palette),
          const SizedBox(height: 20),
          _buildSettingCard(
            'Tema',
            'Aparência da interface',
            'Automático',
            Icons.brightness_auto,
            onTap: () => _showThemeDialog(),
          ),
          _buildSettingCard(
            'Idioma',
            'Idioma da interface',
            'Português (BR)',
            Icons.language,
            onTap: () => _showLanguageDialog(),
          ),
          _buildSettingCard(
            'Atualização do Dashboard',
            'Frequência de atualização automática',
            '30 segundos',
            Icons.refresh,
            onTap: () => _showRefreshDialog(),
          ),
          _buildToggleCard(
            'Animações',
            'Habilitar animações na interface',
            true,
            Icons.animation,
            (value) => {},
          ),
          _buildToggleCard(
            'Notificações Push',
            'Receber notificações no navegador',
            true,
            Icons.push_pin,
            (value) => {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(
    String title,
    String subtitle,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog methods (simplified for demo)
  void _showIntervalDialog() {
    // Implementation for interval selection dialog
  }

  void _showTimeoutDialog() {
    // Implementation for timeout selection dialog
  }

  void _showRetryDialog() {
    // Implementation for retry count dialog
  }

  void _showRetentionDialog() {
    // Implementation for data retention dialog
  }

  void _showEmailDialog() {
    // Implementation for email configuration dialog
  }

  void _showEscalationDialog() {
    // Implementation for escalation time dialog
  }

  void _showPasswordExpiryDialog() {
    // Implementation for password expiry dialog
  }

  void _showSessionTimeoutDialog() {
    // Implementation for session timeout dialog
  }

  void _showThemeDialog() {
    // Implementation for theme selection dialog
  }

  void _showLanguageDialog() {
    // Implementation for language selection dialog
  }

  void _showRefreshDialog() {
    // Implementation for refresh interval dialog
  }
}