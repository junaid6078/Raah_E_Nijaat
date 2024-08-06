import 'dart:convert';
import 'package:flutter/widgets.dart';

class AdhanData {
  final List<Map<String, dynamic>> data;

  AdhanData({required this.data});

  factory AdhanData.fromJson(List<dynamic> json) {
    List<Map<String, dynamic>> dataList = json.map((item) => item as Map<String, dynamic>).toList();
    return AdhanData(data: dataList);
  }
}

abstract class AdhanRepository {
  Future<AdhanData> getAdhanData();
}

class AdhanRepositoryImpl implements AdhanRepository {
  final BuildContext _context;

  AdhanRepositoryImpl(this._context);

  @override
  Future<AdhanData> getAdhanData() async {
    final String jsonString = await _loadFromAsset();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final AdhanData adhanData = AdhanData.fromJson(jsonList);

    return adhanData;
  }

  Future<String> _loadFromAsset() async {
    return await DefaultAssetBundle.of(_context).loadString("assets/adhanTimes/august24.json");
  }
}
