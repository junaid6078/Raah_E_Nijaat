import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DailyStoryController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (page != currentPage.value) {
        currentPage.value = page;
      }
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
