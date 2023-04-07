
import 'package:easytext/txt.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  final Function()? backButton;
  final double scaleFactor;
  const Header(this.text, {Key? key, this.backButton, this.scaleFactor=1.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        backButton!=null ? IconButton(onPressed: backButton,
            padding: const EdgeInsets.all(24), icon: const Icon(Icons.arrow_back)) : const SizedBox(width: 24,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Txt.b(text, scaleFactor: scaleFactor),
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double scaleFactor;

  const Button(this.text, this.onTap, {Key? key, this.scaleFactor=1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints(minWidth: 56*scaleFactor), decoration: BoxDecoration(color: onTap==null ? Colors.grey[400] : Theme
        .of(context)
        .primaryColor, borderRadius: BorderRadius.circular(56)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.0*scaleFactor, horizontal: 12*scaleFactor),
            child: Txt(text, color: Colors.white, scaleFactor: scaleFactor, align: TextAlign.center,),
          ),
        ));
  }
}