class AnswerModelReponse {
  final int questionId;
  final int answerId;

  AnswerModelReponse({
    required this.questionId,
    required this.answerId,
  });

  AnswerModelReponse copyWith({
    int? questionId,
    int? answerId,
  }) =>
      AnswerModelReponse(
        questionId: questionId ?? this.questionId,
        answerId: answerId ?? this.answerId,
      );

  factory AnswerModelReponse.fromJson(Map<String, dynamic> json) =>
      AnswerModelReponse(
        questionId: json["question_id"],
        answerId: json["answer_id"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "answer_id": answerId,
      };
}
