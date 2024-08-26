import 'package:prayers_times/prayers_times.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
class prayerTimes extends StatefulWidget {
  const prayerTimes({super.key});

  @override
  State<prayerTimes> createState() => _prayerTimesState();
}

class _prayerTimesState extends State<prayerTimes> {
  String _locationMessage = "Fetching location...";
  Coordinates coordinates = Coordinates(0,0);
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final permission = await Permission.locationWhenInUse.status;

    if (permission != PermissionStatus.granted) {
      final result = await Permission.locationWhenInUse.request();
      if (result != PermissionStatus.granted) {
        setState(() {
          _locationMessage = "Location permission denied";
        });
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        //coordinates = Coordinates(position.latitude, position.longitude);
        _locationMessage =
            'Location: ${position.latitude}, ${position.longitude}';
        print(_locationMessage);
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
        print(_locationMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // Specify the calculation parameters for prayer times
    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;

    // Create a PrayerTimes instance for the specified location

    return Scaffold();
  }
}
