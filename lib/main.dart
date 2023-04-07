import 'dart:io';
import 'dart:math';

import 'package:cross_package/cross_package.dart';
import 'package:easytext/txt.dart';
import 'package:examscore/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'course.dart';
import 'course_edit.dart';
import 'firebase_options.dart';



const double negativeInfinity = -10000000;

void main() async {
  bool isDesktop = Platform.isWindows|| Platform.isLinux;

  if (!kDebugMode && !isDesktop) {
    FlutterError.onError = (e) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(e);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
      return true;
    };
  }

  WidgetsFlutterBinding.ensureInitialized();
 await Future.wait([
    if (!isDesktop) Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    CrossPackage.init(ads: true, inAppPurchases: true)
  ]);

 EasyAds.linkShowAdCheckToIAP();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
          colorScheme: ColorScheme(
            primary: Colors.lightBlue,
            onPrimary: Colors.white,
            brightness: Brightness.light,
            secondary: Colors.lightBlue, onSecondary: Colors.black,
            error: Colors.redAccent[200]!,
            onError: Colors.black54, background: Colors.grey[50]!, onBackground: Colors.black, surface: Colors.lightBlue, onSurface: Colors.lightBlue,
          ),
          textTheme: GoogleFonts.workSansTextTheme(),


          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      darkTheme: ThemeData(
          colorScheme: ColorScheme(
            primary: Colors.lightBlue,
            onPrimary: Colors.white,
            brightness: Brightness.dark,
            secondary: Colors.lightBlue, onSecondary: Colors.white,
            error: Colors.redAccent[200]!,
            onError: Colors.black54, background: Colors.grey[50]!, onBackground: Colors.white, surface: Colors.lightBlue, onSurface: Colors.lightBlue,
          ),
          textTheme: GoogleFonts.workSansTextTheme().apply(bodyColor: Colors.grey[300]!),
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const List<IconData> iconsForBackground = [
    Icons.grade,
    Icons.event_note,
    Icons.format_color_text,
    Iconic.pencil_alt,
    Elusive.book,
    Elusive.glasses,
    FontAwesome5.book,
    FontAwesome5.pen,
    FontAwesome5.apple_alt,
    FontAwesome5.graduation_cap,
    FontAwesome5.brain,
    FontAwesome5.info,
    FontAwesome.doc_text,
    FontAwesome5.calculator,
    FontAwesome5.clipboard,
  ];

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


  void deleteCourse(Course c) {
    Prefs.removeCourse(c);
    setState(() {

    });
  }


  void launchEdit(Course c) {

    Get.to(()=>CourseEditor(c, deleteCourse))?.then((value) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:
     Stack(
       children: [
         const Opacity(opacity: .15, child: IconBackground(icons: MyHomePage.iconsForBackground, padding: 24)),
         SafeArea(
           child:
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                       const Center(child: Padding(
                         padding: EdgeInsets.symmetric(vertical: 28),
                         child: Txt.b("Exam Score Calculator", scaleFactor: 1.5),
                       )),
                        if (Prefs.self.courses.isEmpty) const Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 56),
                          child: Txt("Press '+' to add a Course", scaleFactor: 1.5,),
                        )),
                        ... List.generate(Prefs.self.courses.length, (index) {

                          Widget w = InkWell(
                            onTap: ()=>launchEdit(Prefs.self.courses[index]),
                            child:
                            CourseWidget(Prefs.self.courses[index]));


                          if (index%3==2 && EasyAds.hasAds) {
                            //Add an add to this Widget

                            return Column(children: [
                              w,
                              EasyAds.mrecDecorated('d69da509fd6d400e', '623d8fe8c6da0665')
                            ],);
                          }
                          return w;

                        }),


                      ],
                    ),
                 ),
            ),
            Row(
              children: [
                Expanded(
                  child: InAppAccessLevelChanger(
                    "noads",
                    (a,b)=> EasyAds.hasAds ? Column(children: [
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 3),
                        child: Row(children: [Expanded(child: Txt("Remove Ads", scaleFactor: 1.2)), Button("\$1.99", () {
                          InAppAdapty.purchase("noadspaywall");
                        })],),
                      ),
                      SizedBox(height: 8,),
                      EasyAds.banner('1487ef2952682dd0', '66fed48142571607')
                    ],) : SizedBox(),
                  ),
                ),
                SizedBox(width: 56,)
              ],
            )

          ],
        ),
         ),
       ],
     ),


     floatingActionButton: FloatingActionButton(
        onPressed: () {
          Course c = Course.blank();


          Prefs.addCourse(c);
          launchEdit(c);
          300.milliseconds.delay().then((value) => setState((){}));

        },
        tooltip: 'Add Course',
        child: const Icon(Icons.add, color: Colors.white),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class CircleProg extends StatefulWidget {
  late int prog;
  final Course course;
  CircleProg(this.course, {Key? key}) : super(key: key) {
    if (course.allValuesSet) {
      prog = min(100, course.gradeNeeded).toInt();
      prog = max(0, prog);
    } else {
      prog = 100;
    }
  }

  @override
  State<CircleProg> createState() => _CircleProgState();
}

class _CircleProgState extends State<CircleProg> {
  @override
  Widget build(BuildContext context) {
    return  ClipOval(child: AspectRatio(aspectRatio: 1, child: Stack(
        children: [
          Column(
            children: <Widget>[
              Flexible(child: Container(color: Theme.of(context).brightness==Brightness.dark ? Colors.grey[700] : Colors.grey[300],),
                  flex: 100-widget.prog),
              Flexible(child: Container(color: widget.course.color),
                  flex: widget.prog),

            ],
          ),
          Center(child: Txt(widget.course.allValuesSet ? "${(widget.course
              .gradeNeeded).round()}%" : "?", color: widget.course.color.preferredTextColor, scaleFactor: 1.2
          )),

        ],
      ),


      )
    );
  }
}


extension ColorTools on Color {
  Color get preferredTextColor =>
      computeLuminance() > 0.6 ? Colors.black : Colors.white;
  Color increaseSat(double percent, {bool capAt1 = true}) {
    percent += 1;
    HSLColor c = HSLColor.fromColor(this);
    return c
        .withSaturation(
        capAt1 ? min(1, c.saturation * percent) : c.saturation * percent)
        .toColor();
  }
}