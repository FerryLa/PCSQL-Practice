/// 마크다운 테이블 파싱 유틸리티
class MarkdownParser {
  /// 마커 사이의 콘텐츠를 추출
  static String? extractBetweenMarkers(
    String markdown,
    String startMarker,
    String endMarker,
  ) {
    final startIndex = markdown.indexOf(startMarker);
    final endIndex = markdown.indexOf(endMarker);

    if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
      return null;
    }

    return markdown
        .substring(startIndex + startMarker.length, endIndex)
        .trim();
  }

  /// 마크다운 테이블을 2D 리스트로 파싱
  static List<List<String>> parseTable(String tableMarkdown) {
    final lines = tableMarkdown
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && line.startsWith('|'))
        .toList();

    // 구분선 제거 (|---|---|)
    lines.removeWhere((line) => RegExp(r'^\|[\s\-:|]+\|$').hasMatch(line));

    return lines.map((line) {
      return line
          .split('|')
          .where((cell) => cell.isNotEmpty)
          .map((cell) => cell.trim())
          .toList();
    }).toList();
  }

  /// 주간 통계 테이블 파싱 (Week | Count | Graph)
  static List<WeeklyStat> parseWeeklyStats(
    String markdown,
    String startMarker,
    String endMarker,
  ) {
    final tableContent = extractBetweenMarkers(markdown, startMarker, endMarker);
    if (tableContent == null) return [];

    final rows = parseTable(tableContent);
    if (rows.length < 2) return [];

    // 첫 줄은 헤더, 나머지가 데이터
    return rows.skip(1).map((row) {
      if (row.length < 2) return null;
      return WeeklyStat(
        weekLabel: row[0],
        count: int.tryParse(row[1].trim()) ?? 0,
        graph: row.length > 2 ? row[2] : '',
      );
    }).whereType<WeeklyStat>().toList();
  }

  /// 학습 트래커 테이블 파싱
  static List<StudyWeek> parseStudyTracker(String markdown) {
    final tableContent = extractBetweenMarkers(
      markdown,
      '<!-- PROGRESS:START -->',
      '<!-- PROGRESS:END -->',
    );
    if (tableContent == null) return [];

    final lines = tableContent.split('\n').map((l) => l.trim()).toList();
    final weeks = <StudyWeek>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Week 헤더 찾기
      final weekMatch = RegExp(r'\| (Week \d+ \(.+?\))').firstMatch(line);
      if (weekMatch == null) continue;

      final weekLabel = weekMatch.group(1)!;

      // 헤더에서 날짜 추출
      final dateCells = line
          .split('|')
          .where((c) => c.isNotEmpty)
          .map((c) => c.trim())
          .skip(1) // Week label 건너뛰기
          .toList();

      // 구분선 건너뛰기
      i++;
      if (i >= lines.length) break;

      // Status 행 파싱
      i++;
      if (i >= lines.length) break;
      final statusLine = lines[i];
      final statusCells = statusLine
          .split('|')
          .where((c) => c.isNotEmpty)
          .map((c) => c.trim())
          .skip(1) // "Status" 레이블 건너뛰기
          .toList();

      // Note 행 파싱 (있을 경우)
      i++;
      List<String> noteCells = [];
      if (i < lines.length && lines[i].contains('Note')) {
        noteCells = lines[i]
            .split('|')
            .where((c) => c.isNotEmpty)
            .map((c) => c.trim())
            .skip(1)
            .toList();
      }

      final days = <StudyDay>[];
      for (int j = 0; j < dateCells.length; j++) {
        final dateStr = dateCells[j];
        final status = j < statusCells.length ? statusCells[j] : '';
        final note = j < noteCells.length ? noteCells[j] : '';

        days.add(StudyDay(
          date: dateStr,
          status: _parseStatus(status),
          note: note,
        ));
      }

      weeks.add(StudyWeek(label: weekLabel, days: days));
    }

    return weeks;
  }

  static StudyStatus _parseStatus(String emoji) {
    if (emoji.contains('✅')) return StudyStatus.complete;
    if (emoji.contains('⏰')) return StudyStatus.late;
    if (emoji.contains('❌')) return StudyStatus.missed;
    return StudyStatus.empty;
  }
}

/// 주간 통계 데이터
class WeeklyStat {
  final String weekLabel;
  final int count;
  final String graph;

  const WeeklyStat({
    required this.weekLabel,
    required this.count,
    required this.graph,
  });
}

/// 학습 상태
enum StudyStatus { complete, late, missed, empty }

/// 일일 학습 데이터
class StudyDay {
  final String date;
  final StudyStatus status;
  final String note;

  const StudyDay({
    required this.date,
    required this.status,
    required this.note,
  });
}

/// 주간 학습 데이터
class StudyWeek {
  final String label;
  final List<StudyDay> days;

  const StudyWeek({required this.label, required this.days});

  int get completedCount =>
      days.where((d) => d.status == StudyStatus.complete).length;
  int get totalCount => days.length;
  double get completionRate =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}
