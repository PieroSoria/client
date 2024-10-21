import 'dart:convert';

class AnswerModel {
  final int id;
  final String answerText;

  AnswerModel({
    required this.id,
    required this.answerText,
  });
  factory AnswerModel.fromJson(String source) {
    Map<String, dynamic> map = jsonDecode(source);
    return AnswerModel.fromMap(map);
  }
  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      id: map['id'] ?? -1,
      answerText: map['answer_text'] ?? '',
    );
  }

  static List<AnswerModel> listJsontoModel(List<dynamic> list) {
    // Iterable iterable = jsonDecode(source);
    return List<AnswerModel>.from(
        list.map((item) => AnswerModel.fromMap(item)));
  }

  Map<String, dynamic> toAnswerJson() => {
        'id': id,
        'answer_text': answerText,
      };
}
