class Kalam {
  final String type;
  final String typeEng;
  final String subject;
  final String poet;
  final List<String> lines;

  Kalam({
    required this.type,
    required this.typeEng,
    required this.subject,
    required this.poet,
    required this.lines,
  });

  factory Kalam.fromJson(Map json) {
    return Kalam(
      type: json['type'],
      typeEng: json['typeEng'],
      subject: json['subject'],
      poet: json['poet'],
      lines: (json['lines'] as List).map((e) => e.toString()).toList(),
    );
  }
}