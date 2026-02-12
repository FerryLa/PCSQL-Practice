import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repositories/calendar_repository.dart';

// Events
abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends CalendarEvent {
  final bool forceRefresh;
  LoadEvents({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class FilterByCategory extends CalendarEvent {
  final String? category;
  FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchEvents extends CalendarEvent {
  final String query;
  SearchEvents(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class CalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final EventsData eventsData;
  final List<EventModel> displayedEvents;
  final String? activeCategory;
  final String searchQuery;

  CalendarLoaded({
    required this.eventsData,
    required this.displayedEvents,
    this.activeCategory,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props =>
      [displayedEvents, activeCategory, searchQuery];
}

class CalendarError extends CalendarState {
  final String message;
  CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository _repository;
  EventsData? _eventsData;

  CalendarBloc(this._repository) : super(CalendarInitial()) {
    on<LoadEvents>(_onLoad);
    on<FilterByCategory>(_onFilter);
    on<SearchEvents>(_onSearch);
  }

  Future<void> _onLoad(
    LoadEvents event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      _eventsData = await _repository.getEvents(
        forceRefresh: event.forceRefresh,
      );
      emit(CalendarLoaded(
        eventsData: _eventsData!,
        displayedEvents: _eventsData!.allEvents,
      ));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  void _onFilter(
    FilterByCategory event,
    Emitter<CalendarState> emit,
  ) {
    if (_eventsData == null) return;

    List<EventModel> filtered;
    if (event.category == null) {
      filtered = _eventsData!.allEvents;
    } else {
      filtered = _eventsData!.allEvents
          .where((e) => e.category == event.category)
          .toList();
    }

    emit(CalendarLoaded(
      eventsData: _eventsData!,
      displayedEvents: filtered,
      activeCategory: event.category,
    ));
  }

  void _onSearch(
    SearchEvents event,
    Emitter<CalendarState> emit,
  ) {
    if (_eventsData == null) return;

    final query = event.query.toLowerCase();
    final filtered = _eventsData!.allEvents.where((e) {
      return e.name.toLowerCase().contains(query) ||
          e.city.toLowerCase().contains(query) ||
          e.description.toLowerCase().contains(query);
    }).toList();

    emit(CalendarLoaded(
      eventsData: _eventsData!,
      displayedEvents: filtered,
      searchQuery: event.query,
    ));
  }
}
