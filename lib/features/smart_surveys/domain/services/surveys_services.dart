import 'package:puntos_client/features/smart_surveys/domain/models/response_model/survey_model_response.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/survey_model.dart';
import 'package:puntos_client/features/smart_surveys/domain/repositories/survey_repository_interface.dart';
import 'package:puntos_client/features/smart_surveys/domain/services/surveys_services_inferface.dart';

class SurveysServices implements SurveysServicesInferface {
  final SurveyRepositoryInterface surveyRepositoryInterface;

  SurveysServices({required this.surveyRepositoryInterface});
  @override
  Future<List<SurveyModel>> getAll({required String userId}) async {
    return surveyRepositoryInterface.getAll(userId: userId);
  }

  @override
  Future<bool> sendSurvey({required SurveyModelResponse response}) {
    return surveyRepositoryInterface.sendSurvey(response: response);
  }
}
