import 'dart:async';
import 'package:puntos_client/features/auth/screens/sign_in_screen.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/common/controllers/theme_controller.dart';
import 'package:puntos_client/features/location/domain/models/zone_response_model.dart';
import 'package:puntos_client/features/auth/controllers/auth_controller.dart';
import 'package:puntos_client/features/order/controllers/order_controller.dart';
import 'package:puntos_client/helper/address_helper.dart';
import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:puntos_client/common/widgets/custom_button.dart';

import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:puntos_client/common/widgets/web_menu_bar.dart';
import 'package:puntos_client/features/checkout/widgets/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  final String? contactPersonNumber;
  final bool? createAccount;
  final String guestId;
  const OrderSuccessfulScreen(
      {super.key,
      required this.orderID,
      this.contactPersonNumber,
      this.createAccount = false,
      required this.guestId});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  bool? _isCashOnDeliveryActive = false;
  String? orderId;
  late PageController pageController;
  int indexPage = 0;
  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0);

    orderId = widget.orderID!;
    if (widget.orderID != null) {
      if (widget.orderID!.contains('?')) {
        var parts = widget.orderID!.split('?');
        String id = parts[0].trim();
        orderId = id;
      }
    }

    Get.find<OrderController>().trackOrder(orderId.toString(), null, false,
        contactNumber: widget.contactPersonNumber);
  }

  Map<int, int> selectedAnswers = {};
  double averageScore = 0;

  void calculateAverageScore() {
    double totalScore = 0;
    int numQuestionsAnswered = 0;

    selectedAnswers.forEach((questionIndex, answerIndex) {
      totalScore +=
          surveyQuestions[questionIndex]['answers'][answerIndex]['score'];
      numQuestionsAnswered++;
    });

    if (numQuestionsAnswered > 0) {
      averageScore = totalScore / numQuestionsAnswered;
    } else {
      averageScore = 0;
    }

    setState(() {});
  }

  bool allQuestionsAnswered() {
    return selectedAnswers.length == surveyQuestions.length;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        await Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<OrderController>(
          builder: (orderController) {
            double total = 0;
            bool success = true;
            bool parcel = false;
            double? maximumCodOrderAmount;
            if (orderController.trackModel != null) {
              total = ((orderController.trackModel!.orderAmount! / 100) *
                  Get.find<SplashController>()
                      .configModel!
                      .loyaltyPointItemPurchasePoint!);
              success = orderController.trackModel!.paymentStatus == 'paid' ||
                  orderController.trackModel!.paymentMethod ==
                      'cash_on_delivery' ||
                  orderController.trackModel!.paymentMethod ==
                      'partial_payment';
              parcel = orderController.trackModel!.paymentMethod == 'parcel';
              for (ZoneData zData
                  in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
                for (Modules m in zData.modules!) {
                  if (m.id == Get.find<SplashController>().module!.id) {
                    maximumCodOrderAmount = m.pivot!.maximumCodOrderAmount;
                    break;
                  }
                }
                if (zData.id ==
                    AddressHelper.getUserAddressFromSharedPref()!.zoneId) {
                  _isCashOnDeliveryActive = zData.cashOnDelivery;
                }
              }

              if (!success &&
                  !Get.isDialogOpen! &&
                  orderController.trackModel!.orderStatus != 'canceled' &&
                  Get.currentRoute.startsWith(RouteHelper.orderSuccess)) {
                Future.delayed(const Duration(seconds: 1), () {
                  Get.dialog(
                      PaymentFailedDialog(
                        orderID: orderId,
                        isCashOnDelivery: _isCashOnDeliveryActive,
                        orderAmount: total,
                        maxCodOrderAmount: maximumCodOrderAmount,
                        orderType: parcel ? 'parcel' : 'delivery',
                        guestId: widget.guestId,
                      ),
                      barrierDismissible: false);
                });
              }
            }

            return orderController.trackModel != null
                ? PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        indexPage = value;
                      });
                    },
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Text(
                              'rate_the_commerce'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeOverLarge,
                              ),
                            ).paddingOnly(
                              top: kToolbarHeight,
                              right: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    size: 50,
                                    color: index < averageScore
                                        ? Colors.amber // Estrella llena
                                        : Colors.grey,
                                  );
                                })
                              ],
                            ).paddingOnly(top: 16, right: 16),
                            Text(
                              averageScore.toStringAsFixed(1),
                              style: robotoMedium.copyWith(
                                fontSize: 30,
                                color: Colors.amber,
                              ),
                            ).paddingOnly(top: 16),
                            const Divider().paddingOnly(top: 16, right: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: surveyQuestions.length,
                                itemExtent: 100,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, questionIndex) {
                                  final item = surveyQuestions[questionIndex];
                                  final answers = item['answers'];
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item['question'],
                                            style: robotoMedium.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 2,
                                          ).paddingSymmetric(horizontal: 6),
                                        ),
                                        SizedBox(
                                          height: 45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ...List.generate(
                                                answers.length,
                                                (answerIndex) {
                                                  final itemAnswer =
                                                      answers[answerIndex]
                                                          ['text'];
                                                  bool isSelected =
                                                      selectedAnswers[
                                                              questionIndex] ==
                                                          answerIndex;
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAnswers[
                                                                questionIndex] =
                                                            answerIndex;
                                                      });

                                                      calculateAverageScore();
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        itemAnswer,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: isSelected
                                                              ? Dimensions
                                                                  .fontSizeSmall
                                                              : Dimensions
                                                                  .fontSizeExtraSmall,
                                                        ),
                                                      ),
                                                    ),
                                                  ).paddingOnly(right: 8);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            CustomButton(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 300
                                  : double.infinity,
                              buttonText: 'Siguiente'.tr,
                              onPressed: allQuestionsAnswered()
                                  ? () {
                                      pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    }
                                  : null,
                            ).paddingOnly(right: 16, bottom: 16, top: 12)
                          ],
                        ).paddingOnly(left: 16),
                      ),
                      SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                success ? Images.checked : Images.warning,
                                width: 100,
                                height: 100),
                            const SizedBox(
                              height: Dimensions.paddingSizeLarge,
                            ),
                            Text(
                              success
                                  ? parcel
                                      ? 'you_placed_the_parcel_request_successfully'
                                          .tr
                                      : 'you_placed_the_cupon_successfully'.tr
                                  : 'your_order_is_failed_to_place'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeSmall,
                            ),
                            widget.createAccount!
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeSmall),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'and_create_account_successfully'
                                                .tr,
                                            style: robotoMedium,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (ResponsiveHelper.isDesktop(
                                                  context)) {
                                                Get.dialog(const SignInScreen(
                                                    exitFromApp: false,
                                                    backFromThis: false));
                                              } else {
                                                Get.toNamed(
                                                    RouteHelper.getSignInRoute(
                                                        RouteHelper.splash));
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Text('sign_in'.tr,
                                                  style: robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ),
                                          ),
                                        ]),
                                  )
                                : const SizedBox(),
                            AuthHelper.isGuestLoggedIn()
                                ? SelectableText(
                                    '${'order_id'.tr}: $orderId',
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor),
                                  )
                                : const SizedBox(),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: Dimensions.paddingSizeLarge,
                            //       vertical: Dimensions.paddingSizeSmall),
                            //   child: Text(
                            //     success
                            //         ? parcel
                            //             ? 'your_parcel_request_is_placed_successfully'
                            //                 .tr
                            //             : 'your_order_is_placed_successfully'.tr
                            //         : 'your_order_is_failed_to_place_because'
                            //             .tr,
                            //     style: robotoMedium.copyWith(
                            //         fontSize: Dimensions.fontSizeSmall,
                            //         color: Theme.of(context).disabledColor),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            ResponsiveHelper.isDesktop(context) &&
                                    (success &&
                                        Get.find<SplashController>()
                                                .configModel!
                                                .loyaltyPointStatus ==
                                            1 &&
                                        total.floor() > 0) &&
                                    AuthHelper.isLoggedIn()
                                ? Column(
                                    children: [
                                      Image.asset(
                                          Get.find<ThemeController>().darkTheme
                                              ? Images.congratulationDark
                                              : Images.congratulationLight,
                                          width: 150,
                                          height: 150),
                                      Text('congratulations'.tr,
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge)),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeLarge),
                                        child: Text(
                                          '${'you_have_earned'.tr} ${total.floor().toString()} ${'points_it_will_add_to'.tr}',
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color: Theme.of(context)
                                                  .disabledColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: CustomButton(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 300
                                    : double.infinity,
                                buttonText: 'back_to_home'.tr,
                                onPressed: () {
                                  if (AuthHelper.isLoggedIn()) {
                                    Get.find<AuthController>().saveEarningPoint(
                                        total.toStringAsFixed(0));
                                  }
                                  Get.offAllNamed(
                                      RouteHelper.getInitialRoute());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> surveyQuestions = [
  {
    'question': '¿Cómo calificarías el servicio?',
    'answers': [
      {'text': 'Excelente', 'score': 5},
      {'text': 'Bueno', 'score': 4},
      {'text': 'Regular', 'score': 3},
      {'text': 'Malo', 'score': 2},
      {'text': 'Terrible', 'score': 1}
    ]
  },
  {
    'question': '¿El personal fue amable?',
    'answers': [
      {'text': 'Siempre', 'score': 5},
      {'text': 'A menudo', 'score': 4},
      {'text': 'A veces', 'score': 3},
      {'text': 'Rara vez', 'score': 2},
      {'text': 'Nunca', 'score': 1}
    ]
  },
  {
    'question': '¿Qué tan limpia estaba la zona?',
    'answers': [
      {'text': 'Muy limpia', 'score': 5},
      {'text': 'Limpia', 'score': 4},
      {'text': 'Neutral', 'score': 3},
      {'text': 'Sucia', 'score': 2},
      {'text': 'Muy sucia', 'score': 1}
    ]
  },
  {
    'question': '¿La calidad fue la esperada?',
    'answers': [
      {'text': 'Mejor', 'score': 5},
      {'text': 'Buena', 'score': 4},
      {'text': 'Adecuada', 'score': 3},
      {'text': 'Mala', 'score': 2},
      {'text': 'Muy mala', 'score': 1}
    ]
  },
  {
    'question': '¿Calidad-precio del producto?',
    'answers': [
      {'text': 'Excelente', 'score': 5},
      {'text': 'Buena', 'score': 4},
      {'text': 'Regular', 'score': 3},
      {'text': 'Mala', 'score': 2},
      {'text': 'Pésima', 'score': 1}
    ]
  },
  {
    'question': '¿Recomendarías el comercio?',
    'answers': [
      {'text': 'Definitivamente sí', 'score': 5},
      {'text': 'Probablemente sí', 'score': 4},
      {'text': 'Tal vez', 'score': 3},
      {'text': 'Probablemente no', 'score': 2},
      {'text': 'Definitivamente no', 'score': 1}
    ]
  }
];
