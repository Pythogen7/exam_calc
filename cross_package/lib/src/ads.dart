
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:cross_package/cross_package.dart';
import 'package:easytext/txt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyAds {



  static bool Function() showAds = ()=>true;

  static void registerShowAdCheck(bool Function() showAd) => showAds=showAd;

  static void linkShowAdCheckToIAP([String adsAccessLevelId = "noads"]) => showAds = () {
    bool noAdsBought = InAppAdapty.accessGranted(adsAccessLevelId);
    return !noAdsBought;
  };

  static bool get hasAds => !kIsWeb && (Platform.isAndroid || Platform.isIOS) && showAds();

  static Widget banner([String? android, String? iOS]) {
    return !hasAds ? const SizedBox() : MaxAdView(adUnitId: Platform.isAndroid ? android! : iOS!, adFormat: AdFormat.banner);
  }

  static Widget mrec([String? android, String? iOS]) {
    return !hasAds ? const SizedBox() : MaxAdView(adUnitId: Platform.isAndroid ? android! : iOS!, adFormat: AdFormat.mrec);
  }

  static Widget mrecDecorated([String? android, String? iOS]) {
    return !hasAds ? const SizedBox() : Center(
        child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.grey[300]),
    margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(12), child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Padding(
    padding: EdgeInsets.only(left: 8.0, bottom: 8),
    child: Txt.b("Ad"),
    ),
      EasyAds.mrec(android, iOS),

    ],
    )));
  }



}