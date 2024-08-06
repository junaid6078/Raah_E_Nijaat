import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../domain/manqabat/manqabarDomain.dart';
import '../../../../../domain/manqabat/manqabat_repository.dart';
import '../../../../../utils/colors.dart';
import '../../kalam_view_screen.dart';

class ManqabatList extends StatefulWidget {
  const ManqabatList({super.key});

  @override
  State<ManqabatList> createState() => _ManqabatListState();
}

class _ManqabatListState extends State<ManqabatList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    List<Manqabat> manqabatlist = [];
    Future<List<Manqabat>> getData() async {
      manqabatlist = await ManqabatRepositoryImpl(context).getAllManqabats();
      if (manqabatlist.hashCode != Null) {
        return manqabatlist;
      }
      return manqabatlist;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            //BackgroundImage(file: 'assets/images/homebg.jpg'),
            FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: manqabatlist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => KalamScreen(
                                manqabatlist[index].type.toString(),
                                manqabatlist[index].subject.toString(),
                                manqabatlist[index].poet.toString(),
                                manqabatlist[index].lines,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showPopupMenu(context, manqabatlist[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          //padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          height: height * 0.08,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: yellowColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      manqabatlist[index].lines.first,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: blueColor,
                                        //fontSize: size.width * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AutoSizeText(
                                      manqabatlist[index].poet,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: lightBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/numberPlaceholder.png',
                                        scale: width * 0.035,
                                      ),
                                      AutoSizeText(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                          color: yellowColor,
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Manqabat manqabat) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.25,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Download'),
                  onTap: () {
                    _downloadManqabat(manqabat);
                    Navigator.pop(context);
                    // Handle delete action here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle share action here
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _downloadManqabat(Manqabat manqabat) async {
    // Request storage permissions
    if (await Permission.storage.request().isGranted) {
      // Get the directory to save the file
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/${manqabat.lines.first}.txt');

      // Write the Hamd text to the file
      await file.writeAsString(manqabat.lines.join('\n'));

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${manqabat.lines.first} has been downloaded'),
        ),
      );
    } else {
      // Show an error message if permissions are not granted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to download files'),
        ),
      );
    }
  }
}
