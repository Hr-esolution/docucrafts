// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/routes/app_routes.dart';
import '../app/bindings/home_binding.dart';
import '../app/bindings/invoice_binding.dart';
import '../app/bindings/quote_binding.dart';
import '../app/bindings/delivery_binding.dart';
import '../app/bindings/business_card_binding.dart';
import '../app/bindings/cv_binding.dart';
import '../app/bindings/settings_binding.dart';
import '../app/bindings/template_binding.dart';
import '../app/bindings/product_binding.dart';
import '../app/pages/home/home_page.dart';
import '../app/pages/invoice/invoice_form_page.dart';
import '../app/pages/quote/quote_form_page.dart';
import '../app/pages/delivery/delivery_form_page.dart';
import '../app/pages/business_card/business_card_form.dart';
import '../app/pages/cv/cv_form_page.dart';
import '../app/pages/settings/field_settings_page.dart';
import '../app/pages/template_selection_page.dart';
import '../app/pages/splash_page.dart'; // Added splash page import
import '../app/pages/products.dart'; // Added products page import
import '../app/pages/documents_list_page.dart'; // Added documents list page import

abstract class AppPages {
  static const INITIAL = '/splash'; // Changed to splash as initial route

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.INVOICE,
      page: () => const InvoiceFormPage(),
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: Routes.QUOTE,
      page: () => const QuoteFormPage(),
      binding: QuoteBinding(),
    ),
    GetPage(
      name: Routes.DELIVERY,
      page: () => const DeliveryFormPage(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: Routes.BUSINESS_CARD,
      page: () => const BusinessCardForm(),
      binding: BusinessCardBinding(),
    ),
    GetPage(
      name: Routes.CV,
      page: () => const CvFormPage(),
      binding: CvBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const FieldSettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => const ProductsPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: '${Routes.TEMPLATES}/:type',
      page: () => TemplateSelectionPage(
        documentType: Get.parameters['type'] ?? '',
        onTemplateSelected: (templateId) {
          // Navigate to the appropriate document form based on type
          String documentType = Get.parameters['type'] ?? '';
          switch (documentType) {
            case 'invoice':
              Get.offAllNamed(Routes.INVOICE);
              break;
            case 'quote':
              Get.offAllNamed(Routes.QUOTE);
              break;
            case 'delivery':
              Get.offAllNamed(Routes.DELIVERY);
              break;
            case 'business_card':
              Get.offAllNamed(Routes.BUSINESS_CARD);
              break;
            case 'cv':
              Get.offAllNamed(Routes.CV);
              break;
          }
        },
      ),
      binding: TemplateBinding(),
    ),
    GetPage(
      name: Routes.DOCUMENTS,
      page: () => const DocumentsListPage(),
    ),
  ];
}
