/// 타이머 유형
enum TimerType { simple, cycle }

/// 타이머 상태 (사이클 타이머)
enum TimerPhase { focus, rest, complete }

/// 타이머 설정 모델
class TimerConfig {
  final String id;
  final String name;
  final TimerType type;
  final int defaultDuration; // 초 단위
  final int? restDuration; // 사이클 타이머 휴식 시간 (초)

  const TimerConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.defaultDuration,
    this.restDuration,
  });

  /// 기본 타이머 목록
  static const List<TimerConfig> defaultTimers = [
    // 단순 타이머
    TimerConfig(
      id: 'rice',
      name: '밥짓기',
      type: TimerType.simple,
      defaultDuration: 40 * 60,
    ),
    TimerConfig(
      id: 'laundry',
      name: '빨래',
      type: TimerType.simple,
      defaultDuration: 120 * 60,
    ),
    TimerConfig(
      id: 'break',
      name: '휴식시간',
      type: TimerType.simple,
      defaultDuration: 10 * 60,
    ),
    // 사이클 타이머
    TimerConfig(
      id: 'pomodoro',
      name: '뽀모도로',
      type: TimerType.cycle,
      defaultDuration: 25 * 60,
      restDuration: 5 * 60,
    ),
    TimerConfig(
      id: 'ultradian',
      name: '울트라디안 리듬',
      type: TimerType.cycle,
      defaultDuration: 90 * 60,
      restDuration: 20 * 60,
    ),
    TimerConfig(
      id: '52-17',
      name: '52-17 기법',
      type: TimerType.cycle,
      defaultDuration: 52 * 60,
      restDuration: 17 * 60,
    ),
  ];
}

/// 개별 타이머 상태
class TimerState {
  final TimerConfig config;
  final int remaining;
  final int totalDuration;
  final bool isRunning;
  final TimerPhase phase;

  const TimerState({
    required this.config,
    required this.remaining,
    required this.totalDuration,
    this.isRunning = false,
    this.phase = TimerPhase.focus,
  });

  TimerState copyWith({
    int? remaining,
    int? totalDuration,
    bool? isRunning,
    TimerPhase? phase,
  }) {
    return TimerState(
      config: config,
      remaining: remaining ?? this.remaining,
      totalDuration: totalDuration ?? this.totalDuration,
      isRunning: isRunning ?? this.isRunning,
      phase: phase ?? this.phase,
    );
  }

  /// MM:SS 형식으로 표시
  String get displayTime {
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// 진행률 (0.0 ~ 1.0)
  double get progress =>
      totalDuration > 0 ? 1.0 - (remaining / totalDuration) : 0.0;

  /// 초기 상태 생성
  factory TimerState.initial(TimerConfig config) {
    return TimerState(
      config: config,
      remaining: config.defaultDuration,
      totalDuration: config.defaultDuration,
    );
  }
}
