import 'package:get/get.dart';
import 'package:shoppingapp/common_network_check/network_controller.dart';

class DependencyInjection {
  static void init(){
    Get.put<NetworkController>(NetworkController());
  }
}