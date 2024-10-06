import 'package:get/get.dart';
import 'package:waste_wise/common_network_check/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController());
  }
}
