import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/question_model.dart';
import 'package:puntos_client/features/smart_surveys/screens/widgets/grid_list_widget.dart';

class SurveysToAnswerPage extends StatelessWidget {
  const SurveysToAnswerPage({
    super.key,
    required this.list,
  });
  final List<QuestionModel> list;
  @override
  Widget build(BuildContext context) {
    return GridListWidget(
      onSeletectBool: true,
      list: list,
    );
  }
}
