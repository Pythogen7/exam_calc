import 'package:easytext/easytext.dart';
import 'package:exam_calc/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CourseEditor extends StatefulWidget {
  final Course course;

  const CourseEditor(this.course, {Key? key}) : super(key: key);

  @override
  State<CourseEditor> createState() => _CourseEditorState();
}

class _CourseEditorState extends State<CourseEditor> {
  late TextEditingController courseName, currentGrade, examWeight, gradeDesired;

  @override
  void initState() {
    super.initState();
    courseName = TextEditingController(text: widget.course.name);
    currentGrade = TextEditingController(
        text: widget.course.currentGrade == double.negativeInfinity
            ? ""
            : "${widget.course.currentGrade}");
    examWeight = TextEditingController(
        text: widget.course.examWeight == double.negativeInfinity
            ? ""
            : "${widget.course.examWeight}");
    gradeDesired = TextEditingController(
        text: widget.course.gradeDesired == double.negativeInfinity
            ? ""
            : "${widget.course.gradeDesired}");

    courseName.addListener(() {
      if (widget.course.currentGrade != double.negativeInfinity) {
        widget.course.name = courseName.text;
      }
    });
  }


  Widget Button(String txt, Function() onTap) =>
      TextButton(onPressed: onTap, child: Txt(txt));

  Widget card(String question, bool visible, TextEditingController c,
      String hint, String followText, String okText, bool showButton,
      void Function() okButton) {
    return AnimatedOpacity(
      duration: 300.milliseconds,
      opacity: visible ? 1 : 0,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey, width: .3)),

        child: Column(
          children: <Widget>[
            Txt(question),
            Row(children: [
              Expanded(child: Row(children: [
                Expanded(child: TextField(
                  controller: c, decoration: InputDecoration(hintText: hint),)),
                Txt(followText),
              ],)),
              if (showButton) Button(okText, okButton),


            ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double? gN = widget.course.allValuesSet ? widget.course.gradeNeeded : null;

    return SingleChildScrollView(child: Column(
      children: <Widget>[
        card(
            "What is the name of the Course?",
            true,
            courseName,
            "Course Name",
            "",
            "Next",
            widget.course.name.isEmpty, () {
          widget.course.name = courseName.text;
          print(widget.course.name + " hello");
          setState(() {

          });
        }),
        card(
            "What is your current grade in the Course?",
            widget.course.name.isNotEmpty,
            currentGrade,
            "Current Grade",
            "",
            "Next",
            widget.course.currentGrade == double.negativeInfinity, () {
          double? grade = double.tryParse(currentGrade.text);
          if (grade != null && grade >= 0 && grade <= 100) {
            widget.course.currentGrade = grade;
            setState(() {

            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Txt("Invalid Input")));
          }
        }),
        card(
            "How much of your grade is the exam worth?",
            widget.course.currentGrade != double.negativeInfinity,
            examWeight,
            "Exam Weight",
            "%",
            "Next",
            widget.course.examWeight == double.negativeInfinity, () {
          double? grade = double.tryParse(currentGrade.text);
          if (grade != null && grade >= 0 && grade <= 100) {
            widget.course.examWeight = grade;
            setState(() {

            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Txt("Invalid Input")));
          }
        }),
        card(
            "What grade do you want overall?",
            widget.course.examWeight != double.negativeInfinity,
            gradeDesired,
            "Grade Desired",
            "",
            "Calculate",
            widget.course.gradeDesired == double.negativeInfinity, calculate),
        if (gN != null) Container(padding: EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: 250),
          child: ClipOval(child: AspectRatio(aspectRatio: 1, child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Flexible(child: Container(color: Colors.grey[300],),
                      flex: 100 - gN.toInt()),
                  Flexible(child: Container(color: widget.course.color),
                      flex: gN.toInt()),

                ],
              ),
              Center(child: Txt(widget.course.allValuesSet ? "${(widget.course
                  .gradeNeeded).round()}%" : "N/A")),

            ],
          ),


          )),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: calculate, child: Txt("Recalculate")),
            TextButton(onPressed: Get.back, child: Txt("Menu")),
          ],
        )
      ],
    ),);
  }

  void calculate() {
    double? grade = double.tryParse(currentGrade.text);
    bool invalid = false;
    if (grade != null && grade >= 0 && grade <= 100) {
      widget.course.currentGrade = grade;
    } else {
      invalid = true;
    }

    grade = double.tryParse(gradeDesired.text);
    if (grade != null && grade >= 0 && grade <= 100) {
      widget.course.gradeDesired = grade;
    } else {
      invalid = true;
    }

    grade = double.tryParse(examWeight.text);
    if (grade != null && grade >= 0 && grade <= 100) {
      widget.course.examWeight = grade;
    } else {
      invalid = true;
    }


    setState(() {

    });
    if (invalid) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Txt("Invalid Input")));
    }
  }

}