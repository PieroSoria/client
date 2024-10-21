import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/common/models/response_model.dart';
import 'package:puntos_client/features/shared_points/domain/model/UserPoints.dart';
import 'package:puntos_client/features/shared_points/domain/repository/user_points_repository_interface.dart';

import '../../../../api/api_client.dart';

class UserPointsRepository implements UserPointsRepositoryInterface {
  final ApiClient apiClient;
  UserPointsRepository({required this.apiClient});

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> sendPoints(String refCode, String amount) async {
    try {
      Response response = await apiClient.postData(
          '/api/v1/auth/send-points', {"ref_code": refCode, "amount": amount},
          handleError: false);
      print(" ========== Rpta send-points2 0 ${response.statusCode}");

      debugPrint(" ========== Rpta send-points2 0 ${response.statusCode}");
      if (response.statusCode == 200) {
        return ResponseModel(true, response.body["message"]);
      } else {
        return ResponseModel(false, response.body["message"]);
      }
    } catch (e) {
      print("============>$e");
      debugPrint("============ send-points2 e >$e");
      return ResponseModel(false, "");
    }
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> validateRefCode(String refCode) async {
    try {
      Response response = await apiClient.postData(
          '/api/v1/auth/validate-refCod', {"ref_code": refCode},
          handleError: false);
      print(" ========== Rpta validateRefCode 0 ${response.statusCode}");

      debugPrint(" ========== Rpta validateRefCode 0 ${response.statusCode}");
      if (response.statusCode == 200) {
        return ResponseModel(true, response.body["message"]);
      } else {
        return ResponseModel(false, response.body["message"]);
      }
    } catch (e) {
      print("============>$e");
      debugPrint("============ validateRefCode e >$e");
      return ResponseModel(false, "");
    }
  }
}
