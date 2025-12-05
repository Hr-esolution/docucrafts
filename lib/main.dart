import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_page.dart';
import 'views/template_selection_page.dart';
import 'views/field_configuration_page.dart';
import 'views/document_form_page.dart';
import 'views/document_preview_page.dart';
import 'views/document_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DocuCrafts - PDF Document Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF667eea)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/template-selection', page: () => const TemplateSelectionPage()),
        GetPage(name: '/field-configuration', page: () => const FieldConfigurationPage()),
        GetPage(name: '/document-form', page: () => const DocumentFormPage()),
        GetPage(name: '/document-preview', page: () => const DocumentPreviewPage()),
        GetPage(name: '/document-history', page: () => const DocumentHistoryPage()),
      ],
      home: const HomePage(),
    );
  }
}
