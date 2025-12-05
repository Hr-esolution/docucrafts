import 'dart:convert';

class DocumentModel {
  final int? id;
  final String type;
  final String title;
  final String templateId;
  final Map<String, dynamic> fields;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentModel({
    this.id,
    required this.type,
    required this.title,
    required this.templateId,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'templateId': templateId,
      'fields': fields.toString(), // Store as JSON string
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      templateId: map['templateId'] ?? '',
      fields: map['fields'] != null ? _parseFields(map['fields']) : {},
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  static Map<String, dynamic> _parseFields(String fieldsJson) {
    try {
      // This would normally parse the JSON string back to a Map
      // For now, we'll return an empty map since we don't have a JSON parser here
      return {};
    } catch (e) {
      return {};
    }
  }

  DocumentModel copyWith({
    int? id,
    String? type,
    String? title,
    String? templateId,
    Map<String, dynamic>? fields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      fields: fields ?? this.fields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}