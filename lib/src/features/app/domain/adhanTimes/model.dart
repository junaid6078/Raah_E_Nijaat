
class AdhanData {
  final Map<String, String> timings;
  final AdhanDate date;
  final AdhanMeta meta;

  AdhanData({
    required this.timings,
    required this.date,
    required this.meta,
  });

  factory AdhanData.fromJson(Map<String, dynamic> json) {
    return AdhanData(
      timings: Map<String, String>.from(json['timings']),
      date: AdhanDate.fromJson(json['date']),
      meta: AdhanMeta.fromJson(json['meta']),
    );
  }
}

class AdhanDate {
  final String readable;
  final String timestamp;
  final AdhanGregorian gregorian;
  final AdhanHijri hijri;

  AdhanDate({
    required this.readable,
    required this.timestamp,
    required this.gregorian,
    required this.hijri,
  });

  factory AdhanDate.fromJson(Map<String, dynamic> json) {
    return AdhanDate(
      readable: json['readable'],
      timestamp: json['timestamp'],
      gregorian: AdhanGregorian.fromJson(json['gregorian']),
      hijri: AdhanHijri.fromJson(json['hijri']),
    );
  }
}

class AdhanGregorian {
  final String date;
  final String format;
  final String day;
  final Map<String, dynamic> weekday;
  final Map<String, dynamic> month;
  final String year;
  final Map<String, dynamic> designation;

  AdhanGregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  factory AdhanGregorian.fromJson(Map<String, dynamic> json) {
    return AdhanGregorian(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: Map<String, dynamic>.from(json['weekday']),
      month: Map<String, dynamic>.from(json['month']),
      year: json['year'],
      designation: Map<String, dynamic>.from(json['designation']),
    );
  }
}

class AdhanHijri {
  final String date;
  final String format;
  final String day;
  final Map<String, dynamic> weekday;
  final Map<String, dynamic> month;
  final String year;
  final Map<String, dynamic> designation;

  AdhanHijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  factory AdhanHijri.fromJson(Map<String, dynamic> json) {
    return AdhanHijri(
      date: json['date'],
      format: json['format'],
      day: json['day'],
      weekday: Map<String, dynamic>.from(json['weekday']),
      month: Map<String, dynamic>.from(json['month']),
      year: json['year'],
      designation: Map<String, dynamic>.from(json['designation']),
    );
  }
}

class AdhanMeta {
  final double latitude;
  final double longitude;
  final String timezone;
  final AdhanMethod method;

  AdhanMeta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
  });

  factory AdhanMeta.fromJson(Map<String, dynamic> json) {
    return AdhanMeta(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezone: json['timezone'],
      method: AdhanMethod.fromJson(json['method']),
    );
  }
}

class AdhanMethod {
  final int id;
  final String name;
  final Map<String, int> params;
  final Map<String, double> location;

  AdhanMethod({
    required this.id,
    required this.name,
    required this.params,
    required this.location,
  });

  factory AdhanMethod.fromJson(Map<String, dynamic> json) {
    return AdhanMethod(
      id: json['id'],
      name: json['name'],
      params: Map<String, int>.from(json['params']),
      location: Map<String, double>.from(json['location']),
    );
  }
}
