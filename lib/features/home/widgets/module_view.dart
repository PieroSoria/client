import 'package:puntos_client/features/answer_polls/screens/answer_polls_screen.dart';
import 'package:puntos_client/features/home/screens/home_screen.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/images.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:puntos_client/common/widgets/address_widget.dart';
import 'package:puntos_client/common/widgets/custom_ink_well.dart';
import 'package:puntos_client/features/banner/controllers/banner_controller.dart';
import 'package:puntos_client/features/location/controllers/location_controller.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/features/address/controllers/address_controller.dart';
import 'package:puntos_client/features/address/domain/models/address_model.dart';
import 'package:puntos_client/helper/address_helper.dart';
import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:puntos_client/common/widgets/custom_image.dart';
import 'package:puntos_client/common/widgets/custom_loader.dart';
import 'package:puntos_client/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/home/widgets/banner_view.dart';
import 'package:puntos_client/features/home/widgets/popular_store_view.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;
  const ModuleView({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<BannerController>(builder: (bannerController) {
          return const BannerView(isFeatured: true);
        }),
        splashController.moduleList != null
            ? splashController.moduleList!.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: (1 / 1),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: splashController.moduleList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 0.15,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            )
                          ],
                        ),
                        child: CustomInkWell(
                          onTap: () =>
                              splashController.switchModule(index, true),
                          radius: Dimensions.radiusDefault,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                child: CustomImage(
                                  image:
                                      '${splashController.moduleList![index].iconFullUrl}',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Center(
                                child: Text(
                                  splashController
                                      .moduleList![index].moduleName!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall),
                      child: Text('no_module_found'.tr),
                    ),
                  )
            : ModuleShimmer(isEnabled: splashController.moduleList == null),
        GetBuilder<AddressController>(
          builder: (locationController) {
            List<AddressModel?> addressList = [];
            if (AuthHelper.isLoggedIn() &&
                locationController.addressList != null) {
              addressList = [];
              bool contain = false;
              if (AddressHelper.getUserAddressFromSharedPref()!.id != null) {
                for (int index = 0;
                    index < locationController.addressList!.length;
                    index++) {
                  if (locationController.addressList![index].id ==
                      AddressHelper.getUserAddressFromSharedPref()!.id) {
                    contain = true;
                    break;
                  }
                }
              }
              if (!contain) {
                addressList.add(AddressHelper.getUserAddressFromSharedPref());
              }
              addressList.addAll(locationController.addressList!);
            }
            return (!AuthHelper.isLoggedIn() ||
                    locationController.addressList != null)
                ? addressList.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            child: TitleWidget(title: 'deliver_to'.tr),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: addressList.length,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeSmall,
                                  top: Dimensions.paddingSizeExtraSmall),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 300,
                                  padding: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall),
                                  child: AddressWidget(
                                    address: addressList[index],
                                    fromAddress: false,
                                    onTap: () {
                                      if (AddressHelper
                                                  .getUserAddressFromSharedPref()!
                                              .id !=
                                          addressList[index]!.id) {
                                        Get.dialog(const CustomLoaderWidget(),
                                            barrierDismissible: false);
                                        Get.find<LocationController>()
                                            .saveAddressAndNavigate(
                                          addressList[index],
                                          false,
                                          null,
                                          false,
                                          ResponsiveHelper.isDesktop(context),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()
                : AddressShimmer(
                    isEnabled: AuthHelper.isLoggedIn() &&
                        locationController.addressList == null);
          },
        ),
        const PopularStoreView(isPopular: false, isFeatured: true),
        // const ListSurveysWisget(),
        const SizedBox(height: 120),
      ],
    );
  }
}

class ListSurveysWisget extends StatelessWidget {
  const ListSurveysWisget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    const imageStc =
        'https://www.allrecipes.com/thmb/jxasvySbtNt0lDcuXwXGj_L0pBo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-518858391-2000-955fb0e2dbd64d008ec3628fd9988371.jpg';
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "smart_surveys".tr,
            style: robotoBold.copyWith(
                fontSize: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.fontSizeLarge
                    : Dimensions.fontSizeLarge),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 170,
            width: double.infinity,
            child: ListView.builder(
              itemCount: 5,
              itemExtent: 210,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = listSurvey[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 150,
                    width: 210,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.15),
                                blurRadius: 7,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: item.storeName,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                      children: [
                                        const WidgetSpan(
                                            child: SizedBox(width: 8)),
                                        WidgetSpan(
                                          child: Image.asset(
                                            Images.vereficationIcon,
                                            scale: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item.surveyName,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (isLoggedIn == true) {
                              Get.toNamed(
                                RouteHelper.smartSurveys,
                                arguments: [],
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlerDialogWidget();
                                },
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: (1 / 1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  const AddressShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding:
                    const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: isEnabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                height: 10,
                                width: 150,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
