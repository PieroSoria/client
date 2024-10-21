import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/location/controllers/location_controller.dart';
import 'package:puntos_client/features/notification/controllers/notification_controller.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/helper/address_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';

class ParcelAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final bool? backButton;
  const ParcelAppBarWidget({super.key, this.backButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      shape: Border(
        bottom: BorderSide(
            width: .4,
            color: Theme.of(context).primaryColorLight.withOpacity(.2)),
      ),
      elevation: 0,
      leadingWidth: backButton! ? Dimensions.paddingSizeLarge : 0,
      title: GetBuilder<SplashController>(builder: (splashController) {
        return Row(children: [
          (splashController.module != null &&
                  splashController.configModel!.module == null)
              ? InkWell(
                  onTap: () => splashController.removeModule(),
                  child: Image.asset(Images.moduleIcon,
                      height: 25,
                      width: 25,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                )
              : const SizedBox(),
          SizedBox(
              width: (splashController.module != null &&
                      splashController.configModel!.module == null)
                  ? Dimensions.paddingSizeSmall
                  : 0),
          Expanded(
              child: InkWell(
            onTap: () =>
                Get.find<LocationController>().navigateToLocationScreen('home'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeSmall,
              ),
              child:
                  GetBuilder<LocationController>(builder: (locationController) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AddressHelper.getUserAddressFromSharedPref()!
                            .addressType!
                            .tr,
                        style: robotoMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(children: [
                        Flexible(
                          child: Text(
                            AddressHelper.getUserAddressFromSharedPref()!
                                .address!,
                            style: robotoRegular.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.expand_more,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            size: 18),
                      ]),
                    ]);
              }),
            ),
          )),
          InkWell(
            child: GetBuilder<NotificationController>(
                builder: (notificationController) {
              return Stack(children: [
                Icon(CupertinoIcons.bell,
                    size: 25,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
                notificationController.hasNotification
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1, color: Theme.of(context).cardColor),
                          ),
                        ))
                    : const SizedBox(),
              ]);
            }),
            onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
        ]);
      }),
    );
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 56);
}