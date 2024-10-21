import 'package:flutter/material.dart';
import 'package:puntos_client/features/smart_surveys/screens/widgets/grid_list_widget.dart';

class SurveysAnsweerPage extends StatelessWidget {
  const SurveysAnsweerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const GridListWidget(
      onSeletectBool: false,
      list: [],
    );
  }
}
