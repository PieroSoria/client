import 'package:get/get.dart';
import 'package:puntos_client/common/models/response_model.dart';

import '../../../../interfaces/repository_interface.dart';
import '../model/UserPoints.dart';

abstract class UserPointsRepositoryInterface extends RepositoryInterface {
  Future<ResponseModel> validateRefCode(String refCode);
  Future<ResponseModel> sendPoints(String refCode, String amount);
}
