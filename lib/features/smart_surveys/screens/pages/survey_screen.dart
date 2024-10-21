import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/features/profile/controllers/profile_controller.dart';
import 'package:puntos_client/features/smart_surveys/controllers/survey_list_controller.dart';

import 'package:puntos_client/features/smart_surveys/domain/models/question_model.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/response_model/answer_model_response.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int? optionSelected;
  bool isSelected = false;
  int indexPage = 1;
  double valueProgess = 0;

  late PageController pageController1;
  late PageController pageController2;

  @override
  void initState() {
    pageController1 = PageController(initialPage: 0);
    pageController2 = PageController(initialPage: 0);

    super.initState();
  }

  void normalize(int value, int maxValue) {
    setState(() {
      valueProgess = value / maxValue;
    });
  }

  Map<int, int> selectedAnswerId = {};
  Map<int, int> selectedQuestionsId = {};

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = Get.arguments;

    final String title = arguments[0];
    final List<QuestionModel> questions = arguments[1];

    final size = MediaQuery.of(context).size;
    final SurveyListController controller = Get.find<SurveyListController>();
    final ProfileController controllerProfile = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0XFFF6F6F6),
      appBar: CustomAppBar(title: title.tr),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height,
              width: size.width,
              color: const Color(0XFFF6F6F6),
              // color: Colors.red,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: PageView.builder(
                  controller: pageController1,
                  itemCount: questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      indexPage = value + 1;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final item = questions[index];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: LinearProgressIndicator(
                                      value: valueProgess,
                                      minHeight: 15,
                                      backgroundColor: const Color(0XFFECECEC),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const Spacer(),
                                  Flexible(
                                    child: Text(
                                      "$indexPage/${questions.length}",
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  item.questionText.toString(),
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: item.answers.length,
                            itemBuilder: (context, indexx) {
                              final result = item.answers[indexx];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswerId[index] = result.id;
                                    selectedQuestionsId[index] = item.id;
                                    normalize(indexPage, questions.length);
                                    isSelected = true;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: selectedAnswerId[index] != result.id
                                        ? const Color(0XFFECECEC)
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      selectedAnswerId[index] != result.id
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color:
                                                      const Color(0XFF737B92),
                                                  width: 2.0,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              Images.checkList,
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            ),
                                      const SizedBox(width: 20),
                                      Text(
                                        result.answerText,
                                        style: robotoMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge,
                                          fontWeight: FontWeight.w400,
                                          color: selectedAnswerId[index] ==
                                                  result.id
                                              ? Colors.white
                                              : const Color(0XFF737B92),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtonWidget(
                      sizeWith: MediaQuery.of(context).size.width * 0.4,
                      title: 'Anterior',
                      isButtonActive: indexPage == 0 ? false : true,
                      next: () {
                        pageController1.previousPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutSine,
                        );
                        pageController2.previousPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutSine,
                        );
                      },
                    ),
                    indexPage == questions.length
                        ? CustomButtonWidget(
                            sizeWith: MediaQuery.of(context).size.width * 0.4,
                            title: "Enviar",
                            isButtonActive: isSelected,
                            next: () {
                              List<AnswerModelReponse> answers =
                                  selectedAnswerId.entries.map((entry) {
                                int questionIndex = entry.key;
                                int answerId = entry.value;
                                int questionId =
                                    selectedQuestionsId[questionIndex]!;

                                return AnswerModelReponse(
                                  questionId: questionId,
                                  answerId: answerId,
                                );
                              }).toList();

                              controller.updateSurveyModelResponse(
                                userId: controllerProfile.userInfoModel!.id,
                                answers: answers,
                              );

                              controller
                                  .sendSurvey(
                                      response:
                                          controller.surveyModelResponse.value)
                                  .then((_) {
                                Get.snackbar(
                                  "Éxito",
                                  '¡Encuesta enviada exitosamente!',
                                );
                                controller.getAllSurveys(
                                    
                                    userId: controllerProfile.userInfoModel!.id
                                        .toString());
                              }).catchError((error) {
                                // Acción en caso de error
                                Get.snackbar("Error", '¡Encuesta no enviada!');
                              });
                            },
                          )
                        : CustomButtonWidget(
                            sizeWith: MediaQuery.of(context).size.width * 0.4,
                            title: 'Siguiente',
                            isButtonActive: isSelected,
                            next: () {
                              pageController1.nextPage(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutSine,
                              );
                              pageController2.nextPage(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutSine,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.sizeWith,
    required this.title,
    required this.isButtonActive,
    required this.next,
  });

  final bool isButtonActive;
  final double sizeWith;
  final String title;
  final VoidCallback next;

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialButton(
  //     disabledColor: Colors.grey.withOpacity(0.3),
  //     height: 60,
  //     minWidth: sizeWith,
  //     onPressed: isButtonActive ? next : null,
  //     color: Theme.of(context).primaryColor.withOpacity(0.6),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Text(
  //       title.tr,
  //       style: robotoMedium.copyWith(
  //         fontSize: Dimensions.fontSizeExtraLarge,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizeWith,
      child: ElevatedButton(
        onPressed: isButtonActive ? next : null, // Desactiva si no es activo
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonActive
              ? Theme.of(context).primaryColor
              : Colors.grey, // Color de fondo cuando está desactivado
          foregroundColor: Colors.white, // Color del texto
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12, // Tamaño del botón
          ),
          elevation: 0, // Sin sombra para que se vea plano
        ),
        child: Text(title),
      ),
    );
  }
}
