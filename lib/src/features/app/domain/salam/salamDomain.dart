class Salam {
  final String type;
  final String typeEng;
  final String subject;
  final String poet;
  final List<String> lines;

  Salam({
    required this.type,
    required this.typeEng,
    required this.subject,
    required this.poet,
    required this.lines,
  });

  factory Salam.fromJson(Map json) {
    return Salam(
      type: json['type'],
      typeEng: json['typeEng'],
      subject: json['subject'],
      poet: json['poet'],
      lines: (json['lines'] as List).map((e) => e.toString()).toList(),
    );
  }
}