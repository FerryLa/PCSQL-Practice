import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../core/utils/markdown_parser.dart';

class StudyTrackerPage extends StatelessWidget {
  const StudyTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학습 체크리스트')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardLoaded) {
            final weeks = state.summary.studyProgress;
            if (weeks.isEmpty) {
              return const Center(child: Text('학습 데이터가 없습니다'));
            }
            return _WeekList(weeks: weeks);
          }
          return const Center(child: Text('대시보드에서 데이터를 먼저 로드해주세요'));
        },
      ),
    );
  }
}

class _WeekList extends StatelessWidget {
  final List<StudyWeek> weeks;

  const _WeekList({required this.weeks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weeks.length,
      itemBuilder: (context, index) {
        final week = weeks[weeks.length - 1 - index]; // 최신 주 먼저
        return _WeekCard(week: week);
      },
    );
  }
}

class _WeekCard extends StatelessWidget {
  final StudyWeek week;

  const _WeekCard({required this.week});

  @override
  Widget build(BuildContext context) {
    final percentage = (week.completionRate * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    week.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _progressColor(week.completionRate),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: week.completionRate,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _progressColor(week.completionRate),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: week.days.map((day) {
                return _DayChip(day: day);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _progressColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.5) return Colors.orange;
    return Colors.red;
  }
}

class _DayChip extends StatelessWidget {
  final StudyDay day;

  const _DayChip({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Text(
            day.date.length > 5 ? day.date.substring(5) : day.date,
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(_statusEmoji, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  String get _statusEmoji {
    switch (day.status) {
      case StudyStatus.complete:
        return '✅';
      case StudyStatus.late:
        return '⏰';
      case StudyStatus.missed:
        return '❌';
      case StudyStatus.empty:
        return '⬜';
    }
  }

  Color get _backgroundColor {
    switch (day.status) {
      case StudyStatus.complete:
        return Colors.green.shade50;
      case StudyStatus.late:
        return Colors.orange.shade50;
      case StudyStatus.missed:
        return Colors.red.shade50;
      case StudyStatus.empty:
        return Colors.grey.shade50;
    }
  }

  Color get _borderColor {
    switch (day.status) {
      case StudyStatus.complete:
        return Colors.green.shade200;
      case StudyStatus.late:
        return Colors.orange.shade200;
      case StudyStatus.missed:
        return Colors.red.shade200;
      case StudyStatus.empty:
        return Colors.grey.shade200;
    }
  }
}
