
import 'package:easytext/easytext.dart';
import 'package:flutter/material.dart';

class Course {
  String name;
  int colorInt;

  double currentGrade;
  double examWeight;
  double gradeDesired;


  Course(this.name, this.colorInt, this.currentGrade, this.examWeight,
      this.gradeDesired);

  factory Course.blank() {
    return Course("", Colors.grey.value, double.negativeInfinity, double.negativeInfinity, double.negativeInfinity);
  }

  Color get color  => Color(colorInt);

  set color(Color color) => colorInt = color.value;

  bool get allValuesSet => currentGrade!=double.negativeInfinity && gradeDesired!=double.negativeInfinity && examWeight!=double.negativeInfinity;

  bool get isPossible => gradeNeeded>100;
  bool get anyGrade =>gradeNeeded<=0;
  double get gradeNeeded => !allValuesSet ? 100 : (currentGrade-currentGrade*examWeight-gradeDesired)/(-1*examWeight);

}


class CourseWidget extends StatefulWidget {
  final Course course;

  const CourseWidget(this.course, {Key? key}) : super(key: key);

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  Widget build(BuildContext context) {
    double gN = widget.course.allValuesSet ? widget.course.gradeNeeded : 100;
    return AspectRatio(
      aspectRatio: 3,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey, width: .3)),
        child: Row(children: [
          Expanded(child: Align(alignment: Alignment.centerLeft, child: Txt.b(widget.course.name, scaleFactor: 1.4,))),
          ClipOval(child: AspectRatio(aspectRatio: 1, child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Flexible(child: Container(color: Colors.grey[300],), flex: 100-gN.toInt()),
                  Flexible(child: Container(color: widget.course.color), flex: gN.toInt()),

                ],
              ),
              Center(child: Txt(widget.course.allValuesSet ? "${(widget.course.gradeNeeded).round()}%" : "N/A")),

            ],
          ),
              ))

        ],),

      ),
    );
  }
}



