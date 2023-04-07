library cross_package;


import 'dart:io';
import 'package:applovin_max/applovin_max.dart';
import 'package:cross_package/src/local_storage.dart';
import 'package:flutter/foundation.dart';

import 'cross_package.dart';

export 'src/icon_background.dart';
export 'src/standard_menu.dart';
export 'src/ui_elements.dart';
export 'src/dialogs.dart';
export 'src/local_storage.dart';
export 'src/ads.dart';
export 'src/iap.dart';


class CrossPackage {
  static Future<void> init({bool ads=false, bool inAppPurchases=false}) async {
    if (ads && !kIsWeb && (Platform.isAndroid || Platform.isIOS)) AppLovinMAX.initialize("skheqZGTq0oBFL3TVO8Iv09_VdRKgquTCkSWiAz_LW3RSHz7oHTyExToaM5fLaGdEs1VIDasXEkVCykwWgG5_w");


    return LocalStorage.initialize().then((v) {
      if (inAppPurchases) InAppAdapty.init();
    });

  }
}