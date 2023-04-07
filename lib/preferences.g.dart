// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prefs _$PrefsFromJson(Map<String, dynamic> json) => Prefs(
      (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrefsToJson(Prefs instance) => <String, dynamic>{
      'courses': instance.courses.map((e) => e.toJson()).toList(),
    };
