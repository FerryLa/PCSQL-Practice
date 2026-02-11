import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/timer_model.dart';

// Events
abstract class TimerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitTimers extends TimerEvent {}

class StartTimer extends TimerEvent {
  final String timerId;
  StartTimer(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class PauseTimer extends TimerEvent {
  final String timerId;
  PauseTimer(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class ResetTimer extends TimerEvent {
  final String timerId;
  ResetTimer(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class AdjustDuration extends TimerEvent {
  final String timerId;
  final int deltaSeconds;
  AdjustDuration(this.timerId, this.deltaSeconds);

  @override
  List<Object?> get props => [timerId, deltaSeconds];
}

class _Tick extends TimerEvent {}

// States
class TimersState extends Equatable {
  final Map<String, TimerState> timers;

  const TimersState(this.timers);

  @override
  List<Object?> get props => [timers];
}

// BLoC
class TimerBloc extends Bloc<TimerEvent, TimersState> {
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc() : super(const TimersState({})) {
    on<InitTimers>(_onInit);
    on<StartTimer>(_onStart);
    on<PauseTimer>(_onPause);
    on<ResetTimer>(_onReset);
    on<AdjustDuration>(_onAdjust);
    on<_Tick>(_onTick);
  }

  void _onInit(InitTimers event, Emitter<TimersState> emit) {
    final timers = <String, TimerState>{};
    for (final config in TimerConfig.defaultTimers) {
      timers[config.id] = TimerState.initial(config);
    }
    emit(TimersState(timers));
  }

  void _onStart(StartTimer event, Emitter<TimersState> emit) {
    final timer = state.timers[event.timerId];
    if (timer == null || timer.isRunning) return;

    final updated = Map<String, TimerState>.from(state.timers);
    updated[event.timerId] = timer.copyWith(isRunning: true);
    emit(TimersState(updated));

    _ensureTickerRunning();
  }

  void _onPause(PauseTimer event, Emitter<TimersState> emit) {
    final timer = state.timers[event.timerId];
    if (timer == null || !timer.isRunning) return;

    final updated = Map<String, TimerState>.from(state.timers);
    updated[event.timerId] = timer.copyWith(isRunning: false);
    emit(TimersState(updated));

    _checkStopTicker();
  }

  void _onReset(ResetTimer event, Emitter<TimersState> emit) {
    final timer = state.timers[event.timerId];
    if (timer == null) return;

    final updated = Map<String, TimerState>.from(state.timers);
    updated[event.timerId] = TimerState.initial(timer.config);
    emit(TimersState(updated));

    _checkStopTicker();
  }

  void _onAdjust(AdjustDuration event, Emitter<TimersState> emit) {
    final timer = state.timers[event.timerId];
    if (timer == null || timer.isRunning) return;

    final newDuration = (timer.totalDuration + event.deltaSeconds)
        .clamp(5, 7200); // 5초 ~ 2시간
    final updated = Map<String, TimerState>.from(state.timers);
    updated[event.timerId] = timer.copyWith(
      remaining: newDuration,
      totalDuration: newDuration,
    );
    emit(TimersState(updated));
  }

  void _onTick(_Tick event, Emitter<TimersState> emit) {
    final updated = Map<String, TimerState>.from(state.timers);
    bool anyRunning = false;

    for (final entry in updated.entries) {
      final timer = entry.value;
      if (!timer.isRunning) continue;

      anyRunning = true;

      if (timer.remaining <= 1) {
        // 타이머 완료
        if (timer.config.type == TimerType.cycle &&
            timer.phase == TimerPhase.focus) {
          // 사이클 타이머: 집중 → 휴식 전환
          updated[entry.key] = timer.copyWith(
            remaining: timer.config.restDuration!,
            totalDuration: timer.config.restDuration!,
            phase: TimerPhase.rest,
          );
        } else {
          // 완료
          updated[entry.key] = timer.copyWith(
            remaining: 0,
            isRunning: false,
            phase: TimerPhase.complete,
          );
        }
      } else {
        updated[entry.key] = timer.copyWith(
          remaining: timer.remaining - 1,
        );
      }
    }

    emit(TimersState(updated));

    if (!anyRunning) {
      _tickerSubscription?.cancel();
      _tickerSubscription = null;
    }
  }

  void _ensureTickerRunning() {
    if (_tickerSubscription != null) return;
    _tickerSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (x) => x,
    ).listen((_) => add(_Tick()));
  }

  void _checkStopTicker() {
    final anyRunning = state.timers.values.any((t) => t.isRunning);
    if (!anyRunning) {
      _tickerSubscription?.cancel();
      _tickerSubscription = null;
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
