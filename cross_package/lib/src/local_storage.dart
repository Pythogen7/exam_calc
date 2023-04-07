import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


class LocalStorage {
  static Future<void> initialize() async {
    _storage ??= kIsWeb
        ? (await Hive.openBox("local_storage"))
        : (await Hive.openBox("local_storage", path: await filePath));
  }

  static Future<String> get filePath async => kIsWeb
      ? "/"
      : (await getApplicationDocumentsDirectory()).path; //Doesn't work on Web!

  static Box get storage {
    assert(_storage != null, "LocalStorage needs to be initialized");
    return _storage!;
  }

  static Box? _storage;

  static dynamic get(String key) {
    var a = storage.get(key);
    return a;
  }

  static Future<void> put(String key, dynamic val) async {
    return storage.put(key, val);
  }
}