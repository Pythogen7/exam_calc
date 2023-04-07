
import 'dart:math';

import 'package:easytext/easytext.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


import 'package:json_annotation/json_annotation.dart';
import 'package:random_color/random_color.dart';

import 'main.dart';

part 'course.g.dart';
@JsonSerializable()
class Course {
  String name;
  int colorInt;

  double currentGrade;
  double examWeight;
  double gradeDesired;


  Course(this.name, this.colorInt, this.currentGrade, this.examWeight,
      this.gradeDesired);

  factory Course.blank() {
    return Course("", RandomColor().randomColor().value, negativeInfinity, negativeInfinity, negativeInfinity);
  }


  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);




}

extension course_tools on Course {
  Color get color  => Color(colorInt);

  set color(Color color) => colorInt = color.value;

  bool get allValuesSet => currentGrade!=negativeInfinity && gradeDesired!=negativeInfinity && examWeight!=negativeInfinity;

  bool get isPossible => gradeNeeded>100;
  bool get anyGrade =>gradeNeeded<=0;
  double get gradeNeeded => !allValuesSet ? 100 : max(0, (gradeDesired-currentGrade)/(.01*examWeight)+currentGrade);
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
      aspectRatio: 3.25,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
            color: Theme.of(context).canvasColor,

            border: Border.all(color: Colors.grey, width: .5)),
        child: Row(children: [
          Expanded(child: Align(alignment: Alignment.centerLeft, child: Txt.b(widget.course.name, scaleFactor: 1.4,))),
          CircleProg(widget.course)

        ],),

      ),
    );
  }
}



