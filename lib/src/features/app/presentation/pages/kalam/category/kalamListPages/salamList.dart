import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../domain/salam/salamDomain.dart';
import '../../../../../domain/salam/salam_repository.dart';
import '../../../../../utils/colors.dart';
import '../../kalam_view_screen.dart';

class SalamList extends StatefulWidget {
  const SalamList({super.key});

  @override
  State<SalamList> createState() => _SalamListState();
}

class _SalamListState extends State<SalamList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    List<Salam> salamlist = [];
    Future<List<Salam>> getData() async {
      salamlist = await SalamRepositoryImpl(context).getAllSalams();
      if (salamlist.hashCode != Null) {
        return salamlist;
      }
      return salamlist;
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
                    itemCount: salamlist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => KalamScreen(
                                salamlist[index].type.toString(),
                                salamlist[index].subject.toString(),
                                salamlist[index].poet.toString(),
                                salamlist[index].lines,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showPopupMenu(context, salamlist[index]);
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
                                      salamlist[index].lines.first,
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
                                      salamlist[index].poet,
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

  void _showPopupMenu(BuildContext context, Salam salam) {
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
                    _downloadSalam(salam);
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
  Future<void> _downloadSalam(Salam salam) async {
    // Request storage permissions
    if (await Permission.storage.request().isGranted) {
      // Get the directory to save the file
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/${salam.lines.first}.txt');

      // Write the Hamd text to the file
      await file.writeAsString(salam.lines.join('\n'));

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${salam.lines.first} has been downloaded'),
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
