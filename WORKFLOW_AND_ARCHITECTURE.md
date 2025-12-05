# DocuCrafts - PDF Document Builder (Offline-First)

## Project Overview

DocuCrafts is a Flutter offline-first application for creating customizable PDF documents with support for invoices, quotes, delivery notes, business cards, and CVs. The app follows a clean MVC architecture with GetX for state management.

## Complete Workflow

### 1. Splash Screen
- Animated splash screen with logo
- Automatic navigation to home after 3 seconds

### 2. Home Page
- Document type selection (Invoice, Quote, Delivery, Business Card, CV)
- Document history preview
- Settings and products management

### 3. Template Selection
- Choose from multiple templates per document type
- Preview functionality for templates
- Template-specific field configurations

### 4. Field Configuration & Data Entry
- Dynamic form generation based on selected template
- Field enable/disable toggles in settings
- Real-time data validation
- Product/item management for invoices/quotes

### 5. Preview & Export
- Real-time document preview
- PDF generation
- Document saving to local storage
- Share functionality

### 6. Document History
- List of all created documents
- View, share, and delete documents
- Detailed document view

## Architecture

### Models
- `DynamicDocumentModel`: Core document representation
- `DocumentField`: Individual field with type, label, value, etc.
- `Template`: Template configuration with fields and styling

### Controllers
- `HomeController`: Manages document history
- `TemplateController`: Template management
- `InvoiceController`: Invoice-specific logic
- `QuoteController`: Quote-specific logic
- `DeliveryController`: Delivery note logic
- `BusinessCardController`: Business card logic
- `CvController`: CV logic

### Repositories
- `StorageRepository`: SQLite-based document storage
- `TemplateRepository`: Template management with SharedPreferences

### Views
- `HomePage`: Main application entry point
- `TemplateSelectionPage`: Template selection interface
- `DocumentFormPage`: Dynamic form for each document type
- `PreviewPage`: Document preview for each template
- `DocumentDetailsPage`: Detailed view of saved documents
- `DocumentsListPage`: Complete document history

## Database Schema

```sql
CREATE TABLE documents (
  id TEXT PRIMARY KEY,
  type TEXT,
  title TEXT,
  fields TEXT, -- JSON string of fields
  createdAt INTEGER,
  updatedAt INTEGER
);
```

## Features

### Offline-First
- All data stored locally
- SQLite for document storage
- SharedPreferences for templates
- No internet connection required

### Document Types
- **Invoices**: Professional invoice creation with tax calculations
- **Quotes**: Estimate and quotation management
- **Delivery Notes**: Shipping and delivery documentation
- **Business Cards**: Professional contact cards
- **CVs**: Resume and curriculum vitae

### Template System
- Multiple templates per document type
- Template preview functionality
- Template-specific field configurations
- Easy switching between templates

### Field Management
- Dynamic field types (text, date, number, email, phone)
- Required field validation
- Field enable/disable configuration
- Real-time form updates

### PDF Generation
- High-quality PDF output
- Template-consistent formatting
- Local file storage
- Share and export capabilities

## Technical Implementation

### State Management
- GetX for reactive programming
- Obx for reactive UI updates
- Controllers for business logic separation

### UI/UX Design
- Glassmorphic design with blur effects
- Gradient backgrounds
- Responsive layouts
- Intuitive navigation

### Performance
- Efficient data loading
- Lazy loading for large lists
- Optimized rendering
- Memory management

## Extensibility

The architecture is designed for easy extension:
- New document types can be added by creating new controllers and views
- Additional templates can be configured through the template system
- New field types can be integrated into the existing model
- Custom styling can be applied per template

## Testing Strategy

- Unit tests for repository operations
- Widget tests for UI components
- Integration tests for workflow validation
- Offline functionality testing

## Security

- Local data storage with no external dependencies
- No sensitive data transmission
- User data remains on device
- Secure local file management

## Deployment

- Cross-platform support (iOS, Android)
- Offline functionality as core feature
- Minimal external dependencies
- Efficient resource usage