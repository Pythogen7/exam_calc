
import 'dart:async';

import 'package:cross_package/cross_package.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppAdapty {




  static Set<String> purchasedIds = {};
  static late ProductDetailsResponse products;


  static Set<String> getLocalStorageAccessLevels() {
    return Set.from(LocalStorage.get("IAP.Ids") ?? {}).cast();
  }

  static Future saveLocalStorageAccessLevels(Set<String> val) {
    return LocalStorage.put("IAP.Ids", val.toList());
  }


  static Future init(Set<String> productIds) async {

    products  = await InAppPurchase.instance.queryProductDetails(productIds);

    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      for (var d in purchaseDetailsList) {
        if (d.status == PurchaseStatus.purchased || d.status == PurchaseStatus.restored) {
          purchasedIds.add(d.productID);
        } else if (d.status == PurchaseStatus.error) {
          d.error?.printError();
        }
      }

      saveLocalStorageAccessLevels(purchasedIds);


    });


    await InAppPurchase.instance.restorePurchases();


  }

  static bool accessGranted(String productId) {
    return getLocalStorageAccessLevels().contains(productId) ?? false;
  }

  static Future purchase(String productId) async {
    for (ProductDetails p in products.productDetails) {
      if(p.id==productId) {


        await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: p));
      }
    }



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
    return StreamBuilder(builder: (a,b)=>widget.onUpdate(a), stream: InAppPurchase.instance.purchaseStream);
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

