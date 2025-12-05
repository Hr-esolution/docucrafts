import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document_model.dart';

class DocumentRepository {
  static final DocumentRepository _instance = DocumentRepository._internal();
  factory DocumentRepository() => _instance;
  DocumentRepository._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'documents.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        templateId TEXT NOT NULL,
        fields TEXT NOT NULL, -- JSON string
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertDocument(DocumentModel document) async {
    final db = await database;
    return await db.insert('documents', document.toMap());
  }

  Future<int> updateDocument(DocumentModel document) async {
    final db = await database;
    return await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }

  Future<void> deleteDocument(int id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('documents', orderBy: 'createdAt DESC');

    return List.generate(maps.length, (i) {
      return DocumentModel.fromMap(maps[i]);
    });
  }

  Future<DocumentModel?> getDocumentById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DocumentModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DocumentModel>> getDocumentsByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return DocumentModel.fromMap(maps[i]);
    });
  }
}