class DynamicDocumentModel {
  final String id;
  final String type;
  final String title;
  final List<DocumentField> fields;
  final DateTime createdAt;
  final DateTime updatedAt;

  DynamicDocumentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'fields': fields.map((field) => field.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DynamicDocumentModel.fromMap(Map<String, dynamic> map) {
    return DynamicDocumentModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      fields: List<DocumentField>.from(
        (map['fields'] as List).map((field) => DocumentField.fromMap(field)),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}

class DocumentField {
  final String id;
  final String label;
  final String value;
  final FieldType type;
  final bool isRequired;

  DocumentField({
    required this.id,
    required this.label,
    required this.value,
    required this.type,
    this.isRequired = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'type': type.toString(),
      'isRequired': isRequired ? 1 : 0,
    };
  }

  factory DocumentField.fromMap(Map<String, dynamic> map) {
    return DocumentField(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      value: map['value'] ?? '',
      type: _getFieldTypeFromString(map['type'] ?? ''),
      isRequired: (map['isRequired'] == 1),
    );
  }

  static FieldType _getFieldTypeFromString(String typeString) {
    switch (typeString) {
      case 'FieldType.text':
        return FieldType.text;
      case 'FieldType.date':
        return FieldType.date;
      case 'FieldType.number':
        return FieldType.number;
      case 'FieldType.email':
        return FieldType.email;
      case 'FieldType.phone':
        return FieldType.phone;
      default:
        return FieldType.text;
    }
  }
}

enum FieldType {
  text,
  date,
  number,
  email,
  phone,
}