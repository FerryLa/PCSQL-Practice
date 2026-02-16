import 'dart:convert';
import '../datasources/github_datasource.dart';
import '../datasources/cache_datasource.dart';
import '../models/event_model.dart';

/// 캘린더 데이터 Repository
class CalendarRepository {
  final GitHubDataSource _gitHub;
  final CacheDataSource _cache;

  static const String _cacheKey = 'events_data';
  static const int _ttlHours = 24;

  CalendarRepository(this._gitHub, this._cache);

  /// 모든 이벤트 가져오기
  Future<EventsData> getEvents({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh &&
          _cache.isCacheValid(_cacheKey, ttlHours: _ttlHours)) {
        return _buildFromCache();
      }

      final json = await _gitHub.fetchEventsData();
      await _cache.cacheString(_cacheKey, jsonEncode(json));

      return EventsData.fromJson(json);
    } catch (e) {
      final cached = _buildFromCache();
      if (cached.allEvents.isNotEmpty) return cached;
      rethrow;
    }
  }

  /// 카테고리별 필터링
  Future<List<EventModel>> getEventsByCategory(
    String category, {
    bool forceRefresh = false,
  }) async {
    final data = await getEvents(forceRefresh: forceRefresh);
    switch (category) {
      case 'domestic':
        return data.domestic;
      case 'international':
        return data.international;
      case 'academic':
        return data.academic;
      case 'certifications':
        return data.certifications;
      default:
        return data.allEvents;
    }
  }

  /// 검색
  Future<List<EventModel>> searchEvents(String query) async {
    final data = await getEvents();
    final lowerQuery = query.toLowerCase();
    return data.allEvents.where((event) {
      return event.name.toLowerCase().contains(lowerQuery) ||
          event.city.toLowerCase().contains(lowerQuery) ||
          event.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  EventsData _buildFromCache() {
    final cached = _cache.getCachedString(_cacheKey);
    if (cached == null) {
      return const EventsData(
        domestic: [],
        international: [],
        academic: [],
        certifications: [],
        countryFlags: {},
      );
    }
    return EventsData.fromJson(
      jsonDecode(cached) as Map<String, dynamic>,
    );
  }
}
