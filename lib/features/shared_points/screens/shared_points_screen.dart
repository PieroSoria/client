import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:puntos_client/common/widgets/not_logged_in_screen.dart';
import 'package:puntos_client/features/coupon/controllers/coupon_controller.dart';

import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:share_plus/share_plus.dart';
import '../../../util/app_constants.dart';
import '../../profile/controllers/profile_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../splash/controllers/splash_controller.dart';
import 'scan_qr_screen.dart';

class SharedPointsScreen extends StatefulWidget {
  const SharedPointsScreen({super.key});

  @override
  State<SharedPointsScreen> createState() => _SharedPointsScreenState();
}

class _SharedPointsScreenState extends State<SharedPointsScreen> {
  ScrollController scrollController = ScrollController();
  final ProfileController profileController = Get.find<ProfileController>(); //
  final CouponController couponController = Get.find<CouponController>(); //

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn() && profileController.userInfoModel == null) {
      couponController.getCouponList();
      profileController.getUserInfo();
    }
  }

  // void initCall() {
  //   if (AuthHelper.isLoggedIn()) {
  //     Get.find<CouponController>().getCouponList();
  //   }
  // }

  /* @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'send_and_share_points'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: QrImageView(
                      data: '1234567890',
                      version: QrVersions.auto,
                      size: 280.0,
                      eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      // backgroundColor: Colors.white,
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "refer_and_earn".tr,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 134,
                    width: 327,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 38,
                          width: 295,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0XFFF5F3F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Text(
                                  "puntossmart.com/refier30",
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF111719),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      const ClipboardData(
                                        text: "h",
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Color(0XFF111719),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 295,
                          height: 48,
                          child: Stack(
                            children: [
                              Container(
                                width: 295,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0XFF30384F),
                                  borderRadius: BorderRadius.circular(28.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "share".tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SvgPicture.asset(Images.shareSvg)
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    28.5), // Borde redondeado para el splash
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28.5),
                                  onTap: () {
                                    // Acción al hacer tap
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ))
          : NotLoggedInScreen(callBack: (bool value) {
              initCall();
              setState(() {});
            }),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'send_and_share_points'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: QrImageView(
                      data:
                          '${profileController.userInfoModel != null ? profileController.userInfoModel!.refCode : ''}', //'1234567890',
                      version: QrVersions.auto,
                      size: 280.0,
                      eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      // backgroundColor: Colors.white,
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "refer_and_earn".tr,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 185, //134
                    width: 327, //327
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 38,
                          width: 295,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0XFFF5F3F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Text(
                                  '${profileController.userInfoModel != null ? profileController.userInfoModel!.refCode : ''}', //"puntossmart.com/refier30"
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0XFF111719),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            "${profileController.userInfoModel != null ? profileController.userInfoModel!.refCode : ''}",
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Color(0XFF111719),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 295,
                          height: 48,
                          child: Stack(
                            children: [
                              Container(
                                width: 295,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0XFF30384F),
                                  borderRadius: BorderRadius.circular(28.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "share".tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    //SvgPicture.asset(Images.shareSvg),
                                    const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    28.5), // Borde redondeado para el splash
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28.5),
                                  onTap: () {
                                    // Acción al hacer tap
                                    Share.share(
                                      Get.find<SplashController>()
                                                  .configModel
                                                  ?.appUrlAndroid !=
                                              null
                                          ? '${AppConstants.appName} ${'referral_code'.tr}: ${profileController.userInfoModel!.refCode} \n${'download_app_from_this_link'.tr}: ${Get.find<SplashController>().configModel?.appUrlAndroid}'
                                          : '${AppConstants.appName} ${'referral_code'.tr}: ${profileController.userInfoModel!.refCode}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 295,
                          height: 48,
                          child: Stack(
                            children: [
                              Container(
                                width: 295,
                                height: 48,
                                decoration: BoxDecoration(
                                  //color: const Color(0XFF30384F),
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(28.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enviar Puntos Smart",
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w400,
                                        color: Colors
                                            .white /*Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color*/
                                        ,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SvgPicture.asset(Images.shareSvg)
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    28.5), // Borde redondeado para el splash
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28.5),
                                  onTap: () {
                                    // Acción al hacer tap
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QRScanScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
          : NotLoggedInScreen(callBack: (bool value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
