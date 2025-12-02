import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dynamic_document_model.dart';

class StorageRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'pdf_customizer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        type TEXT,
        title TEXT,
        fields TEXT,
        createdAt INTEGER,
        updatedAt INTEGER
      )
    ''');
  }

  Future<void> saveDocument(DynamicDocumentModel document) async {
    final db = await database;
    await db.insert(
      'documents',
      {
        'id': document.id,
        'type': document.type,
        'title': document.title,
        'fields': _encodeFields(document.fields),
        'createdAt': document.createdAt.millisecondsSinceEpoch,
        'updatedAt': document.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DynamicDocumentModel>> getAllDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('documents');

    return List.generate(maps.length, (i) {
      return DynamicDocumentModel(
        id: maps[i]['id'],
        type: maps[i]['type'],
        title: maps[i]['title'],
        fields: _decodeFields(maps[i]['fields']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updatedAt']),
      );
    });
  }

  Future<DynamicDocumentModel?> getDocumentById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DynamicDocumentModel(
        id: maps[0]['id'],
        type: maps[0]['type'],
        title: maps[0]['title'],
        fields: _decodeFields(maps[0]['fields']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[0]['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[0]['updatedAt']),
      );
    }

    return null;
  }

  Future<void> deleteDocument(String id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  String _encodeFields(List<DocumentField> fields) {
    List<Map<String, dynamic>> fieldMaps =
        fields.map((field) => field.toMap()).toList();
    return jsonEncode(fieldMaps);
  }

  List<DocumentField> _decodeFields(String fieldsString) {
    if (fieldsString.isEmpty) return [];
    try {
      List<dynamic> fieldList = jsonDecode(fieldsString);
      return fieldList.map((field) => DocumentField.fromMap(field)).toList();
    } catch (e) {
      print('Error decoding fields: $e');
      return [];
    }
  }
}
