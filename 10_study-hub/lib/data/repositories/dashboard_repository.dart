import '../datasources/github_datasource.dart';
import '../datasources/cache_datasource.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/markdown_parser.dart';

/// 대시보드 요약 데이터
class DashboardSummary {
  final List<WeeklyStat> sqlStats;
  final List<WeeklyStat> ecommerceStats;
  final List<StudyWeek> studyProgress;
  final String? lastActionRun;
  final bool isCached;
  final DateTime? cacheTimestamp;

  const DashboardSummary({
    required this.sqlStats,
    required this.ecommerceStats,
    required this.studyProgress,
    this.lastActionRun,
    this.isCached = false,
    this.cacheTimestamp,
  });
}

/// 대시보드 데이터 Repository
class DashboardRepository {
  final GitHubDataSource _gitHub;
  final CacheDataSource _cache;

  static const String _readmeCacheKey = 'root_readme';
  static const String _studyCacheKey = 'study_readme';
  static const int _ttlHours = 1;

  DashboardRepository(this._gitHub, this._cache);

  /// 대시보드 데이터 가져오기
  Future<DashboardSummary> getDashboardSummary({
    bool forceRefresh = false,
  }) async {
    try {
      // 캐시 유효한 경우
      if (!forceRefresh &&
          _cache.isCacheValid(_readmeCacheKey, ttlHours: _ttlHours) &&
          _cache.isCacheValid(_studyCacheKey, ttlHours: _ttlHours)) {
        return _buildFromCache();
      }

      // GitHub에서 데이터 가져오기
      final rootReadme = await _gitHub.fetchRootReadme();
      final studyReadme = await _gitHub.fetchStudyTrackerReadme();

      // 캐시 저장
      await _cache.cacheString(_readmeCacheKey, rootReadme);
      await _cache.cacheString(_studyCacheKey, studyReadme);

      // GitHub Actions 상태 (선택적)
      String? lastActionRun;
      try {
        final actions = await _gitHub.fetchWorkflowRuns();
        final runs = actions['workflow_runs'] as List?;
        if (runs != null && runs.isNotEmpty) {
          lastActionRun = runs[0]['updated_at'] as String?;
        }
      } catch (_) {
        // Actions API 실패 시 무시
      }

      return _buildSummary(rootReadme, studyReadme, lastActionRun);
    } catch (e) {
      // 에러 시 캐시 데이터 반환
      final cached = _buildFromCache();
      if (cached.sqlStats.isNotEmpty || cached.studyProgress.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  DashboardSummary _buildSummary(
    String rootReadme,
    String studyReadme,
    String? lastActionRun,
  ) {
    final sqlStats = MarkdownParser.parseWeeklyStats(
      rootReadme,
      ApiConstants.programmersWeeklyStart,
      ApiConstants.programmersWeeklyEnd,
    );

    final ecommerceStats = MarkdownParser.parseWeeklyStats(
      rootReadme,
      ApiConstants.ecommerceStart,
      ApiConstants.ecommerceEnd,
    );

    final studyProgress = MarkdownParser.parseStudyTracker(studyReadme);

    return DashboardSummary(
      sqlStats: sqlStats,
      ecommerceStats: ecommerceStats,
      studyProgress: studyProgress,
      lastActionRun: lastActionRun,
    );
  }

  DashboardSummary _buildFromCache() {
    final rootReadme = _cache.getCachedString(_readmeCacheKey) ?? '';
    final studyReadme = _cache.getCachedString(_studyCacheKey) ?? '';

    final summary = _buildSummary(rootReadme, studyReadme, null);
    return DashboardSummary(
      sqlStats: summary.sqlStats,
      ecommerceStats: summary.ecommerceStats,
      studyProgress: summary.studyProgress,
      isCached: true,
      cacheTimestamp: _cache.getCacheTimestamp(_readmeCacheKey),
    );
  }
}
