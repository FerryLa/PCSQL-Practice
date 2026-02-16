class ApiConstants {
  static const String owner = 'FerryLa';
  static const String repo = 'PCSQL-Practice';
  static const String branch = 'main';

  static const String rawBaseUrl = 'https://raw.githubusercontent.com';
  static const String apiBaseUrl = 'https://api.github.com';

  static String rawContentUrl(String path) =>
      '$rawBaseUrl/$owner/$repo/$branch/$path';

  static String contentsApiUrl(String path) =>
      '$apiBaseUrl/repos/$owner/$repo/contents/$path';

  static String actionsApiUrl() =>
      '$apiBaseUrl/repos/$owner/$repo/actions/runs';

  // File paths
  static const String rootReadme = 'README.md';
  static const String studyTrackerReadme = '01_cert_week_7/README.md';
  static const String eventsDataJson = '05_calender/events_data.json';
  static const String sqlProgrammersPath = '00_sql-analytics-practice/programmers';

  // Markdown markers
  static const String programmersWeeklyStart = '<!-- PROGRAMMERS_WEEKLY:START -->';
  static const String programmersWeeklyEnd = '<!-- PROGRAMMERS_WEEKLY:END -->';
  static const String ecommerceStart = '<!-- ECOMMERCE_CHALLENGE:START -->';
  static const String ecommerceEnd = '<!-- ECOMMERCE_CHALLENGE:END -->';
  static const String progressStart = '<!-- PROGRESS:START -->';
  static const String progressEnd = '<!-- PROGRESS:END -->';
}
