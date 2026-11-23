import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'fazlaka.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // المكن
        await db.execute('CREATE TABLE machines(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, balance REAL)');
        // المحافظ
        await db.execute('CREATE TABLE wallets(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, balance REAL)');
        // المبيعات
        await db.execute('CREATE TABLE sales(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT)');
        // المخزون
        await db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, qty INTEGER, buy REAL, sell REAL)');
        // الديون
        await db.execute('CREATE TABLE debts(id INTEGER PRIMARY KEY AUTOINCREMENT, customer TEXT, phone TEXT, amount REAL)');
        // المصروفات
        await db.execute('CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, note TEXT, date TEXT)');
        // الصيانة
        await db.execute('CREATE TABLE maintenance(id INTEGER PRIMARY KEY AUTOINCREMENT, device TEXT, status TEXT)');
      },
    );
    return _db!;
  }
}
