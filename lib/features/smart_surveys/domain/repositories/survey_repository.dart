import 'package:puntos_client/api/api_client.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/response_model/survey_model_response.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/survey_model.dart';
import 'package:puntos_client/features/smart_surveys/domain/repositories/survey_repository_interface.dart';
import 'package:puntos_client/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyRepository implements SurveyRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SurveyRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });
  @override
  Future<bool> sendSurvey({required SurveyModelResponse response}) async {
    final Map<String, dynamic> body = response.toJson();

    print("lucadev map$body");

    try {
      final response = await apiClient.postData(AppConstants.sendSurvey, body);

      if (response.statusCode == 200) {
        print("lucadev send ${response.body}");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<SurveyModel>> getAll({required String userId}) async {
    try {
      List<SurveyModel> surveyStoreList = [];

      print("lucadev: $userId");

      final Map<String, dynamic> map = {"user_id": int.parse(userId)};
      // print("lucadev userid $userId");
      final response2 = await apiClient.postData(AppConstants.surveyStore, map);

      if (response2.statusCode == 200) {
        var data = (response2.body as List<dynamic>)
            .map((value) => SurveyModel.fromMap(value))
            .toList();
        print("lucadev: ${data.length}");
        print("lucadev: ${data.length}");
        surveyStoreList.addAll(SurveyModel.listFromJson(response2.body!));

        // surveyStoreList.addAll(data);
      } else {
        throw Exception("Failed to load surveys: ${response2.statusCode}");
      }
      return surveyStoreList; // No necesitas usar '!' porque surveyStoreList siempre tendrá un valor (aunque sea vacío)
    } catch (e) {
      rethrow; // rethrow relanza la excepción para que pueda ser capturada más arriba si es necesario
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
