import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:raah_e_nijaat/src/features/app/navigator/navigator.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';
import '../../../../create_account/presentation/sign_in/sign_in.dart';
import '../../home_screen/presentation/home_view.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  late final GifController controller1, controller2, controller3;
  int _fps = 30;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    controller3 = GifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _appBar(),
            if (userId != null) AccountMenu(userId: userId),
            if (userId == null)
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  height: size.height * 0.2,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: yellowColor),
                    borderRadius: BorderRadius.circular(16),
                    color: blueColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        height: size.height * 0.15,
                        width: size.width * 0.3,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: yellowColor),
                        //   borderRadius: BorderRadius.circular(16),
                        //   color: blueColor,
                        // ),
                        child: Gif(
                          autostart: Autostart.loop,
                          placeholder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                          image: const AssetImage(
                              'assets/images/logo_animated.gif'),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(32, 32, 16, 8),
                            child: Text(
                              'Please Sign in',
                              style:
                                  TextStyle(color: yellowColor, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(32, 32, 16, 8),
                            child: ElevatedButton(
                              onPressed: () {
                                AppNavigator.toSignIn(context);
                              },
                              child: Text("Sign in"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            _buildMenuItem(context, Icons.settings, 'Settings'),
            _buildMenuItem(
              context,
              Icons.feedback_rounded,
              'Support',
              onTap: () {
                _showDialog(context);
              },
            ),
            (userId != null)
                ? _buildMenuItem(
                    context,
                    Icons.logout,
                    'Sign out',
                    onTap: () async {
                      try {
                        if (userId != null) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomeView()),
                          );
                        }
                      } catch (e) {
                        print('Error signing out: $e');
                        // Optionally, show an error message to the user
                      }
                    },
                  )
                : _buildMenuItem(
                    context,
                    Icons.login,
                    'Sign in',
                    onTap: () async {
                      try {
                        if (userId == null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        }
                      } catch (e) {
                        print('Error signing out: $e');
                        // Optionally, show an error message to the user
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    final size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: whiteColor,
      title: Text(
        "Account",
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: blueColor,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: blueColor,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogContent();
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent();
      },
    );
  }
}

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter your details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            if (_currentUser == null)
              TextField(
                maxLength: 50,
                maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _sendMessage();
          },
          child: Text('Send'),
        ),
      ],
    );
  }

  void _sendMessage() async {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    final email = _emailController.text.trim();

    if (name.isNotEmpty && message.isNotEmpty) {
      // If the user is not logged in, ensure the email is provided
      if (_currentUser == null && email.isEmpty) {
        // Show an error message or inform the user to provide an email
        print('Email is required if not logged in');
        return;
      }

      final String uid = _currentUser?.uid ?? 'anonymous';
      final String userEmail = _currentUser?.email ?? email;

      try {
        await _messagesCollection.add({
          'uid': uid,
          'name': name,
          'email': userEmail,
          'text': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print('Message sent: $message');
        }
        _nameController.clear();
        _messageController.clear();
        _emailController.clear();
        Navigator.of(context).pop(); // Close the dialog
      } catch (e) {
        if (kDebugMode) {
          print('Error sending message: $e');
        }
        // Optionally, show an error message to the user
      }
    } else {
      // Optionally, show a message or an error to the user
      print('Name and message are required');
    }
  }
}

class BottomSheetContent extends StatefulWidget {
  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              selectionHeightStyle: BoxHeightStyle.max,
              maxLength: 500,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _sendMessage();
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty) {
      // Handle sending the message
      print('Message: $message');
      _controller.clear();
      Navigator.pop(context); // Close the bottom sheet
    } else {
      // Optionally, show a message or an error to the user
      print('No message entered');
    }
  }
}

class AccountMenu extends StatelessWidget {
  final String userId;
  AccountMenu({super.key, required this.userId});

  Future<Map<String, dynamic>> _getUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>? ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
            height: size.height * 0.2,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: yellowColor),
              borderRadius: BorderRadius.circular(16),
              color: blueColor,
            ),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                } else {
                  final userData = snapshot.data!;
                  final name = userData['name'] ?? 'No name';
                  final email = userData['email'] ?? 'No email';
                  return Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        height: size.height * 0.15,
                        width: size.width * 0.3,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: yellowColor),
                        //   borderRadius: BorderRadius.circular(16),
                        //   color: blueColor,
                        // ),
                        child: Gif(
                          autostart: Autostart.loop,
                          placeholder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                          image: const AssetImage(
                              'assets/images/logo_animated.gif'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(32, 32, 16, 8),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: yellowColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(32, 16, 16, 8),
                            child: Text(
                              email,
                              style: TextStyle(
                                color: lightBlue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
