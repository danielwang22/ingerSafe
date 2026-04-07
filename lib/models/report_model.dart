enum RiskLevel {
  safe,
  warning,
  danger,
  unknown,
}

class Report {
  final String id;
  final String title;
  final String summary;
  final RiskLevel riskLevel;
  final List<String> imageUrls;
  final DateTime date;
  final String? fullAnalysis;
  final String? userNote;

  Report({
    required this.id,
    required this.title,
    required this.summary,
    required this.riskLevel,
    this.imageUrls = const [],
    required this.date,
    this.fullAnalysis,
    this.userNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'riskLevel': riskLevel.name,
      'imageUrls': imageUrls,
      'date': date.toIso8601String(),
      'fullAnalysis': fullAnalysis,
      'userNote': userNote,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    // 向下相容：舊資料可能只有 imageUrl (單一字串)
    List<String> urls = [];
    if (json['imageUrls'] != null) {
      urls = List<String>.from(json['imageUrls']);
    } else if (json['imageUrl'] != null) {
      urls = [json['imageUrl'] as String];
    }

    return Report(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == json['riskLevel'],
        orElse: () => RiskLevel.unknown,
      ),
      imageUrls: urls,
      date: DateTime.parse(json['date'] as String),
      fullAnalysis: json['fullAnalysis'] as String?,
      userNote: json['userNote'] as String?,
    );
  }

  Report copyWith({
    String? id,
    String? title,
    String? summary,
    RiskLevel? riskLevel,
    List<String>? imageUrls,
    DateTime? date,
    Object? fullAnalysis = _sentinel,
    Object? userNote = _sentinel,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      riskLevel: riskLevel ?? this.riskLevel,
      imageUrls: imageUrls ?? this.imageUrls,
      date: date ?? this.date,
      fullAnalysis: fullAnalysis == _sentinel
          ? this.fullAnalysis
          : fullAnalysis as String?,
      userNote: userNote == _sentinel ? this.userNote : userNote as String?,
    );
  }
}

const Object _sentinel = Object();
