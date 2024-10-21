import 'dart:convert';

import 'package:puntos_client/features/smart_surveys/domain/models/answer_model.dart';

class QuestionModel {
  final int id;
  final String questionText;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  QuestionModel copyWith({
    int? id,
    String? questionText,
    List<AnswerModel>? answers,
  }) =>
      QuestionModel(
        id: id ?? this.id,
        questionText: questionText ?? this.questionText,
        answers: answers ?? this.answers,
      );
  factory QuestionModel.fromJson(String source) {
    Map<String, dynamic> map = jsonDecode(source);
    return QuestionModel.fromMap(map);
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) => QuestionModel(
        id: map['id'] ?? -1,
        questionText: map['question_text'] ?? '',
        answers: AnswerModel.listJsontoModel(map['answers']),
      );
  static List<QuestionModel> listFromJson(List<dynamic> list) {
    return List<QuestionModel>.from(
        list.map((question) => QuestionModel.fromMap(question)));
  }
  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "question_text": questionText,
  //     "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  // };
}
