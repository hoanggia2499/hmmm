import 'package:hive/hive.dart';

class Boxes {
  static Boxes instance = Boxes._internal();

  factory Boxes() {
    return instance;
  }

  Boxes._internal();

  Future<Box<T>> getBox<T>(String tableName) async =>
      await Hive.openBox<T>(tableName);
}
