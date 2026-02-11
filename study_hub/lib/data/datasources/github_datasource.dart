import 'dart:convert';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// GitHub에서 데이터를 가져오는 데이터소스
class GitHubDataSource {
  final ApiClient _apiClient;

  GitHubDataSource(this._apiClient);

  /// Root README.md 가져오기
  Future<String> fetchRootReadme() =>
      _apiClient.fetchRawContent(ApiConstants.rootReadme);

  /// 학습 트래커 README.md 가져오기
  Future<String> fetchStudyTrackerReadme() =>
      _apiClient.fetchRawContent(ApiConstants.studyTrackerReadme);

  /// events_data.json 가져오기
  Future<Map<String, dynamic>> fetchEventsData() async {
    final content =
        await _apiClient.fetchRawContent(ApiConstants.eventsDataJson);
    return json.decode(content) as Map<String, dynamic>;
  }

  /// GitHub Actions 워크플로우 실행 목록 가져오기
  Future<Map<String, dynamic>> fetchWorkflowRuns() =>
      _apiClient.fetchApiJson(ApiConstants.actionsApiUrl());

  /// 디렉토리 내용 가져오기
  Future<List<dynamic>> fetchDirectoryContents(String path) =>
      _apiClient.fetchApiList(ApiConstants.contentsApiUrl(path));
}
