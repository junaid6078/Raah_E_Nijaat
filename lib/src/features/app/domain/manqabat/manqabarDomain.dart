class Manqabat {
  final String type;
  final String typeEng;
  final String subject;
  final String poet;
  final List<String> lines;

  Manqabat({
    required this.type,
    required this.typeEng,
    required this.subject,
    required this.poet,
    required this.lines,
  });

  factory Manqabat.fromJson(Map json) {
    return Manqabat(
      type: json['type'],
      typeEng: json['typeEng'],
      subject: json['subject'],
      poet: json['poet'],
      lines: (json['lines'] as List).map((e) => e.toString()).toList(),
    );
  }
}