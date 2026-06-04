import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/record.dart';
import '../../core/constants/categories.dart';
import '../../shared/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final ym = DateFormat('yyyy-MM').format(now);
        final income = provider.getMonthIncome(ym);
        final expense = provider.getMonthExpense(ym);
        final balance = income - expense;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '记', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                        TextSpan(text: '·', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w300, color: Colors.grey)),
                        TextSpan(text: '账', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.accent)),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('yyyy年M月 · EEEE', 'zh_CN').format(now),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _OverviewCard(balance: balance, income: income, expense: expense),
                  const SizedBox(height: 16),
                  _QuickActions(),
                  const SizedBox(height: 16),
                  _RecordList(records: provider.records),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final double balance, income, expense;
  const _OverviewCard({required this.balance, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本月结余', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('¥ ${balance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, fontFamily: 'JetBrainsMono')),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _StatColumn(label: '收入', value: '+${income.toStringAsFixed(0)}', color: AppTheme.income)),
                const SizedBox(width: 2),
                Expanded(child: _StatColumn(label: '支出', value: '-${expense.toStringAsFixed(0)}', color: AppTheme.expense)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatColumn({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: color, fontFamily: 'JetBrainsMono')),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('记一笔'),
        )),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_downward, size: 18, color: AppTheme.income),
          label: const Text('收入', style: TextStyle(color: AppTheme.income)),
        )),
      ],
    );
  }
}

class _RecordList extends StatelessWidget {
  final List<JzRecord> records;
  const _RecordList({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [Icon(Icons.note_add, size: 48, color: Colors.grey), SizedBox(height: 12), Text('还没有记录', style: TextStyle(color: Colors.grey))],
          ),
        ),
      );
    }

    final grouped = <String, List<JzRecord>>{};
    for (final r in records) {
      final key = DateFormat('yyyy-MM-dd').format(r.date);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('近期记录', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
        const SizedBox(height: 12),
        ...grouped.entries.take(3).map((entry) {
          final date = DateTime.parse(entry.key);
          final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == entry.key;
          final dayExpense = entry.value.where((r) => r.type == RecordType.expense).fold(0.0, (s, r) => s + r.amount);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isToday ? '今天' : DateFormat('M月d日').format(date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    Text('-${dayExpense.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontFamily: 'JetBrainsMono')),
                  ],
                ),
              ),
              ...entry.value.map((r) => _RecordTile(record: r)),
            ],
          );
        }),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  final JzRecord record;
  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final cats = record.type == RecordType.expense ? AppCategories.expense : AppCategories.income;
    final cat = cats.where((c) => c.id == record.category).firstOrNull;
    final isExpense = record.type == RecordType.expense;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(cat?.icon ?? '📌', style: const TextStyle(fontSize: 18)),
      ),
      title: Text(cat?.label ?? '未知', style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: record.note != null ? Text(record.note!, style: TextStyle(color: Colors.grey[600], fontSize: 12)) : null,
      trailing: Text(
        '${isExpense ? '-' : '+'}${record.amount.toStringAsFixed(2)}',
        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'JetBrainsMono', color: isExpense ? AppTheme.expense : AppTheme.income),
      ),
    );
  }
}
