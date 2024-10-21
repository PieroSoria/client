import 'package:puntos_client/features/smart_surveys/domain/models/response_model/answer_model_response.dart';

class SurveyModelResponse {
  final int userId;
  final int surveyId;
  final int points;
  final List<AnswerModelReponse> answers;

  SurveyModelResponse({
    required this.userId,
    required this.surveyId,
    required this.points,
    required this.answers,
  });

  SurveyModelResponse copyWith({
    int? userId,
    int? surveyId,
    int? points,
    List<AnswerModelReponse>? answers,
  }) =>
      SurveyModelResponse(
        userId: userId ?? this.userId,
        surveyId: surveyId ?? this.surveyId,
        points: points ?? this.points,
        answers: answers ?? this.answers,
      );

  factory SurveyModelResponse.fromJson(Map<String, dynamic> json) =>
      SurveyModelResponse(
        userId: json["user_id"],
        surveyId: json["survey_id"],
        points: json["points"],
        answers: List<AnswerModelReponse>.from(
            json["answers"].map((x) => AnswerModelReponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "survey_id": surveyId,
        "points": points,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}
