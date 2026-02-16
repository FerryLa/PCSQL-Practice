/// 다양한 한국/표준 날짜 형식을 파싱하는 유틸리티
class DateParser {
  /// 단일 날짜 파싱
  static DateTime? parseDate(String dateStr) {
    final trimmed = dateStr.trim();

    // ISO 형식: 2026-01-12
    try {
      return DateTime.parse(trimmed);
    } catch (_) {}

    // 한국어 형식: 2026년 1월 12일
    final koreanMatch =
        RegExp(r'(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일').firstMatch(trimmed);
    if (koreanMatch != null) {
      return DateTime(
        int.parse(koreanMatch.group(1)!),
        int.parse(koreanMatch.group(2)!),
        int.parse(koreanMatch.group(3)!),
      );
    }

    return null;
  }

  /// 날짜 범위 파싱 (다양한 형식 지원)
  static DateRange? parseDateRange(String dateStr) {
    final trimmed = dateStr.trim();

    // 특수 형식: "상시"
    if (trimmed == '상시') {
      return DateRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 365)),
        isRecurring: true,
      );
    }

    // 특수 형식: "2026년 초/중/말"
    final approxMatch = RegExp(r'(\d{4})년\s*(초|중|말)').firstMatch(trimmed);
    if (approxMatch != null) {
      final year = int.parse(approxMatch.group(1)!);
      final period = approxMatch.group(2)!;
      switch (period) {
        case '초':
          return DateRange(
            start: DateTime(year, 1, 1),
            end: DateTime(year, 4, 30),
            isApproximate: true,
          );
        case '중':
          return DateRange(
            start: DateTime(year, 5, 1),
            end: DateTime(year, 8, 31),
            isApproximate: true,
          );
        case '말':
          return DateRange(
            start: DateTime(year, 9, 1),
            end: DateTime(year, 12, 31),
            isApproximate: true,
          );
      }
    }

    // 범위 형식: 2026-01-06~09 또는 2026-04-26~05-01
    if (trimmed.contains('~')) {
      final parts = trimmed.split('~');
      final startStr = parts[0].trim();
      final endStr = parts[1].trim();

      final startDate = DateTime.tryParse(startStr);
      if (startDate == null) return null;

      DateTime endDate;
      if (endStr.length <= 2) {
        // 일만: ~09
        endDate = DateTime(startDate.year, startDate.month, int.parse(endStr));
      } else if (endStr.contains('-') && endStr.length <= 5) {
        // 월-일: ~05-01
        final endParts = endStr.split('-');
        endDate = DateTime(
          startDate.year,
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );
      } else {
        // 전체 날짜
        endDate = DateTime.tryParse(endStr) ?? startDate;
      }

      return DateRange(start: startDate, end: endDate);
    }

    // 단일 날짜
    final singleDate = parseDate(trimmed);
    if (singleDate != null) {
      return DateRange(start: singleDate, end: singleDate);
    }

    return null;
  }

  /// 날짜를 표시용 문자열로 변환
  static String formatDisplayDate(String dateStr) {
    final range = parseDateRange(dateStr);
    if (range == null) return dateStr;

    if (range.isRecurring) return '상시';
    if (range.isApproximate) return dateStr;

    if (range.isSingleDay) {
      final d = range.start;
      return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
    }

    final s = range.start;
    final e = range.end;
    return '${s.month}/${s.day} ~ ${e.month}/${e.day}';
  }
}

/// 날짜 범위
class DateRange {
  final DateTime start;
  final DateTime end;
  final bool isRecurring;
  final bool isApproximate;

  const DateRange({
    required this.start,
    required this.end,
    this.isRecurring = false,
    this.isApproximate = false,
  });

  bool get isSingleDay =>
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;

  int get durationInDays => end.difference(start).inDays + 1;
}
