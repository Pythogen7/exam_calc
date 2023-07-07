import 'dart:math';

import 'package:cross_package/cross_package.dart';
import 'package:easytext/easytext.dart';
import 'package:examscore/course.dart';
import 'package:examscore/preferences.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'main.dart';

class CourseEditor extends StatefulWidget {
  final Course course;
  final Function(Course) deleteCourse;


  const CourseEditor(this.course, this.deleteCourse, {Key? key}) : super(key: key);

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
        text: widget.course.currentGrade == negativeInfinity
            ? ""
            : "${widget.course.currentGrade}");
    examWeight = TextEditingController(
        text: widget.course.examWeight == negativeInfinity
            ? ""
            : "${widget.course.examWeight}");
    gradeDesired = TextEditingController(
        text: widget.course.gradeDesired == negativeInfinity
            ? ""
            : "${widget.course.gradeDesired}");

    courseName.addListener(() {
      if (widget.course.currentGrade != negativeInfinity) {
        widget.course.name = courseName.text;
      }
    });
  }


  Widget Button(String txt, Function() onTap) =>
      TextButton(onPressed: onTap, child: Txt(txt));


  String hasFocus = "";
  Map<TextEditingController, FocusNode> focusNodes = {};
  Widget card(String question, bool visible, TextEditingController c,
      String hint, String followText, String okText, bool showButton,
      void Function() okButton, bool requestFocus, TextInputType inputType) {



    bool givingFocusNow = false;
    if (focusNodes[c]==null) {
      focusNodes[c] = FocusNode();
    }

    FocusNode fn = focusNodes[c]!;
    if (requestFocus && visible && c.text.isEmpty && hasFocus!=question) {
      FocusScope.of(context).requestFocus(fn);
      hasFocus = question;
      givingFocusNow = true;
    }

    return AnimatedOpacity(
      duration: 300.milliseconds,
      opacity: visible ? 1 : 0,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey, width: .5)),

        child: Column(
          children: <Widget>[
            Txt(question),
            Row(children: [
              Expanded(child: Row(children: [
                Expanded(child: TextField( focusNode: fn,
                  keyboardType: inputType,
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

    Future.microtask(() {
      Prefs.save();
    });


    return Scaffold(body: SafeArea(child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Header("Course Editor", backButton: Get.back)),
                  IconButton(onPressed: () async {
                    widget.course.color = await showColorPickerDialog(context, widget.course.color);
                    setState(() {

                    });
                  }, icon: Icon(Icons.circle, size: 36, color: widget.course.color),),
                  SizedBox(width: 12,)

                ],
              ),
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
              }, widget.course.name.isEmpty, TextInputType.text),
              card(
                  "What is your current grade in the Course?",
                  widget.course.name.isNotEmpty,
                  currentGrade,
                  "Current Grade",
                  "",
                  "Next",
                  widget.course.currentGrade == negativeInfinity, () {
                double? grade = double.tryParse(currentGrade.text);
                if (grade != null && grade >= 0 && grade <= 100) {
                  widget.course.currentGrade = grade;
                  setState(() {

                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Txt("Invalid Input")));
                }
              }, widget.course.currentGrade == negativeInfinity, TextInputType.number),
              card(
                  "How much of your grade is the exam worth?",
                  widget.course.currentGrade != negativeInfinity,
                  examWeight,
                  "Exam Weight",
                  "%",
                  "Next",
                  widget.course.examWeight == negativeInfinity, () {
                double? grade = double.tryParse(currentGrade.text);
                if (grade != null && grade >= 0 && grade <= 100) {
                  widget.course.examWeight = grade;
                  setState(() {

                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Txt("Invalid Input")));
                }
              }, widget.course.examWeight == negativeInfinity, TextInputType.number),
              card(
                  "What grade do you want overall?",
                  widget.course.examWeight != negativeInfinity,
                  gradeDesired,
                  "Grade Desired",
                  "",
                  "Calculate",
                  widget.course.gradeDesired == negativeInfinity, calculate, gN==null, TextInputType.number),
              if (gN!=null && EasyAds.hasAds) Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: EasyAds.banner('01e45e20874150b0', 'dc80f0c0f850b9ea'),
              ),
              if (gN!=null) Txt.b("You need to score a ${widget.course.gradeNeeded.round()}% on your exam.", scaleFactor: 1.2,),
              if (gN != null) Container(padding: EdgeInsets.all(24),
                  constraints: BoxConstraints(maxWidth: 250),
                  child: CircleProg(widget.course)),


            ],
          ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (gN!=null) TextButton(onPressed: Get.back, child: Txt("Menu")),
            if (gN!=null) TextButton(onPressed: calculate, child: Txt("Recalculate")),
            TextButton(onPressed: () {
              widget.deleteCourse(widget.course);
              Get.back();
            }, child: Txt("Delete")),
          ],
        )
      ],
    )));
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
    } else {
      FocusManager.instance.primaryFocus?.unfocus();

    }
  }

}