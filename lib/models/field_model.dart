class FieldModel {
  final String name;
  final String label;
  final String type; // text, number, date, email, etc.
  final bool required;
  final int order;
  final bool enabled; // whether the field is active in the form

  FieldModel({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.order = 0,
    this.enabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
      'type': type,
      'required': required ? 1 : 0, // Store as integer for SQLite
      'order': order,
      'enabled': enabled ? 1 : 0, // Store as integer for SQLite
    };
  }

  factory FieldModel.fromMap(Map<String, dynamic> map) {
    return FieldModel(
      name: map['name'] ?? '',
      label: map['label'] ?? '',
      type: map['type'] ?? 'text',
      required: map['required'] == 1,
      order: map['order']?.toInt() ?? 0,
      enabled: map['enabled'] == 1,
    );
  }

  FieldModel copyWith({
    String? name,
    String? label,
    String? type,
    bool? required,
    int? order,
    bool? enabled,
  }) {
    return FieldModel(
      name: name ?? this.name,
      label: label ?? this.label,
      type: type ?? this.type,
      required: required ?? this.required,
      order: order ?? this.order,
      enabled: enabled ?? this.enabled,
    );
  }
}