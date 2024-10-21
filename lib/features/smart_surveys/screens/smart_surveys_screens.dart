import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/question_model.dart';

import 'package:puntos_client/features/smart_surveys/screens/pages/surveys_answer_page.dart';
import 'package:puntos_client/features/smart_surveys/screens/pages/surveys_to_answer_page.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/styles.dart';

class SmartSurveysScreens extends StatefulWidget {
  const SmartSurveysScreens({super.key});

  @override
  State<SmartSurveysScreens> createState() => _SmartSurveysScreensState();
}

class _SmartSurveysScreensState extends State<SmartSurveysScreens> {
  late PageController pageController;
  int pageSelected = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as List?;

    final String title =
        arguments != null && arguments.isNotEmpty && arguments[0] != null
            ? arguments[0]
            : 'Default Title';

    final List<QuestionModel> questions =
        arguments != null && arguments.length > 1 && arguments[1] != null
            ? arguments[1]
            : [];

    return Scaffold(
      appBar: CustomAppBar(title: title.tr),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      listTabBar.length,
                      (index) {
                        final item = listTabBar[index];
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                pageSelected = index;
                              });
                              pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInQuart,
                              );
                            },
                            child: AnimatedDefaultTextStyle(
                              style: robotoMedium.copyWith(
                                fontSize: pageSelected == index
                                    ? Dimensions.fontSizeLarge
                                    : Dimensions.fontSizeSmall,
                                color: pageSelected == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.withOpacity(0.3),
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AnimatedAlign(
                  alignment: pageSelected == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    height: 3,
                    color: Theme.of(context).primaryColor,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.3),
                  width: double.infinity,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  pageSelected = value;
                });
              },
              children: [
                SurveysToAnswerPage(list: questions),
                const SurveysAnsweerPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> listTabBar = [
  'Encuestas',
  'Mis Encuestas',
];
