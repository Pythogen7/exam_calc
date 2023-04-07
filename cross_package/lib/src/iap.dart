
import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:cross_package/cross_package.dart';
import 'package:flutter/material.dart';

class InAppAdapty {

  static AdaptyProfile? recentProfile;

  static StreamController<AdaptyProfile> profileChange = StreamController.broadcast();



  static Map<String, bool> getLocalStorageAccessLevels() {
    return Map.from(LocalStorage.get("InAppAdapty.profile") ?? {}).cast();
  }

  static Future saveLocalStorageAccessLevels(Map<String, AdaptyAccessLevel> val) {
    return LocalStorage.put("InAppAdapty.profile", Map.from(val.map((key, value) => MapEntry(key, value?.isActive))));
  }


  static Future init() async {

    profileChange.stream.listen((event) {
      saveLocalStorageAccessLevels(event.accessLevels);
    });

    Adapty().activate();
    Future<AdaptyProfile?> pr = Adapty().restorePurchases();
    pr.then((value) {
      recentProfile = value;
      if (value!=null) profileChange.add(value);
    });
    return pr;
  }

  static bool accessGranted(String accessLevel) {

    if (recentProfile==null) {
      return getLocalStorageAccessLevels()[accessLevel] ?? false;
    }

    return recentProfile?.accessLevels[accessLevel]?.isActive ?? false;
  }

  static Future purchase(String payWallId) async {
    List<AdaptyPaywallProduct> p = (await Adapty().getPaywallProducts(
        paywall: await Adapty().getPaywall(id: payWallId)));
    if (p.isEmpty) {
      return false;
    }
    AdaptyProfile? pr = await Adapty().makePurchase(product: p.first);
    if (pr!=null) {
      recentProfile = pr;
      profileChange.add(pr);
    }

    if (recentProfile==null) {
      refreshProfile();
    }


  }

  static Future<AdaptyProfile> refreshProfile() async {
    recentProfile = await Adapty().getProfile();
    profileChange.add(recentProfile!);
    return recentProfile!;
  }
}


class InAppPurchaseBuilder extends StatefulWidget {

  final WidgetBuilder onUpdate;
  const InAppPurchaseBuilder(this.onUpdate, {Key? key}) : super(key: key);

  @override
  State<InAppPurchaseBuilder> createState() => _InAppPurchaseBuilderState();
}

class _InAppPurchaseBuilderState extends State<InAppPurchaseBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: (a,b)=>widget.onUpdate(a), stream: InAppAdapty.profileChange.stream);
  }
}

class InAppAccessLevelChanger extends StatefulWidget {

  final Function(BuildContext, bool) onUpdate;
  final String accessLevel;

  const InAppAccessLevelChanger(this.accessLevel, this.onUpdate, {Key? key}) : super(key: key);

  @override
  State<InAppAccessLevelChanger> createState() => _InAppAccessLevelChangerState();
}

class _InAppAccessLevelChangerState extends State<InAppAccessLevelChanger> {
  @override
  Widget build(BuildContext context) {
    return InAppPurchaseBuilder((context) {
      return widget.onUpdate(context, InAppAdapty.accessGranted(widget.accessLevel));
    });
  }
}

