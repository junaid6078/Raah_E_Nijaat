import 'package:flutter/material.dart';
import 'package:raah_e_nijaat/src/features/app/presentation/pages/kalam/widget/kalam_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colors.dart';
import '../../home_screen/presentation/widget/reuseable/BackgroundImage.dart';

class KalamScreen extends StatefulWidget {
  final String type;
  final String subject;
  final String poet;
  final List<String> lines;

  const KalamScreen(this.type, this.subject, this.poet, this.lines,
      {super.key});

  @override
  State<KalamScreen> createState() => _KalamScreenState();
}

class _KalamScreenState extends State<KalamScreen> {
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 18.0;
    });
  }

  Future<void> _setFontSize(double value, StateSetter setModalState) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = value;
    });
    setModalState(() {
      _fontSize = value;
    });
    prefs.setDouble('fontSize', value);
  }

  void _openBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: size.height * 0.4,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Font size", style: TextStyle(color: blueColor),),
                  Row(
                    children: [
                      const Icon(Icons.font_download, size: 18),
                      Expanded(
                        child: Slider(
                          activeColor: yellowColor,
                          value: _fontSize,
                          min: 10,
                          max: 30,
                          divisions: 20,
                          label: _fontSize.round().toString(),
                          onChanged: (double value) {
                            _setFontSize(value, setModalState);
                          },
                        ),
                      ),
                      const Icon(Icons.font_download),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          // Positioned.fill(
          //   child: Image.asset('assets/images/kalambg.png'),
          // ),
          // Content
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                scrolledUnderElevation: 0,
                centerTitle: true,
                floating: true,
                snap: true,
                backgroundColor: whiteColor,
                leading: BackButton(color: blueColor),
                title: Text(
                  widget.subject,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: blueColor,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      _openBottomSheet(context);
                    },
                  ),
                ],
                bottom: PreferredSize(
                    preferredSize: Size.square(20),
                    child: Text(
                      widget.poet,
                      style: TextStyle(color: lightBlue),
                    )),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 2, 24, 2),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.lines.length,
                    itemBuilder: (context, position) {
                      return _buildLineContainer(position);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineContainer(int position) {
    String line = widget.lines[position];
    return KalamLine(
      height: MediaQuery.of(context).size.height * 0.05,
      text: line,
      color: Colors.transparent,
      fontSize: _fontSize,
    );
  }
}
