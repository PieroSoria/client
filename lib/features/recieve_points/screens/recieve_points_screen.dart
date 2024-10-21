import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/common/widgets/custom_snackbar.dart';
import 'package:puntos_client/common/widgets/footer_view.dart';
import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:puntos_client/common/widgets/no_data_screen.dart';
import 'package:puntos_client/common/widgets/not_logged_in_screen.dart';
import 'package:puntos_client/common/widgets/web_page_title_widget.dart';
import 'package:puntos_client/features/coupon/controllers/coupon_controller.dart';
import 'package:puntos_client/features/coupon/widgets/coupon_card_widget.dart';
import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/util/dimensions.dart';

class RecievePointsScreen extends StatefulWidget {
  const RecievePointsScreen({super.key});

  @override
  State<RecievePointsScreen> createState() => _RecievePointsScreenState();
}

class _RecievePointsScreenState extends State<RecievePointsScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<CouponController>().getCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'receive_points'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? GetBuilder<CouponController>(builder: (couponController) {
              return couponController.couponList != null
                  ? couponController.couponList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await couponController.getCouponList();
                          },
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                WebScreenTitleWidget(title: 'coupon'.tr),
                                Center(
                                    child: FooterView(
                                  child: SizedBox(
                                      width: Dimensions.webMaxWidth,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: ResponsiveHelper
                                                  .isDesktop(context)
                                              ? 3
                                              : ResponsiveHelper.isTab(context)
                                                  ? 2
                                                  : 1,
                                          mainAxisSpacing:
                                              Dimensions.paddingSizeSmall,
                                          crossAxisSpacing:
                                              Dimensions.paddingSizeSmall,
                                          childAspectRatio:
                                              ResponsiveHelper.isMobile(context)
                                                  ? 3
                                                  : 3,
                                        ),
                                        itemCount:
                                            couponController.couponList!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeLarge),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: couponController
                                                      .couponList![index]
                                                      .code!));
                                              if (!ResponsiveHelper.isDesktop(
                                                  context)) {
                                                showCustomSnackBar(
                                                    'coupon_code_copied'.tr,
                                                    isError: false);
                                              }
                                            },
                                            child: CouponCardWidget(
                                                coupon: couponController
                                                    .couponList![index],
                                                index: index),
                                          );
                                        },
                                      )),
                                ))
                              ],
                            ),
                          ),
                        )
                      : NoDataScreen(
                          text: 'no_coupon_found'.tr, showFooter: true)
                  : const Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(callBack: (bool value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
