import 'package:puntos_client/common/models/response_model.dart';
import 'package:puntos_client/features/address/domain/models/address_model.dart';

abstract class AddressServiceInterface {
  Future<List<AddressModel>?> getAllAddress();
  Future<ResponseModel> removeAddressByID(int? id);
  Future<ResponseModel> addAddress(AddressModel addressModel);
  Future<ResponseModel> updateAddress(
      AddressModel addressModel, int? addressId);
}