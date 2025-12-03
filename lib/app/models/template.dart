class Template {
  final String id;
  final String name;
  final String description;
  final String category; // invoice, quote, delivery, business_card, cv
  final String previewImage; // path to preview image
  final List<Map<String, dynamic>> fields; // template fields configuration
  final DateTime createdAt;
  final DateTime updatedAt;

  Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.previewImage,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'previewImage': previewImage,
      'fields': fields,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Template.fromMap(Map<String, dynamic> map) {
    return Template(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      previewImage: map['previewImage'] ?? '',
      fields: List<Map<String, dynamic>>.from(map['fields'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Template copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? previewImage,
    List<Map<String, dynamic>>? fields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      previewImage: previewImage ?? this.previewImage,
      fields: fields ?? this.fields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}