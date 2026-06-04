import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../shared/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(floating: true, title: const Text('我的')),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const CircleAvatar(radius: 36, child: Text('🧑', style: TextStyle(fontSize: 32))),
                          const SizedBox(height: 12),
                          const Text('记账达人', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('从 ${provider.records.isNotEmpty ? provider.records.last.date.year : DateTime.now().year} 年开始记账', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _StatItem('记账天数', provider.records.map((r) => r.date.day).toSet().length.toString())),
                              Expanded(child: _StatItem('总笔数', provider.records.length.toString())),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        _SettingRow(icon: '🎨', label: '外观', onTap: () => _showThemeDialog(context, provider)),
                        _SettingRow(icon: '📂', label: '分类管理', onTap: () {}),
                        _SettingRow(icon: '💾', label: '数据', onTap: () {}),
                        _SettingRow(icon: '🗑️', label: '清除数据', color: AppTheme.expense, onTap: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text('记·账 v2.0', style: TextStyle(color: Colors.grey[600], fontSize: 12))),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('主题'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption('自动', 'auto', provider),
            _ThemeOption('浅色', 'light', provider),
            _ThemeOption('深色', 'dark', provider),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontFamily: 'JetBrainsMono', color: AppTheme.accent)),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String icon, label;
  final Color? color;
  final VoidCallback onTap;
  const _SettingRow({required this.icon, required this.label, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label, value;
  final AppProvider provider;
  const _ThemeOption(this.label, this.value, this.provider);

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: provider.themeMode == ThemeMode.system ? 'auto' : provider.themeMode == ThemeMode.light ? 'light' : 'dark',
      onChanged: (_) => provider.setTheme(value),
    );
  }
}
