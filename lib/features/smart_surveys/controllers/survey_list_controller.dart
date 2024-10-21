import 'package:get/get.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/response_model/answer_model_response.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/response_model/survey_model_response.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/survey_model.dart';

import 'package:puntos_client/features/smart_surveys/domain/services/surveys_services_inferface.dart';

class SurveyListController extends GetxController implements GetxService {
  final SurveysServicesInferface surveysServicesInferface;

  SurveyListController({required this.surveysServicesInferface});

  var surveyList = <SurveyModel>[].obs;
  var isLoading = false.obs;

  var isSendSurvey = false.obs;

  var surveyModelResponse = SurveyModelResponse(
    userId: 0,
    surveyId: 0,
    points: 0,
    answers: [],
  ).obs;

  Future<void> getAllSurveys({required String userId}) async {
    try {
      isLoading(true);
      var surveys = await surveysServicesInferface.getAll(userId: userId);

      surveyList.clear();
      // surveyList.assignAll(surveys);
      surveyList.value = surveys;
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendSurvey({required SurveyModelResponse response}) async {
    try {
      isLoading(true);
      var value = await surveysServicesInferface.sendSurvey(response: response);
      isSendSurvey = RxBool(value);
      Get.back();
      isLoading(false);
    } catch (e) {
      isSendSurvey = false.obs;
      isLoading(false);
    }
  }

  void updateSurveyModelResponse({
    int? userId,
    int? surveyId,
    int? points,
    List<AnswerModelReponse>? answers,
  }) {
    // Usamos copyWith para actualizar solo los campos necesarios
    surveyModelResponse.value = surveyModelResponse.value.copyWith(
      userId: userId,
      surveyId: surveyId,
      points: points,
      answers: answers,
    );
  }
}
