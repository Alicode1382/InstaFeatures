import 'package:sqflite/sqflite.dart';

import '../db/database_provider.dart';

class DbHelper {
  DatabaseProvider? databaseProvider = DatabaseProvider.getInstance();

  Future<List<Map<String, dynamic>>?> getAllItem(
      {required String tableName,
      required bool distinct,
      required int limit,
      String? fields,
      String? where,
      String? order,
      String? groupby,
      String? having}) async {
    DatabaseProvider sql = DatabaseProvider();
    var dbClient = await sql.db;
    List<Map<String, dynamic>>? result;
    String query =
        "SELECT ${distinct ? "DISTINCT" : ""} ${fields ?? "*"} FROM $tableName ${where == null ? "" : " WHERE $where"} ${groupby == null ? "" : "GROUP BY $groupby"} ${having == null ? "" : "HAVING $having"} ${order == null ? "" : "ORDER BY $order"} ${limit == 0 ? "" : "LIMIT $limit"}";
    await dbClient.transaction((txn) async {
      result = await txn.rawQuery(query);
    });
    return (result != null && result!.isNotEmpty) ? result!.toList() : null;
  }

  Future<Map?> getItem(String tableName) async {
    List<Map> maps = [];
    DatabaseProvider sql = DatabaseProvider();
    var dbClient = await sql.db;
    await dbClient.transaction((txn) async {
      maps = await txn.rawQuery("SELECT * FROM $tableName");
    });
    return (maps.isNotEmpty) ? maps.first : null;
  }

  Future<List> getTableInfo(String tableName) async {
    DatabaseProvider sql = DatabaseProvider();
    var dbClient = await sql.db;
    List result = [];
    await dbClient.transaction((txn) async {
      result = await txn.rawQuery("pragma table_info(\"$tableName\")");
    });
    if (result.isEmpty) return [];
    return result.toList();
  }

  Future<int?> getCount(String tableName) async {
    DatabaseProvider sql = DatabaseProvider();
    var dbClient = await sql.db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<int?> insert(String tableName, Map<String, dynamic> value,
      ConflictAlgorithm? conflictAlgorithm) async {
    int? result;
    try {
      var dbClient = await databaseProvider!.db;
      await dbClient.transaction(
        (txn) async {
          result = await txn.insert(
            tableName,
            value,
            conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace,
          );
        },
      );

      return result ?? 0;
    } catch (exception) {
      throw Exception(
        exception.toString(),
      );
    }
  }

  Future<bool> createTableBatch(List<dynamic> listQuery) async {
    DatabaseProvider sql = DatabaseProvider();
    var dbClient = await sql.db;
    var batch = dbClient.batch();
    for (var item in listQuery) {
      batch.execute(item);
      print("createTable " + item);
    }
    var result = await batch.commit();
    return result.isNotEmpty ? true : false;
  }
}
