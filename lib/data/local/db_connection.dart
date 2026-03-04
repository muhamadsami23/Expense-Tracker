import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class DbConnection {
  //singleton
  DbConnection._();
  static final DbConnection getInstance = DbConnection._();

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'expenseDB.db');

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE ExpenseTable (id VARCHAR(250) PRIMARY KEY , title VARCHAR(50), amount int, Record_Date DATE, Category VARCHAR(12) CHECK (Category IN ('food', 'travel', 'leisure', 'work')))",
        );
      },
      version: 1,
    );
  }

  Future<bool> addExpenseDB({required id, required title, required amount, required date, required category }) async {
    var db = await getDB();

    int effectedRow = await db.insert('ExpenseTable',{
      'id':id,
      'title':title,
      'amount':amount,
      'Record_Date':date,
      'Category':category,
    });

    return effectedRow > 0;
  }

  Future<List<Map<String,dynamic>>> getAll() async{
    var db = await getDB();

    List<Map<String,dynamic>> allData = await db.query('ExpenseTable');

    return allData;
  }


  Future<void> deleteExpenseinDB({required String id}) async {
  var db = await getDB();
  await db.delete(
    'ExpenseTable',
    where: 'id = ?',
    whereArgs: [id],
  );
  print("Deleted");
}
}