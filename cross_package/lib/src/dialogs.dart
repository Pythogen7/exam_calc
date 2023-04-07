


import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:easytext/easytext.dart';
import 'package:flutter/material.dart';


Future<T> showSimpleChoiceChipDialog<T>(BuildContext context, List<T> items, {String Function(T)? asString, T? initialValue, String? title}) async {

Completer<T> c = Completer();
  showDialog(context: context, builder: (b) {
    return SimpleDialog(
      title: title==null? null : Txt.b(title, scaleFactor: 1.4,),
        children: [ChipsChoice.single(value: initialValue,
            onChanged: (a) {c.complete(a); Navigator.pop(context);},
            wrapped: true,
            choiceItems: items.map((e) => C2Choice(value: e, label: asString?.call(e) ?? e.toString()))
                .toList(),
            choiceStyle: C2ChipStyle.toned()),]
    );

  });

  return c.future;
}