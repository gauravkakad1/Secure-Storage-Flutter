import 'package:flutter/material.dart';
import 'package:secure_storage_flutter/data/user_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DataBasehelper {
  Database? db;
  String tableName = "UserTable";
  String columnUsername = 'username';
  String columnPassword = "password";

  Future open(String path, String password) async {
    db = await openDatabase(path, version: 1, password: password,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableName ( 
        $columnUsername text primary key,
        $columnPassword text not null
      )
    ''');
    });
  }

  Future<User?> insert(User user) async {
    db?.insert(tableName, user.toMap());
    return user;
    // try {
    //   await db?.insert(
    //     tableName,
    //     user.toMap(),
    //     conflictAlgorithm:
    //         ConflictAlgorithm.fail, // Fail if the username already exists
    //   );
    //   print('User inserted successfully.');
    // } catch (e) {
    //   print('Error inserting user: $e');
    //   // Handle the case where the username already exists
    // }
  }

  Future<User?> getData(String username) async {
    List<Map<String, Object?>> maps = await db?.query(tableName,
            columns: [
              columnUsername,
              columnPassword,
            ],
            where: '$columnUsername = ?',
            whereArgs: [username]) ??
        [];
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>?> getAllData() async {
    List<Map<String, Object?>> maps = await db?.query(tableName, columns: [
          columnUsername,
          columnPassword,
        ]) ??
        [];
    if (maps.length > 0) {
      return maps.map((e) => User.fromMap(e)).toList();
    }
    return null;
  }

  Future<int?> delete(String username) async {
    return await db?.delete(tableName,
        where: '$columnUsername = ?', whereArgs: [username]);
  }

  Future<int?> update(User person) async {
    return await db?.update(tableName, person.toMap(),
        where: '$columnUsername = ?', whereArgs: [person.username]);
  }

  Future close() async => db?.close();
  String getDbPath() {
    return db?.path ?? "";
  }
}
