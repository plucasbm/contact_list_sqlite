import 'package:contact_list/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String contactTable = "contactTable";
const String idColumn = "idColumn";
const String nameColumn = "nameColumn";
const String emailColumn = "emailColumn";
const String phoneColumn = "phoneColumn";
const String imageColumn = "imageColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, newerVersion) async {
        await db.execute(
            "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imageColumn TEXT)");
      },
    );
  }

  Future<Contact> saveContact(Contact contact) async {
    Database? contactDb = await db;
    contact.id = await contactDb!
        .insert(contactTable, contact.toMap() as Map<String, Object?>);
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database? contactDb = await db;
    List<Map> maps = await contactDb!.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imageColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return Contact.fromMap(maps.isEmpty as Map);
    }
  }

  Future<int> deleteContact(int id) async {
    Database? contactDb = await db;
    return await contactDb!
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database? contactDb = await db;
    return await contactDb!.update(
      contactTable,
      contact.toMap() as Map<String, Object?>,
      where: "$idColumn = ?",
      whereArgs: [contact.id],
    );
  }

  Future<List> getAllContacts() async {
    Database? contactDb = await db;
    List listMap = await contactDb!.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contactList = [];

    for(Map m in listMap){
      contactList.add(Contact.fromMap(m));
    }

    return contactList;
  }

  Future closeDb() async {
    Database? contactDb = await db;
    contactDb!.close();
  }
}
