import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/controllers/template_controller.dart';
import 'routes/app_pages.dart';

void main() {
  Get.put(TemplateController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PDF Customizer App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Changed to splash page
      getPages: AppPages.routes,
    );
  }
}
