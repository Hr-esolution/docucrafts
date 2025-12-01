import 'package:get/get.dart';
import '../controllers/cv_controller.dart';

class CvBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CvController>(
      () => CvController(),
    );
  }
}