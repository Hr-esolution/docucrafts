class TemplateModel {
  final String id;
  final String name;
  final String documentType;
  final String previewImage; // path to preview image
  final List<FieldModel> fields; // Default fields configuration for this template
  final Map<String, dynamic> style; // Style configuration for the template

  TemplateModel({
    required this.id,
    required this.name,
    required this.documentType,
    required this.previewImage,
    required this.fields,
    required this.style,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'documentType': documentType,
      'previewImage': previewImage,
      'fields': fields.map((field) => field.toMap()).toList(),
      'style': style,
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      documentType: map['documentType'] ?? '',
      previewImage: map['previewImage'] ?? '',
      fields: (map['fields'] as List<dynamic>?)
              ?.map((field) => FieldModel.fromMap(field.cast<String, dynamic>()))
              .toList() ?? [],
      style: map['style'] ?? {},
    );
  }

  TemplateModel copyWith({
    String? id,
    String? name,
    String? documentType,
    String? previewImage,
    List<FieldModel>? fields,
    Map<String, dynamic>? style,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      documentType: documentType ?? this.documentType,
      previewImage: previewImage ?? this.previewImage,
      fields: fields ?? this.fields,
      style: style ?? this.style,
    );
  }
}