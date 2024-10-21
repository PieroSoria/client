import 'package:puntos_client/features/shared_points/domain/model/UserPoints.dart';
import 'package:puntos_client/features/shared_points/domain/repository/user_points_repository_interface.dart';
import 'package:puntos_client/features/shared_points/domain/service/user_points_service_interface.dart';

import '../../../../common/models/response_model.dart';

class UserPointsService implements UserPointsServiceInterface {
  final UserPointsRepositoryInterface userPointsRepositoryInterface;
  UserPointsService({required this.userPointsRepositoryInterface});

  @override
  Future<ResponseModel> sendPoints(String refCode, String amount) async {
    ResponseModel responseModel =
        await userPointsRepositoryInterface.sendPoints(refCode, amount);
    return responseModel;
  }

  @override
  Future<ResponseModel> validateRefCode(String refCode) async {
    ResponseModel responseModel =
        await userPointsRepositoryInterface.validateRefCode(refCode);
    // if(responseModel.isSuccess){

    // }
    return responseModel;
  }
}
