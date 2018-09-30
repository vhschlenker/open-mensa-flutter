import 'dart:async';
import 'dart:io';

import 'package:objectdb/objectdb.dart';
import 'package:openmensa/classes/canteen.dart';
import 'package:path_provider/path_provider.dart' as path;

class DatabaseService {
  ObjectDB db;

  Future setUpDb() async {
    Directory appDocDir = await path.getApplicationDocumentsDirectory();
    String dbFilePath = [appDocDir.path, 'favorite_canteens.db'].join('/');
    db = ObjectDB(dbFilePath);
    await db.open();
  }

  Future<List<Canteen>> loadFavoriteCanteensFromDb() async {
    List favoriteCanteensAsMaps = await db.find({});
    return favoriteCanteensAsMaps
        .map((canteenAsMap) => Canteen.fromJson(canteenAsMap))
        .toList();
  }

  Future<ObjectId> insertFavoriteCanteen(Canteen canteen) {
    return db.insert(canteen.toJson());
  }

  Future<int> removeFavoriteCanteen(Canteen canteen) {
    return db.remove({'id': canteen.id});
  }

  Future clearAll() {
    return db.remove({});
  }

  Future close() {
    return db.close();
  }
}
