import 'package:puntos_client/api/api_client.dart';
import 'package:puntos_client/features/auth/domain/models/delivery_man_body.dart';
import 'package:puntos_client/interfaces/repository_interface.dart';

abstract class DeliverymanRegistrationRepositoryInterface
    extends RepositoryInterface {
  @override
  Future getList(
      {int? offset, int? zoneId, bool isZone = true, bool isVehicle = false});
  Future<bool> registerDeliveryMan(
      DeliveryManBody deliveryManBody, List<MultipartBody> multiParts);
}
