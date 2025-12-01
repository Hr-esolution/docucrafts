import 'package:get/get.dart';
import '../controllers/quote_controller.dart';

class QuoteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuoteController>(
      () => QuoteController(),
    );
  }
}