import 'package:puntos_client/features/smart_surveys/domain/models/response_model/survey_model_response.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/survey_model.dart';
import 'package:puntos_client/interfaces/repository_interface.dart';

abstract class SurveyRepositoryInterface implements RepositoryInterface {
  Future<List<SurveyModel>> getAll({required String userId});
  Future<bool> sendSurvey({required SurveyModelResponse response});
}
