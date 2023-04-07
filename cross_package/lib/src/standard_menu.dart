import 'package:easytext/txt.dart';
import 'package:flutter/material.dart';

import '../cross_package.dart';





class StartMenu extends StatelessWidget {
  
  final Widget topTxt;
  final List<Widget> choices;
  const StartMenu(this.topTxt, this.choices, {Key? key}) : super(key: key);
  
  factory StartMenu.simple(String topText, Map<String, void Function()> choices) {
    return StartMenu(Header(topText, scaleFactor: 2,),
        choices.keys.map((e) =>
            InkWell(onTap: choices[e]?.call,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Txt(e, scaleFactor: 1.6),
                ))).toList()
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
        topTxt,
        ...choices
      ],),
    );
  }
}
