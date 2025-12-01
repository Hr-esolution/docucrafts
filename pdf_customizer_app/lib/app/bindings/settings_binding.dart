import 'package:get/get.dart';
import '../controllers/invoice_controller.dart';
import '../controllers/quote_controller.dart';
import '../controllers/delivery_controller.dart';
import '../controllers/business_card_controller.dart';
import '../controllers/cv_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize controllers if they don't exist yet, otherwise use existing instances
    if (Get.isRegistered<InvoiceController>()) {
      Get.find<InvoiceController>();
    } else {
      Get.put(InvoiceController(), permanent: true);
    }
    
    if (Get.isRegistered<QuoteController>()) {
      Get.find<QuoteController>();
    } else {
      Get.put(QuoteController(), permanent: true);
    }
    
    if (Get.isRegistered<DeliveryController>()) {
      Get.find<DeliveryController>();
    } else {
      Get.put(DeliveryController(), permanent: true);
    }
    
    if (Get.isRegistered<BusinessCardController>()) {
      Get.find<BusinessCardController>();
    } else {
      Get.put(BusinessCardController(), permanent: true);
    }
    
    if (Get.isRegistered<CvController>()) {
      Get.find<CvController>();
    } else {
      Get.put(CvController(), permanent: true);
    }
  }
}