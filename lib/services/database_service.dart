import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/guest.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<void> resetData() async {
    final db = await database;
    await db.delete('guests'); // Ganti 'guests' dengan nama tabel Anda
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'guest_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE guests ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, '
          'plateNumber TEXT, '
          'purpose TEXT, '
          'checkInTime TEXT, '
          'checkOutTime TEXT)',
        );
      },
    );
  }

  Future<void> insertGuest(Guest guest) async {
    final db = await database;
    await db.insert('guests', guest.toMap());
  }

  Future<List<Guest>> fetchGuests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('guests');
    return List.generate(maps.length, (i) {
      return Guest(
        id: maps[i]['id'],
        name: maps[i]['name'],
        plateNumber: maps[i]['plateNumber'],
        purpose: maps[i]['purpose'],
        checkInTime: DateTime.parse(maps[i]['checkInTime']),
        checkOutTime: maps[i]['checkOutTime'] != null
            ? DateTime.parse(maps[i]['checkOutTime'])
            : null,
      );
    });
  }

  Future<void> checkoutGuest(int id) async {
  final db = await database;
  await db.update(
    'guests',
    {'checkOutTime': DateTime.now().toIso8601String()},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> updateGuest(Guest guest) async {
  final db = await database;
  await db.update(
    'guests',
    guest.toMap(),
    where: 'id = ?',
    whereArgs: [guest.id],
  );
}


}
