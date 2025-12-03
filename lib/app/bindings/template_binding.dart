import 'package:get/get.dart';
import '../controllers/template_controller.dart';
import '../controllers/product_controller.dart';

class TemplateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateController>(() => TemplateController());
    // Ensure product controller is also available
    Get.lazyPut<ProductController>(() => ProductController());
  }
}