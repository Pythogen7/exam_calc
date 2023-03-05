import 'package:easytext/txt.dart';
import 'package:exam_calc/course.dart';
import 'package:exam_calc/course_edit.dart';
import 'package:exam_calc/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: GoogleFonts.mandaliTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:
     Column(
        children: <Widget>[
          if (Prefs.courses.isEmpty) Expanded(child: Center(child: Txt("Press '+' to add a Course", scaleFactor: 1.5,))),
          ... List.generate(Prefs.courses.length, (index) => InkWell(
              onTap: ()=>Get.to(()=>Scaffold(body: CourseEditor(Prefs.courses[index]))),
              child:
              CourseWidget(Prefs.courses[index])

          ))


        ],
      ),

     floatingActionButton: FloatingActionButton(
        onPressed: () {
          Course c = Course.blank();
          c = Course("James Shelley", Colors.red.value, 60, .5, 36);

          Prefs.courses.add(c);

          setState(() {

          });
        },
        tooltip: 'Add Course',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
