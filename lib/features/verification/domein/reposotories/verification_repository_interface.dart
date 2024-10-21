import 'package:puntos_client/common/models/response_model.dart';
import 'package:puntos_client/interfaces/repository_interface.dart';

abstract class VerificationRepositoryInterface<T>
    extends RepositoryInterface<T> {
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> resetPassword(String? resetToken, String number,
      String password, String confirmPassword);
  Future<ResponseModel> verifyPhone(String? phone, String otp);
  Future<ResponseModel> verifyToken(String? phone, String token);
}
