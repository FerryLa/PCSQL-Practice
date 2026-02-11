import 'dart:convert';
import 'package:hive/hive.dart';

/// Hive 기반 로컬 캐시 데이터소스
class CacheDataSource {
  static const String _boxName = 'cache_box';
  static const String _timestampSuffix = '_timestamp';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// 문자열 캐시 저장
  Future<void> cacheString(String key, String value) async {
    await _box.put(key, value);
    await _box.put('$key$_timestampSuffix', DateTime.now().toIso8601String());
  }

  /// 문자열 캐시 조회
  String? getCachedString(String key) {
    return _box.get(key) as String?;
  }

  /// JSON 캐시 저장
  Future<void> cacheJson(String key, Map<String, dynamic> data) async {
    await cacheString(key, json.encode(data));
  }

  /// JSON 캐시 조회
  Map<String, dynamic>? getCachedJson(String key) {
    final cached = getCachedString(key);
    if (cached == null) return null;
    return json.decode(cached) as Map<String, dynamic>;
  }

  /// 캐시 유효성 확인 (TTL 기반)
  bool isCacheValid(String key, {required int ttlHours}) {
    final timestampStr = _box.get('$key$_timestampSuffix') as String?;
    if (timestampStr == null) return false;

    final timestamp = DateTime.tryParse(timestampStr);
    if (timestamp == null) return false;

    final age = DateTime.now().difference(timestamp);
    return age.inHours < ttlHours;
  }

  /// 캐시 타임스탬프 조회
  DateTime? getCacheTimestamp(String key) {
    final timestampStr = _box.get('$key$_timestampSuffix') as String?;
    if (timestampStr == null) return null;
    return DateTime.tryParse(timestampStr);
  }

  /// 특정 키 캐시 삭제
  Future<void> invalidate(String key) async {
    await _box.delete(key);
    await _box.delete('$key$_timestampSuffix');
  }

  /// 전체 캐시 삭제
  Future<void> clearAll() async {
    await _box.clear();
  }
}
