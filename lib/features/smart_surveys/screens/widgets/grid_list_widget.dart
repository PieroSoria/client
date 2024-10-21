import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/smart_surveys/domain/models/question_model.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';

class GridListWidget extends StatelessWidget {
  const GridListWidget({
    super.key,
    required this.onSeletectBool,
    required this.list,
  });

  final List<QuestionModel> list;
  final bool onSeletectBool;

  @override
  Widget build(BuildContext context) {
    const imageStc =
        'https://www.allrecipes.com/thmb/jxasvySbtNt0lDcuXwXGj_L0pBo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-518858391-2000-955fb0e2dbd64d008ec3628fd9988371.jpg';
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.15),
                blurRadius: 5,
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      blurRadius: 7,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 220,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.network(
                            imageStc,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: item.questionText,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: item.questionText,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).disabledColor),
                              children: [
                                const WidgetSpan(child: SizedBox(width: 8)),
                                WidgetSpan(
                                  child: Image.asset(
                                    Images.walletDebitIcon,
                                    scale: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Get.toNamed(
                    RouteHelper.survey,
                    arguments: item.answers,
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
