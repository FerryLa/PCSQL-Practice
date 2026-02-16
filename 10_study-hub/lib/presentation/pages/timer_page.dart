import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer/timer_bloc.dart';
import '../../data/models/timer_model.dart';
import '../../app/theme.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TimerBloc, TimersState>(
          builder: (context, state) {
            if (state.timers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final simpleTimers = state.timers.entries
                .where((e) => e.value.config.type == TimerType.simple)
                .toList();
            final cycleTimers = state.timers.entries
                .where((e) => e.value.config.type == TimerType.cycle)
                .toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '집중하세요',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '타이머',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 단순 타이머
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: _SectionHeader(
                      title: '단순 타이머',
                      icon: Icons.timer_outlined,
                      color: AppColors.timerColor,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      simpleTimers
                          .map((e) => _TimerCard(
                                timerId: e.key,
                                timer: e.value,
                              ))
                          .toList(),
                    ),
                  ),
                ),

                // 사이클 타이머
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: _SectionHeader(
                      title: '사이클 타이머',
                      icon: Icons.all_inclusive_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      cycleTimers
                          .map((e) => _TimerCard(
                                timerId: e.key,
                                timer: e.value,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TimerCard extends StatelessWidget {
  final String timerId;
  final TimerState timer;

  const _TimerCard({required this.timerId, required this.timer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: timer.isRunning
              ? Border.all(color: _accentColor.withValues(alpha: 0.3), width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 헤더
              Row(
                children: [
                  Text(
                    _timerEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timer.config.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (timer.config.type == TimerType.cycle)
                          Text(
                            '${timer.config.defaultDuration ~/ 60}분 집중 / ${timer.config.restDuration! ~/ 60}분 휴식',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (timer.config.type == TimerType.cycle)
                    _PhaseChip(phase: timer.phase),
                ],
              ),
              const SizedBox(height: 20),

              // 원형 타이머
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 원형 프로그레스
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _CircularTimerPainter(
                        progress: timer.progress,
                        color: _accentColor,
                        bgColor: _accentColor.withValues(alpha: 0.1),
                        strokeWidth: 8,
                      ),
                    ),
                    // 시간 표시
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timer.displayTime,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'monospace',
                            color: _textColor,
                            letterSpacing: 2,
                          ),
                        ),
                        if (timer.isRunning)
                          Text(
                            timer.phase == TimerPhase.rest ? '휴식 중' : '진행 중',
                            style: TextStyle(
                              fontSize: 11,
                              color: _accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 시간 조절 (정지 상태에서만)
              if (!timer.isRunning && timer.phase != TimerPhase.complete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AdjustChip(
                        label: '-5분',
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(AdjustDuration(timerId, -5 * 60)),
                      ),
                      _AdjustChip(
                        label: '-1분',
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(AdjustDuration(timerId, -60)),
                      ),
                      _AdjustChip(
                        label: '+1분',
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(AdjustDuration(timerId, 60)),
                      ),
                      _AdjustChip(
                        label: '+5분',
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(AdjustDuration(timerId, 5 * 60)),
                      ),
                    ],
                  ),
                ),

              // 컨트롤 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (timer.phase == TimerPhase.complete ||
                      (timer.remaining == 0 && !timer.isRunning))
                    _ActionButton(
                      icon: Icons.refresh_rounded,
                      label: '리셋',
                      color: AppColors.textSecondary,
                      onPressed: () =>
                          context.read<TimerBloc>().add(ResetTimer(timerId)),
                    )
                  else ...[
                    // 리셋 버튼
                    _ActionButton(
                      icon: Icons.refresh_rounded,
                      label: '리셋',
                      color: AppColors.textSecondary,
                      outlined: true,
                      onPressed: () =>
                          context.read<TimerBloc>().add(ResetTimer(timerId)),
                    ),
                    const SizedBox(width: 16),
                    // 시작/일시정지
                    if (!timer.isRunning)
                      _ActionButton(
                        icon: Icons.play_arrow_rounded,
                        label: '시작',
                        color: AppColors.success,
                        onPressed: () =>
                            context.read<TimerBloc>().add(StartTimer(timerId)),
                      )
                    else
                      _ActionButton(
                        icon: Icons.pause_rounded,
                        label: '일시정지',
                        color: AppColors.warning,
                        onPressed: () =>
                            context.read<TimerBloc>().add(PauseTimer(timerId)),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _timerEmoji {
    switch (timer.config.id) {
      case 'rice':
        return '🍚';
      case 'laundry':
        return '👕';
      case 'break':
        return '☕';
      case 'pomodoro':
        return '🍅';
      case 'ultradian':
        return '🧠';
      case '52-17':
        return '⚡';
      default:
        return '⏱️';
    }
  }

  Color get _accentColor {
    if (timer.phase == TimerPhase.complete) return AppColors.success;
    if (timer.phase == TimerPhase.rest) return AppColors.info;
    if (timer.isRunning) return AppColors.timerColor;
    return AppColors.textHint;
  }

  Color get _textColor {
    if (timer.phase == TimerPhase.complete) return AppColors.success;
    if (timer.isRunning) return AppColors.timerColor;
    return AppColors.textPrimary;
  }
}

class _PhaseChip extends StatelessWidget {
  final TimerPhase phase;

  const _PhaseChip({required this.phase});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (phase) {
      TimerPhase.focus => ('집중', AppColors.timerColor),
      TimerPhase.rest => ('휴식', AppColors.info),
      TimerPhase.complete => ('완료', AppColors.success),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AdjustChip extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AdjustChip({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.outlined = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}

/// 원형 타이머 페인터
class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;
  final double strokeWidth;

  _CircularTimerPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 배경 원
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // 프로그레스 호
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
