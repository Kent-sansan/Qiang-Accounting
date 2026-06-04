import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/asset.dart';
import '../../shared/theme/app_theme.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final ym = DateFormat('yyyy-MM').format(now);
        final currentAsset = provider.assets.where((a) => a.month == ym).firstOrNull;
        final total = currentAsset?.total ?? 0;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('资产'),
                  Text('${provider.assets.length}个月', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _TotalCard(total: total),
                  const SizedBox(height: 16),
                  if (currentAsset != null) ...currentAsset.accounts.map((a) => _AccountTile(account: a)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('添加账户'),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double total;
  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('${DateTime.now().month}月总资产', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('¥ ${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, fontFamily: 'JetBrainsMono', color: AppTheme.accent)),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final Account account;
  const _AccountTile({required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(account.icon, style: const TextStyle(fontSize: 24)),
        title: Text(account.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text('¥${account.amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'JetBrainsMono', color: AppTheme.accent)),
      ),
    );
  }
}
