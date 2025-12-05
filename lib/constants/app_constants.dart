class AppConstants {
  // App Info
  static const String appName = 'DocuCrafts';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'docucrafts.db';
  static const int databaseVersion = 1;
  
  // Storage
  static const String documentsStoragePath = 'documents';
  static const String templatesStoragePath = 'templates';
  
  // Colors
  static const Color primaryColor = Color(0xFF667eea);
  static const Color secondaryColor = Color(0xFF764ba2);
  static const Color backgroundColor = Color(0xFFf0f4f8);
  static const Color cardColor = Color(0xFFffffff);
  
  // Document Types
  static const List<String> documentTypes = [
    'invoice',
    'quote',
    'delivery',
    'business_card',
    'cv',
  ];
  
  // Field Types
  static const List<String> fieldTypes = [
    'text',
    'number',
    'date',
    'email',
    'textarea',
    'table',
    'signature',
    'image',
    'url',
    'list',
  ];
}