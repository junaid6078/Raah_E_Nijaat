import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:raah_e_nijaat/src/features/app/utils/colors.dart';
import '../../../../controller/feedback/feedback_controller.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key? key}) : super(key: key);

  final FeedbackController _controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'We’d love to hear your thoughts! Please let us know how we can improve your experience with our app',
                      style: TextStyle(
                        fontSize: 16,
                        color: blueColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLength: 50,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.truncateAfterCompositionEnds,
                    controller: _controller.nameController,
                    decoration: InputDecoration(

                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    maxLength: 500,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.truncateAfterCompositionEnds,
                    controller: _controller.messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines:
                        10, // Increase the number of lines for the message field
                    minLines: 5, // Set a minimum height for the message field
                  ),
                  TextField(
                    controller: _controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _controller.sendMessage,
                        child: Text('Send Feedback'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _controller.clearFields(); // Clear all fields
                          Navigator.of(context).pop(); // Close the page
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_controller.isSending.value)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('Feedback'),
    );
  }
}
