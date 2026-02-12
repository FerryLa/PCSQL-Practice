import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/calendar/calendar_bloc.dart';
import '../../data/models/event_model.dart';
import '../../core/utils/date_parser.dart';
import '../../app/theme.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '다가오는 일정',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '캘린더',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.calendarColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search_rounded,
                          color: AppColors.calendarColor),
                      onPressed: () => _showSearch(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.calendarColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppColors.calendarColor),
                      onPressed: () => context
                          .read<CalendarBloc>()
                          .add(LoadEvents(forceRefresh: true)),
                    ),
                  ),
                ],
              ),
            ),

            // 필터
            BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoaded) {
                  return _CategoryFilter(activeCategory: state.activeCategory);
                }
                return const SizedBox.shrink();
              },
            ),

            // 이벤트 리스트
            Expanded(
              child: BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  if (state is CalendarLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CalendarError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 48, color: AppColors.error),
                          const SizedBox(height: 12),
                          Text('오류: ${state.message}'),
                        ],
                      ),
                    );
                  }
                  if (state is CalendarLoaded) {
                    return _EventList(
                      events: state.displayedEvents,
                      eventsData: state.eventsData,
                    );
                  }
                  return const Center(child: Text('로딩 중...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(dialogContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이벤트 검색',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '이벤트명, 도시, 설명으로 검색',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppColors.primary.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (query) {
                  context.read<CalendarBloc>().add(SearchEvents(query));
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final String? activeCategory;

  const _CategoryFilter({this.activeCategory});

  @override
  Widget build(BuildContext context) {
    final categories = [
      (null, '전체', Icons.grid_view_rounded, AppColors.textSecondary),
      ('domestic', '국내', Icons.home_rounded, Colors.blue),
      ('international', '국제', Icons.public_rounded, Colors.teal),
      ('academic', '학술', Icons.school_rounded, Colors.purple),
      ('certifications', '자격증', Icons.workspace_premium_rounded, Colors.orange),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: categories.map((cat) {
            final isActive = cat.$1 == activeCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => context
                    .read<CalendarBloc>()
                    .add(FilterByCategory(cat.$1)),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? cat.$4.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? cat.$4
                          : AppColors.textHint.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(cat.$3,
                          size: 14,
                          color: isActive ? cat.$4 : AppColors.textHint),
                      const SizedBox(width: 6),
                      Text(
                        cat.$2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? cat.$4 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<EventModel> events;
  final EventsData eventsData;

  const _EventList({required this.events, required this.eventsData});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text('이벤트가 없습니다',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventCard(
          event: events[index],
          flag: eventsData.getFlag(events[index].location),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  final String flag;

  const _EventCard({required this.event, required this.flag});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 국기
            if (flag.isNotEmpty)
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: _categoryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(flag, style: const TextStyle(fontSize: 22)),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 날짜 + 장소
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        DateParser.formatDisplayDate(event.date),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      if (event.city.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Icon(Icons.location_on_rounded,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          event.city,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      event.description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _CategoryBadge(category: event.category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _categoryColor {
    switch (event.category) {
      case 'domestic':
        return Colors.blue;
      case 'international':
        return Colors.teal;
      case 'academic':
        return Colors.purple;
      case 'certifications':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final config = switch (category) {
      'domestic' => ('국내', Colors.blue),
      'international' => ('국제', Colors.teal),
      'academic' => ('학술', Colors.purple),
      'certifications' => ('자격증', Colors.orange),
      _ => ('기타', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          color: config.$2,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
