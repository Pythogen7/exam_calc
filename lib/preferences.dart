import 'dart:collection';
import 'dart:convert';

import 'package:cross_package/cross_package.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'course.dart';

import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Prefs {

  static Prefs self = Prefs.load();

  static void removeCourse(Course course) {
    self.courses.remove(course);

    save();
  }

  static void addCourse(Course course) {
    self.courses.add(course);
    save();
  }

  static void save() {
    LocalStorage.put("prefs", jsonEncode(self.toJson()));


  }

  static Iterator<Course> get iterCourse {
    return self.courses.iterator;
  }

  Map<String, dynamic> toJson() => _$PrefsToJson(this);


  final List<Course> courses;


  Prefs(this.courses);

  factory Prefs.fromJson(Map<String, dynamic> json) => _$PrefsFromJson(json);


  factory Prefs.load() {
    dynamic p = LocalStorage.get("prefs");
    if (p==null) {
      return Prefs([]);
    }


    return Prefs.fromJson(jsonDecode(p));
  }


}



