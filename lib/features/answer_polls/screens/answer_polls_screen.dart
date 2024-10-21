import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/common/widgets/not_logged_in_screen.dart';
import 'package:puntos_client/features/profile/controllers/profile_controller.dart';
import 'package:puntos_client/features/smart_surveys/controllers/survey_list_controller.dart';
import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/images.dart';

class AnswerPollsScreen extends StatefulWidget {
  const AnswerPollsScreen({super.key});

  @override
  State<AnswerPollsScreen> createState() => _AnswerPollsScreenState();
}

class _AnswerPollsScreenState extends State<AnswerPollsScreen> {
  final ProfileController controllerProfile = Get.find<ProfileController>();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null).then((_) {
      initCall();
    });
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<SurveyListController>().getAllSurveys(
          userId: controllerProfile.userInfoModel!.id.toString());
    }
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd, MMMM y', 'es');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    final ProfileController controllerProfile = Get.find<ProfileController>();

    return GetBuilder<SurveyListController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(title: 'answer_polls'.tr),
          endDrawerEnableOpenDragGesture: false,
          body: isLoggedIn
              ? Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.surveyList.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        Get.find<SurveyListController>().getAllSurveys(
                          userId:
                              controllerProfile.userInfoModel!.id.toString(),
                        );
                      },
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Aun no hay encuestas',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        Get.find<SurveyListController>().getAllSurveys(
                          userId:
                              controllerProfile.userInfoModel!.id.toString(),
                        );
                      },
                      child: ListView.builder(
                        itemCount: controller.surveyList.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final item = controller.surveyList[index];
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.toNamed(
                                      RouteHelper.survey,
                                      arguments: [
                                        item.title,
                                        item.questions,
                                      ],
                                    );
                                    Get.toNamed(RouteHelper.survey);
                                    controller.updateSurveyModelResponse(
                                      surveyId: item.id,
                                      points: 30,
                                    );
                                  },
                                  leading: item.urlimage.isNotEmpty
                                      ? Image.network(
                                          item.urlimage,
                                          height: 10,
                                          cacheHeight: 10,
                                        )
                                      : Image.asset(
                                          Images.house,
                                          height: 25,
                                          scale: 0.1,
                                          width: 25,
                                        ),
                                  title: Text(
                                    item.title,
                                  ),
                                  subtitle: Text(
                                    formatDateTime(item.createdAt),
                                  ),
                                  trailing: SizedBox(
                                    width: 60,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("${item.questions.length}"),
                                        Image.asset(
                                          Images.answerPollsIcon,
                                          height: 16,
                                          width: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                })
              : NotLoggedInScreen(callBack: (bool value) {
                  initCall();
                  setState(() {});
                }),
        );
      },
    );
  }
}

class Survey {
  final String surveyName;
  final String storeName;
  final int points;

  Survey(
      {required this.surveyName,
      required this.storeName,
      required this.points});
}

final listSurvey = [
  Survey(
      surveyName: 'Customer Satisfaction',
      storeName: 'Super Store',
      points: 25),
  Survey(surveyName: 'Product Feedback', storeName: 'Tech Shop', points: 15),
  Survey(surveyName: 'Service Quality', storeName: 'Fashion Hub', points: 30),
  Survey(
      surveyName: 'Website Usability', storeName: 'Grocery Mart', points: 20),
  Survey(surveyName: 'New Product Ideas', storeName: 'Book World', points: 18),
  Survey(surveyName: 'Brand Awareness', storeName: 'Pet Supplies', points: 12),
  Survey(
      surveyName: 'Customer Experience',
      storeName: 'Home Essentials',
      points: 22),
  Survey(
      surveyName: 'Market Research', storeName: 'Electronics Plus', points: 28),
  Survey(
      surveyName: 'Employee Satisfaction',
      storeName: 'Toy Kingdom',
      points: 17),
  Survey(surveyName: 'Event Feedback', storeName: 'Beauty Shop', points: 24),
  Survey(
      surveyName: 'Price Sensitivity', storeName: 'Fitness Zone', points: 10),
  Survey(
      surveyName: 'Service Improvement',
      storeName: 'Garden Center',
      points: 19),
  Survey(
      surveyName: 'Shopping Experience',
      storeName: 'Furniture Depot',
      points: 26),
  Survey(surveyName: 'Product Usage', storeName: 'Sports Arena', points: 30),
  Survey(
      surveyName: 'Loyalty Program', storeName: 'Automotive Parts', points: 11),
  Survey(
      surveyName: 'Social Media Impact',
      storeName: 'Pharmacy Store',
      points: 21),
  Survey(
      surveyName: 'Competitor Analysis', storeName: 'Kids Corner', points: 13),
  Survey(
      surveyName: 'Advertising Effectiveness',
      storeName: 'Music Lounge',
      points: 29),
  Survey(surveyName: 'Purchase Intentions', storeName: 'Gift Shop', points: 14),
  Survey(
      surveyName: 'Customer Retention',
      storeName: 'Office Supplies',
      points: 16),
];
