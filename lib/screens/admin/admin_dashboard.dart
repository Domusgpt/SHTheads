import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHTheads Admin', style: TextStyle(color: AppTheme.accentOrange)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.accentOrange),
            onPressed: () => context.read<AuthProvider>().signOut(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMetricCards(),
            const SizedBox(height: 32),
            const Text(
              'Flagged Reviews Queue',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFlaggedDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards() {
    return Row(
      children: [
        Expanded(child: _MetricCard(title: 'Total Users', value: '1,240', icon: Icons.group)),
        const SizedBox(width: 16),
        Expanded(child: _MetricCard(title: 'Active Reviews', value: '4,892', icon: Icons.list_alt)),
        const SizedBox(width: 16),
        Expanded(child: _MetricCard(title: 'GCS Storage', value: '42.5 GB', icon: Icons.cloud)),
      ],
    );
  }

  Widget _buildFlaggedDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.metallicLight),
      ),
      child: DataTable(
        headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.black26),
        columns: const [
          DataColumn(label: Text('Address', style: TextStyle(color: AppTheme.accentOrange))),
          DataColumn(label: Text('Author', style: TextStyle(color: AppTheme.accentOrange))),
          DataColumn(label: Text('Flag Reason', style: TextStyle(color: AppTheme.accentOrange))),
          DataColumn(label: Text('Actions', style: TextStyle(color: AppTheme.accentOrange))),
        ],
        rows: [
          _buildRow('42 E Bergen Ave', 'Joe\'s Plumbing', 'Inappropriate Language'),
          _buildRow('109 Main St', 'Sparky Dan', 'Spam / Fake Address'),
          _buildRow('500 Elm St', 'Mike Builder', 'Defamation Dispute'),
        ],
      ),
    );
  }

  DataRow _buildRow(String address, String author, String reason) {
    return DataRow(
      cells: [
        DataCell(Text(address, style: const TextStyle(color: AppTheme.textPrimary))),
        DataCell(Text(author, style: const TextStyle(color: AppTheme.textPrimary))),
        DataCell(Text(reason, style: const TextStyle(color: AppTheme.accentYellow))),
        DataCell(
          Row(
            children: [
              IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.metallicLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.textSecondary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppTheme.accentOrange, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
