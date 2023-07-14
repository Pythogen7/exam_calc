
import 'dart:async';
import 'dart:io';

import 'package:cross_package/cross_package.dart';
import 'package:easytext/easytext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppAdapty {




  static Set<String> purchasedIds = {};
  static late ProductDetailsResponse products;
  static late List<IAPProd> productInit;


  static Set<String> getLocalStorageAccessLevels() {
    return Set.from(LocalStorage.get("IAP.Ids") ?? {}).cast();
  }

  static Future saveLocalStorageAccessLevels(Set<String> val) {
    return LocalStorage.put("IAP.Ids", val.toList());
  }


  static Future init(List<IAPProd> productInit) async {
    InAppAdapty.productInit = productInit;
    products = await InAppPurchase.instance.queryProductDetails(productInit.map((e) => e.correctId).toSet());

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


    if (Platform.isAndroid) await InAppPurchase.instance.restorePurchases(); //Android only, apple requires sign in for restore so we will put it somewhere else
  }


  static Future restorePurchases() => InAppPurchase.instance.restorePurchases();

  static bool accessGranted(String androidId) {
    return getLocalStorageAccessLevels().contains(androidId) ?? false;
  }

  static Future purchase(BuildContext context, String androidId) async {
    if (Platform.isAndroid) {
      //Standard Buy
      for (ProductDetails p in products.productDetails) {
        if(p.id==androidId) {
          await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: p));
        }
      }

    } else {
      //Find the IAP
      IAPProd prod = productInit.firstWhere((element) => element.idAndroid==androidId);

      //Its ios so we need to flow it differently
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Purchase ${prod.name} for ${prod.price}'),
                SizedBox(height: 24,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Txt("Already Own?", scaleFactor: .7),

                    InkWell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Txt(
                        "Restore Purchases", scaleFactor: .8, color: Theme
                          .of(context)
                          .primaryColor,),
                    ), onTap: () async {
                      var n = Navigator.of(dialogContext);
                      await restorePurchases();
                      n.pop();
                    })
                  ],
                )
              ],
            ),
            actions: <Widget>[
              Button(
                'Purchase',
                    () async {
                  for (ProductDetails p in products.productDetails) {
                    if (p.id == prod.correctId) {
                      var n = Navigator.of(dialogContext);
                      await InAppPurchase.instance.buyNonConsumable(
                          purchaseParam: PurchaseParam(productDetails: p));
                      n.pop(); // Dismiss alert dialog
                    }
                  }
                },
              ),
            ],
          );
        },
      );
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


class IAPProd {
  String name;
  String price;
  String idAndroid;
  String idIOS;

  IAPProd(this.name, this.price, this.idAndroid, [String? idIOS]) : this.idIOS = idIOS ?? idAndroid;

  String get correctId => Platform.isAndroid ? idAndroid : idIOS;
}