# DocuCrafts - PDF Document Builder

A Flutter offline-first application for creating customizable PDF documents with support for invoices, quotes, delivery notes, business cards, and CVs.

## Features

- **Offline-First**: All data stored locally with no internet connection required
- **Multiple Document Types**: Invoices, quotes, delivery notes, business cards, and CVs
- **Template System**: Multiple templates per document type with preview functionality
- **Dynamic Forms**: Automatically generated forms based on selected template
- **Field Configuration**: Enable/disable fields, set required status
- **PDF Generation**: High-quality PDF output with template-consistent formatting
- **Document Management**: Save, view, share, and delete documents
- **Glassmorphic UI**: Modern UI design with gradient backgrounds and blur effects

## Architecture

### Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Database**: SQLite (sqflite) for documents, SharedPreferences for templates
- **PDF Generation**: pdf package
- **UI**: Material Design with custom glassmorphic effects

### Project Structure
```
lib/
├── app/
│   ├── controllers/     # GetX controllers
│   ├── models/         # Data models
│   ├── pages/          # UI screens
│   ├── repositories/   # Data access layer
│   ├── routes/         # Navigation routes
│   └── widgets/        # Reusable UI components
├── main.dart          # App entry point
└── routes/            # Route definitions
```

### Core Models
- `DynamicDocumentModel`: Represents a document with fields and metadata
- `DocumentField`: Individual form field with type, label, value, etc.
- `Template`: Template configuration with fields and styling

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6           # State management
  pdf: ^3.10.8          # PDF generation
  path_provider: ^2.1.1 # File system access
  sqflite: ^2.3.0       # SQLite database
  shared_preferences: ^2.2.2 # Key-value storage
  printing: ^5.14.2     # Print and share PDFs
  share_plus: ^7.2.1    # Share functionality
```

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd pdf_customizer_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Usage

1. **Select Document Type**: Choose from Invoice, Quote, Delivery Note, Business Card, or CV
2. **Choose Template**: Select from multiple available templates
3. **Fill Form**: Enter data in the dynamically generated form
4. **Preview**: View real-time document preview
5. **Export**: Generate PDF and save to device
6. **Manage**: Access document history and manage saved documents

## Development

### Adding New Document Types
1. Create a new controller extending the pattern of existing controllers
2. Create form and preview pages
3. Add routes to `app_pages.dart`
4. Update home page to include the new document type

### Adding New Templates
1. Define template configuration in `TemplateRepository`
2. Create preview page for the new template
3. Update controller to handle the new template

### Customizing Fields
- Fields are defined in template configurations
- Field types include text, date, number, email, phone
- Required status and enable/disable can be configured per template

## Testing

The application includes:
- Unit tests for repository operations
- Widget tests for UI components
- Integration tests for workflow validation

To run tests:
```bash
flutter test
```

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Architecture Decisions

### Why GetX for State Management?
- Lightweight and performant
- Built-in reactive programming
- Easy dependency injection
- Small learning curve

### Why SQLite for Offline Storage?
- Robust local database solution
- ACID compliance
- Good performance for mobile
- Easy schema management

### Why PDF Package for Generation?
- Pure Dart implementation
- No external dependencies
- Good formatting control
- Cross-platform compatibility

## Performance Considerations

- Efficient data loading with lazy loading
- Memory management for large documents
- Optimized rendering with widget reuse
- Caching for frequently accessed data

## Security

- All data stored locally on device
- No external API calls for core functionality
- Secure local file storage
- No sensitive data transmission

## License

This project is licensed under the MIT License - see the LICENSE file for details.