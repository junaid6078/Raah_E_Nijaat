import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/controller/location/location_service.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String _currentAddress = "Loading your location...";

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    String address = await LocationService().getCurrentLocation();
    setState(() {
      _currentAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: Icon(
                Icons.location_pin,
                size: 60,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Text(
                  'Your Location',
                  style: TextStyle(
                    fontSize: 16,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: IconButton(
                  onPressed: () async {
                    // Clear saved location and fetch the current one
                    await LocationService().clearSavedLocation();
                    String address =
                    await LocationService().getCurrentLocation();
                    setState(() {
                      _currentAddress = address;
                    });
                  },
                  icon: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              _currentAddress,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('Location'),
    );
  }
}
