import 'package:get/get.dart';
import 'package:shoppingapp/controller/network_controller.dart';

class DependencyInjection {
  static void init(){
    Get.put<NetworkController>(NetworkController());
  }
}