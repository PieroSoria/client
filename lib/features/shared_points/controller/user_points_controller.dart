import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/shared_points/domain/service/user_points_service_interface.dart';

import '../../../common/models/response_model.dart';

class UserPointsController extends GetxController implements GetxService {
  final UserPointsServiceInterface userPointsServiceInterface;

  UserPointsController({required this.userPointsServiceInterface}) {}

  Future<ResponseModel> validateRefCode(String refCode) async {
    ResponseModel responseModel =
        await userPointsServiceInterface.validateRefCode(refCode);
    //Get.find<SplashController>().configModel!.customerVerification!);
    print("----------${responseModel.isSuccess}");
    debugPrint("============ validateRefCode new >${responseModel.isSuccess}");
    // if (responseModel.isSuccess) {}

    return responseModel;
  }

  Future<ResponseModel> sendPoints(String refCode, String amount) async {
    ResponseModel responseModel =
        await userPointsServiceInterface.sendPoints(refCode, amount);
    //Get.find<SplashController>().configModel!.customerVerification!);
    print("----------${responseModel.isSuccess}");
    debugPrint("============ validateRefCode new >${responseModel.isSuccess}");
    // if (responseModel.isSuccess) {}

    return responseModel;
  }
}
