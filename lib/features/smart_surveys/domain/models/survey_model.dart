import 'dart:convert';

import 'package:puntos_client/features/smart_surveys/domain/models/question_model.dart';

class SurveyModel {
  final int id;
  final String title;
  final int vendorId;
  final int categoryId;
  final String points;
  final String urlimage;
  final DateTime createdAt;
  final List<QuestionModel> questions;

  SurveyModel({
    required this.id,
    required this.title,
    required this.vendorId,
    required this.categoryId,
    required this.points,
    required this.urlimage,
    required this.createdAt,
    required this.questions,
  });

  SurveyModel copyWith({
    int? id,
    String? title,
    int? vendorId,
    int? categoryId,
    String? points,
    String? urlimage,
    DateTime? createdAt,
    List<QuestionModel>? questions,
  }) =>
      SurveyModel(
        id: id ?? this.id,
        title: title ?? this.title,
        vendorId: vendorId ?? this.vendorId,
        categoryId: categoryId ?? this.categoryId,
        points: points ?? this.points,
        urlimage: urlimage ?? this.urlimage,
        questions: questions ?? this.questions,
        createdAt: createdAt ?? this.createdAt,
      );

  factory SurveyModel.fromJson(String source) {
    Map<String, dynamic> map = jsonDecode(source);
    return SurveyModel.fromMap(map);
  }

  factory SurveyModel.fromMap(Map<String, dynamic> map) {
    return SurveyModel(
      id: map['id'] ?? -1,
      vendorId: map['id'] ?? -1,
      title: map['title'] ?? 'no-title-survey',
      questions: QuestionModel.listFromJson(map['questions']),
      categoryId: map['category_id'] ?? -1,
      points: map['points'] ?? '',
      urlimage: map['urlimage'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }
  static List<SurveyModel> listFromJson(List<dynamic> source) {
    // Iterable iterable = jsonDecode(source);

    return source.map((map) => SurveyModel.fromMap(map)).toList();

    // return List<SurveyModel>.from(
    //     iterable.map((survey) => SurveyModel.fromMap(survey)));
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "vendor_id": vendorId,
  //       "category_id": categoryId,
  //       "points": points,
  //       "urlimage": urlimage,
  //       "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  //     };
}
