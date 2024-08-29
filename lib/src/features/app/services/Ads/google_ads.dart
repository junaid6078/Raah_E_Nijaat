import 'dart:io';

class AdHelper{

  static String HomeBanner(){
    if (Platform.isAndroid){
      return "ca-app-pub-7002970755990501/9440994569";
    }
    else{
      return "";
    }
  }
  static String HomeCustomAd(){
    if (Platform.isAndroid){
      return "ca-app-pub-7002970755990501/2106032666";
    }
    else{
      return "";
    }
  }

}