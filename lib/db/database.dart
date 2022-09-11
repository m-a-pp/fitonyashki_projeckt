import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:fitonyashki_projeckt/models/activity.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async{
    if(_database!=null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'activity_database.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE activities(id INTEGER PRIMARY KEY AUTOINCREMENT, typeOfActivity TEXT, kcals INTEGER, distance REAL, date TEXT)');
  }

  Future<List<Activity>> getActivities() async{
    Database? db = await database;
    final List<Map<String, dynamic>> activitiesMapList = await db!.query('activities');
    final List<Activity> activitiesList = [];
    activitiesMapList.forEach((activityMap) {
      activitiesList.add(Activity.fromMap(activityMap));
    });
    return activitiesList;
  }

  Future<Activity> insertActivity(Activity activity) async{
    Database? db = await database;
    activity.id = await db!.insert('activities', activity.toMap());
    return activity;
  }

  Future<int> deletActivity(int? id)async{
    Database? db = await database;
    return await db!.delete('activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

