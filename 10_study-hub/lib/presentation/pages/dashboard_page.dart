import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../core/utils/markdown_parser.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../app/theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<DashboardBloc>()
                .add(LoadDashboard(forceRefresh: true));
          },
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const _ShimmerLoading();
              }
              if (state is DashboardError) {
                return _ErrorView(message: state.message);
              }
              if (state is DashboardLoaded) {
                return _DashboardContent(summary: state.summary);
              }
              return const _ShimmerLoading();
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardSummary summary;

  const _DashboardContent({required this.summary});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 헤더
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Study Hub',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 새로고침 버튼
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: AppColors.primary),
                        onPressed: () => context
                            .read<DashboardBloc>()
                            .add(LoadDashboard(forceRefresh: true)),
                      ),
                    ),
                  ],
                ),
                if (summary.isCached) ...[
                  const SizedBox(height: 8),
                  _CachedBanner(timestamp: summary.cacheTimestamp),
                ],
              ],
            ),
          ),
        ),

        // 오늘의 요약 카드
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _TodaySummaryCard(summary: summary),
          ),
        ),

        // 카드들
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SQLStatsCard(stats: summary.sqlStats),
              const SizedBox(height: 12),
              _StudyProgressCard(weeks: summary.studyProgress),
              const SizedBox(height: 12),
              _EcommerceCard(stats: summary.ecommerceStats),
              const SizedBox(height: 12),
              if (summary.lastActionRun != null)
                _ActionsCard(lastRun: summary.lastActionRun!),
            ]),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '새벽에도 공부하시는군요';
    if (hour < 12) return '좋은 아침이에요';
    if (hour < 18) return '오후도 화이팅';
    return '오늘도 수고하셨어요';
  }
}

class _TodaySummaryCard extends StatelessWidget {
  final DashboardSummary summary;

  const _TodaySummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final totalSql = summary.sqlStats.fold<int>(0, (s, e) => s + e.count);
    final totalEcommerce =
        summary.ecommerceStats.fold<int>(0, (s, e) => s + e.count);
    final totalStudyDays = summary.studyProgress
        .expand((w) => w.days)
        .where((d) => d.status == StudyStatus.complete)
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전체 학습 현황',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(
                icon: Icons.code_rounded,
                value: '$totalSql',
                label: 'SQL 문제',
              ),
              const SizedBox(width: 24),
              _MiniStat(
                icon: Icons.check_circle_outline_rounded,
                value: '$totalStudyDays',
                label: '학습 완료',
              ),
              const SizedBox(width: 24),
              _MiniStat(
                icon: Icons.rocket_launch_rounded,
                value: '$totalEcommerce',
                label: '챌린지',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SQLStatsCard extends StatelessWidget {
  final List<WeeklyStat> stats;

  const _SQLStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final recentStats =
        stats.length > 4 ? stats.sublist(stats.length - 4) : stats;
    final maxCount = recentStats.isEmpty
        ? 1
        : recentStats.map((s) => s.count).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sqlColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.code_rounded,
                      color: AppColors.sqlColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SQL 문제 풀이',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentStats.map((stat) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stat.weekLabel,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                          Text('${stat.count}문제',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: stat.count / maxCount.toDouble(),
                          minHeight: 8,
                          backgroundColor:
                              AppColors.sqlColor.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.sqlColor),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _StudyProgressCard extends StatelessWidget {
  final List<StudyWeek> weeks;

  const _StudyProgressCard({required this.weeks});

  @override
  Widget build(BuildContext context) {
    final latestWeek = weeks.isNotEmpty ? weeks.last : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.studyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: AppColors.studyColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  '학습 체크리스트',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (latestWeek != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _progressColor(latestWeek.completionRate).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(latestWeek.completionRate * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _progressColor(latestWeek.completionRate),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (latestWeek != null) ...[
              Text(
                latestWeek.label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: latestWeek.days.map((day) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _StatusDot(day: day),
                    ),
                  );
                }).toList(),
              ),
            ] else
              Text('데이터 없음',
                  style: TextStyle(color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Color _progressColor(double rate) {
    if (rate >= 0.8) return AppColors.success;
    if (rate >= 0.5) return AppColors.warning;
    return AppColors.error;
  }
}

class _StatusDot extends StatelessWidget {
  final StudyDay day;

  const _StatusDot({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor, width: 1.5),
          ),
          child: Center(
            child: _icon,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day.date.length >= 5 ? day.date.substring(5) : day.date,
          style: const TextStyle(fontSize: 9, color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget get _icon {
    switch (day.status) {
      case StudyStatus.complete:
        return const Icon(Icons.check_rounded, size: 18, color: AppColors.success);
      case StudyStatus.late:
        return const Icon(Icons.schedule_rounded, size: 18, color: AppColors.warning);
      case StudyStatus.missed:
        return const Icon(Icons.close_rounded, size: 18, color: AppColors.error);
      case StudyStatus.empty:
        return Icon(Icons.remove_rounded, size: 18, color: AppColors.textHint);
    }
  }

  Color get _bgColor {
    switch (day.status) {
      case StudyStatus.complete:
        return AppColors.success.withValues(alpha: 0.1);
      case StudyStatus.late:
        return AppColors.warning.withValues(alpha: 0.1);
      case StudyStatus.missed:
        return AppColors.error.withValues(alpha: 0.1);
      case StudyStatus.empty:
        return Colors.grey.withValues(alpha: 0.05);
    }
  }

  Color get _borderColor {
    switch (day.status) {
      case StudyStatus.complete:
        return AppColors.success.withValues(alpha: 0.3);
      case StudyStatus.late:
        return AppColors.warning.withValues(alpha: 0.3);
      case StudyStatus.missed:
        return AppColors.error.withValues(alpha: 0.3);
      case StudyStatus.empty:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }
}

class _EcommerceCard extends StatelessWidget {
  final List<WeeklyStat> stats;

  const _EcommerceCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final totalCount = stats.fold<int>(0, (sum, s) => sum + s.count);
    final progress = totalCount / 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.ecommerceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.rocket_launch_rounded,
                      color: AppColors.ecommerceColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  '이커머스 챌린지',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 원형 프로그레스
            Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 6,
                          backgroundColor:
                              AppColors.ecommerceColor.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.ecommerceColor),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '$totalCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100일 챌린지',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalCount일 완료 / ${100 - totalCount}일 남음',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final String lastRun;

  const _ActionsCard({required this.lastRun});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_circle_rounded,
                  color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GitHub Actions',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    '마지막 실행: $lastRun',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CachedBanner extends StatelessWidget {
  final DateTime? timestamp;

  const _CachedBanner({this.timestamp});

  @override
  Widget build(BuildContext context) {
    final timeAgo = timestamp != null
        ? _formatTimeAgo(DateTime.now().difference(timestamp!))
        : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 14, color: AppColors.warning),
          const SizedBox(width: 8),
          Text(
            '오프라인 데이터${timeAgo.isNotEmpty ? " ($timeAgo 전)" : ""}',
            style: const TextStyle(fontSize: 12, color: AppColors.warning),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(Duration duration) {
    if (duration.inMinutes < 60) return '${duration.inMinutes}분';
    if (duration.inHours < 24) return '${duration.inHours}시간';
    return '${duration.inDays}일';
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _shimmerBox(120, 16),
          const SizedBox(height: 8),
          _shimmerBox(180, 28),
          const SizedBox(height: 24),
          _shimmerBox(double.infinity, 120, radius: 20),
          const SizedBox(height: 16),
          _shimmerBox(double.infinity, 160, radius: 16),
          const SizedBox(height: 12),
          _shimmerBox(double.infinity, 140, radius: 16),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            const Text(
              '데이터를 불러올 수 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<DashboardBloc>()
                  .add(LoadDashboard(forceRefresh: true)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
