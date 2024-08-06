class Naat {
  final String type;
  final String typeEng;
  final String subject;
  final String poet;
  final List<String> lines;

  Naat({
    required this.type,
    required this.typeEng,
    required this.subject,
    required this.poet,
    required this.lines,
  });

  factory Naat.fromJson(Map json) {
    return Naat(
      type: json['type'],
      typeEng: json['typeEng'],
      subject: json['subject'],
      poet: json['poet'],
      lines: (json['lines'] as List).map((e) => e.toString()).toList(),
    );
  }
}
