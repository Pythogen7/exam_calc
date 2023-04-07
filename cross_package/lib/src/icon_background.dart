

import 'dart:math';

import 'package:flutter/material.dart';

class IconBackground extends StatefulWidget  {
  final bool animated;
  final List<IconData> icons;
  final Duration speed;
  final double scaleFactor;
  final double padding;
  final Axis direction;
  final Color? color;
  final int repeatInterval;



  const IconBackground({required this.icons, this.padding=8, this.direction=Axis.horizontal, this.animated=true, this.scaleFactor=1, this.speed = const Duration(seconds: 5), this.color, Key? key, this.repeatInterval=9}) : super(key: key);

  @override
  State<IconBackground> createState() => _IconBackgroundState();
}

class _IconBackgroundState extends State<IconBackground> with SingleTickerProviderStateMixin {
  double get size => widget.scaleFactor*24;
  double get sizeWithPadding => size+widget.padding*2;
  late AnimationController controller;
  ScrollController scrollController = ScrollController();

  int completedLoops = 0;
  Widget? _mainWidget;

  int verticalCount = 0;
  int horizontalCount = 0;

  Widget iconAt(int index, BuildContext context) => Padding(
    padding: EdgeInsets.all(widget.padding),
    child: Icon(widget.icons[index % widget.icons.length], size: size, color: widget.color ?? Theme.of(context).primaryColor,),
  );

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.speed*widget.repeatInterval);
    controller.repeat();
    controller.addStatusListener((status) {
      if (status==AnimationStatus.completed) {


      }
    });
    controller.addListener(() {
      if (scrollController.positions.isNotEmpty) scrollController.animateTo(controller.value * sizeWithPadding * widget.repeatInterval, duration: const Duration(microseconds: 1), curve: Curves.linear);



    });





  }


  Random r = Random();
  List<int> prev = [];
  int nextInt(int max) {
    int i = r.nextInt(max);
    if (!prev.contains(i)) {
      int hold = max~/3;
      prev.add(i);
      if (prev.length>hold) {
        prev.removeAt(0);
      }
      return i;
    } else {
      return nextInt(max);
    }


  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int nverticalCount = (constraints.biggest.height / sizeWithPadding).ceil();
      int nhorizontalCount = (constraints.biggest.width / sizeWithPadding).ceil();




      if (verticalCount != nverticalCount ||
          horizontalCount != nhorizontalCount) {
        horizontalCount = nhorizontalCount;
        verticalCount = nverticalCount;
        _mainWidget = Stack(
          clipBehavior: Clip.hardEdge,
            children: [SizedBox(
              height: constraints.maxHeight,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(verticalCount, (vIndex) {
                return Expanded(
                  child: Row(children: List.generate(
                      horizontalCount + widget.repeatInterval, (hIndex) {
                    return iconAt(nextInt(widget.icons.length), context);
                  })),
                );
              })),
            )
            ]);
      }


      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: widget.direction,
        physics: const NeverScrollableScrollPhysics(),
        child: _mainWidget,

      );
    });
  }
}


