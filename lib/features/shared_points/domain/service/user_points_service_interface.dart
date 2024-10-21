import '../../../../common/models/response_model.dart';
import '../model/UserPoints.dart';

abstract class UserPointsServiceInterface {
  Future<ResponseModel> validateRefCode(String refCode);
  Future<ResponseModel> sendPoints(String refCode, String amount);
}
