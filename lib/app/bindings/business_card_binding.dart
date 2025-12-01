import 'package:get/get.dart';
import '../controllers/business_card_controller.dart';

class BusinessCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessCardController>(
      () => BusinessCardController(),
    );
  }
}