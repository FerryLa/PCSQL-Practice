/// 캘린더 이벤트 모델
class EventModel {
  final String date;
  final String name;
  final String location;
  final String city;
  final String description;
  final String category;

  const EventModel({
    required this.date,
    required this.name,
    required this.location,
    required this.city,
    required this.description,
    required this.category,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String category) {
    return EventModel(
      date: json['date'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      city: json['city'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
        'location': location,
        'city': city,
        'description': description,
        'category': category,
      };
}

/// events_data.json 전체 구조
class EventsData {
  final List<EventModel> domestic;
  final List<EventModel> international;
  final List<EventModel> academic;
  final List<EventModel> certifications;
  final Map<String, String> countryFlags;

  const EventsData({
    required this.domestic,
    required this.international,
    required this.academic,
    required this.certifications,
    required this.countryFlags,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      domestic: _parseEventList(json['domestic'], 'domestic'),
      international: _parseEventList(json['international'], 'international'),
      academic: _parseEventList(json['academic'], 'academic'),
      certifications: _parseEventList(json['certifications'], 'certifications'),
      countryFlags: (json['country_flags'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
    );
  }

  static List<EventModel> _parseEventList(dynamic list, String category) {
    if (list is! List) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => EventModel.fromJson(e, category))
        .toList();
  }

  /// 모든 이벤트를 하나의 리스트로
  List<EventModel> get allEvents => [
        ...domestic,
        ...international,
        ...academic,
        ...certifications,
      ];

  /// 국기 이모지 가져오기
  String getFlag(String locationCode) =>
      countryFlags[locationCode] ?? '';
}
