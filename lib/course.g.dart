// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      json['name'] as String,
      json['colorInt'] as int,
      (json['currentGrade'] as num).toDouble(),
      (json['examWeight'] as num).toDouble(),
      (json['gradeDesired'] as num).toDouble(),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'name': instance.name,
      'colorInt': instance.colorInt,
      'currentGrade': instance.currentGrade,
      'examWeight': instance.examWeight,
      'gradeDesired': instance.gradeDesired,
    };
