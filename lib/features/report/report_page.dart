import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_provider.dart';
import '../../core/models/record.dart';
import '../../core/constants/categories.dart';
import '../../shared/theme/app_theme.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _tabIndex = 0; // 0: monthly, 1: yearly

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final ym = DateFormat('yyyy-MM').format(now);
        final income = provider.getMonthIncome(ym);
        final expense = provider.getMonthExpense(ym);

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('报表'),
                  Text(DateFormat('yyyy年M月').format(now), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _TabBar(index: _tabIndex, onChanged: (i) => setState(() => _tabIndex = i)),
                  const SizedBox(height: 16),
                  _SummaryCard(income: income, expense: expense),
                  const SizedBox(height: 16),
                  _TrendChart(records: provider.records),
                  const SizedBox(height: 16),
                  _CategoryBreakdown(records: provider.records),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _TabBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _Tab('月度报表', 0 == index, () => onChanged(0)),
          _Tab('年度报表', 1 == index, () => onChanged(1)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab(this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 4)] : null,
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? null : Colors.grey)),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double income, expense;
  const _SummaryCard({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('收支概况', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _Stat('支出', '¥${expense.toStringAsFixed(0)}', AppTheme.expense)),
                const SizedBox(width: 2),
                Expanded(child: _Stat('收入', '¥${income.toStringAsFixed(0)}', AppTheme.income)),
              ],
            ),
            const SizedBox(height: 12),
            Text('结余 ¥${balance.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: color, fontFamily: 'JetBrainsMono')),
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final List<Record> records;
  const _TrendChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(6, (i) => DateTime(now.year, now.month - 5 + i));
    final bars = months.map((m) {
      final ym = DateFormat('yyyy-MM').format(m);
      final inc = records.where((r) => r.type == RecordType.income && DateFormat('yyyy-MM').format(r.date) == ym).fold(0.0, (s, r) => s + r.amount);
      final exp = records.where((r) => r.type == RecordType.expense && DateFormat('yyyy-MM').format(r.date) == ym).fold(0.0, (s, r) => s + r.amount);
      return {'month': DateFormat('M月').format(m), 'income': inc, 'expense': exp};
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('月度趋势', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20000,
                  barGroups: bars.asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(toY: e.value['expense']!, color: AppTheme.expense.withOpacity(.8), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                      BarChartRodData(toY: e.value['income']!, color: AppTheme.income.withOpacity(.8), width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                    ]);
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text(bars[v.toInt()]['month'] as String, style: const TextStyle(fontSize: 10)))),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  final List<Record> records;
  const _CategoryBreakdown({required this.records});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final ym = DateFormat('yyyy-MM').format(now);
    final monthExpenses = records.where((r) => r.type == RecordType.expense && DateFormat('yyyy-MM').format(r.date) == ym);
    final total = monthExpenses.fold(0.0, (s, r) => s + r.amount);

    final catMap = <String, double>{};
    for (final r in monthExpenses) {
      catMap[r.category] = (catMap[r.category] ?? 0) + r.amount;
    }
    final sorted = catMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('分类占比', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Colors.grey)),
            const SizedBox(height: 16),
            ...sorted.map((e) {
              final cat = AppCategories.expense.where((c) => c.id == e.key).firstOrNull;
              final pct = total > 0 ? (e.value / total * 100) : 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text(cat?.icon ?? '📌', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    SizedBox(width: 60, child: Text(cat?.label ?? '未知', style: const TextStyle(fontSize: 13))),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          backgroundColor: Colors.grey.withOpacity(.1),
                          color: AppTheme.accent,
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(width: 40, child: Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.right)),
                    const SizedBox(width: 12),
                    SizedBox(width: 60, child: Text(e.value.toStringAsFixed(0), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.expense), textAlign: TextAlign.right)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
