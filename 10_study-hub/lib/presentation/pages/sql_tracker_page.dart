import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../core/utils/markdown_parser.dart';

class SQLTrackerPage extends StatelessWidget {
  const SQLTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQL 트래커')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardLoaded) {
            return _SQLTrackerContent(
              sqlStats: state.summary.sqlStats,
              ecommerceStats: state.summary.ecommerceStats,
            );
          }
          return const Center(child: Text('대시보드에서 데이터를 먼저 로드해주세요'));
        },
      ),
    );
  }
}

class _SQLTrackerContent extends StatelessWidget {
  final List<WeeklyStat> sqlStats;
  final List<WeeklyStat> ecommerceStats;

  const _SQLTrackerContent({
    required this.sqlStats,
    required this.ecommerceStats,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'SQL 문제 풀이'),
              Tab(text: '이커머스 챌린지'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _StatsView(stats: sqlStats, label: 'SQL 문제'),
                _StatsView(stats: ecommerceStats, label: '챌린지'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  final List<WeeklyStat> stats;
  final String label;

  const _StatsView({required this.stats, required this.label});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const Center(child: Text('데이터가 없습니다'));
    }

    final totalCount = stats.fold<int>(0, (sum, s) => sum + s.count);
    final recentStats = stats.length > 10 ? stats.sublist(stats.length - 10) : stats;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 요약 카드
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(
                  label: '총 $label',
                  value: '$totalCount',
                  icon: Icons.summarize,
                ),
                _SummaryItem(
                  label: '추적 주차',
                  value: '${stats.length}주',
                  icon: Icons.date_range,
                ),
                _SummaryItem(
                  label: '주간 평균',
                  value: (totalCount / stats.length).toStringAsFixed(1),
                  icon: Icons.trending_up,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 차트
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주간 $label 현황',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _WeeklyChart(stats: recentStats),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 상세 목록
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '주별 상세',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...recentStats.reversed.map((stat) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(stat.weekLabel,
                                style: const TextStyle(fontSize: 13)),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: stat.count /
                                  (recentStats
                                      .map((s) => s.count)
                                      .reduce((a, b) => a > b ? a : b)
                                      .toDouble()),
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 30,
                            child: Text(
                              '${stat.count}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<WeeklyStat> stats;

  const _WeeklyChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (stats.map((s) => s.count).reduce((a, b) => a > b ? a : b) * 1.2),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${stats[groupIndex].weekLabel}\n${rod.toY.toInt()}개',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < stats.length) {
                  final label = stats[index].weekLabel;
                  // W숫자만 표시
                  final weekNum = label.contains('W')
                      ? label.substring(label.indexOf('W'))
                      : label;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(weekNum, style: const TextStyle(fontSize: 10)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: stats.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.count.toDouble(),
                color: Colors.blue,
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
