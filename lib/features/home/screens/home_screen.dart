import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gif/gif.dart';
import 'package:puntos_client/common/controllers/theme_controller.dart';
import 'package:puntos_client/common/widgets/custom_button.dart';

import 'package:puntos_client/features/banner/controllers/banner_controller.dart';
import 'package:puntos_client/features/brands/controllers/brands_controller.dart';
import 'package:puntos_client/features/home/controllers/advertisement_controller.dart';
import 'package:puntos_client/features/home/controllers/home_controller.dart';
import 'package:puntos_client/features/home/widgets/all_store_filter_widget.dart';
import 'package:puntos_client/features/home/widgets/cashback_logo_widget.dart';
import 'package:puntos_client/features/home/widgets/cashback_dialog_widget.dart';
import 'package:puntos_client/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:puntos_client/features/item/controllers/campaign_controller.dart';
import 'package:puntos_client/features/category/controllers/category_controller.dart';
import 'package:puntos_client/features/coupon/controllers/coupon_controller.dart';
import 'package:puntos_client/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:puntos_client/features/language/controllers/language_controller.dart';
import 'package:puntos_client/features/location/controllers/location_controller.dart';
import 'package:puntos_client/features/notification/controllers/notification_controller.dart';
import 'package:puntos_client/features/item/controllers/item_controller.dart';
import 'package:puntos_client/features/order/controllers/order_controller.dart';
import 'package:puntos_client/features/store/controllers/store_controller.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/features/profile/controllers/profile_controller.dart';
import 'package:puntos_client/features/address/controllers/address_controller.dart';
import 'package:puntos_client/features/home/screens/modules/food_home_screen.dart';
import 'package:puntos_client/features/home/screens/modules/grocery_home_screen.dart';
import 'package:puntos_client/features/home/screens/modules/pharmacy_home_screen.dart';
import 'package:puntos_client/features/home/screens/modules/shop_home_screen.dart';
import 'package:puntos_client/features/parcel/controllers/parcel_controller.dart';
import 'package:puntos_client/helper/address_helper.dart';
import 'package:puntos_client/helper/auth_helper.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/util/app_constants.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:puntos_client/common/widgets/item_view.dart';
import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:puntos_client/common/widgets/paginated_list_view.dart';
import 'package:puntos_client/common/widgets/web_menu_bar.dart';
import 'package:puntos_client/features/home/screens/web_new_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/home/widgets/module_view.dart';
import 'package:puntos_client/features/parcel/screens/parcel_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload, {bool fromModule = false}) async {
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: fromModule);
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        Get.find<FlashSaleController>().getFlashSale(reload, false);
        Get.find<BrandsController>().getBrandList();
      }
      Get.find<BannerController>().getPromotionalBannerList(reload);
      Get.find<ItemController>().getDiscountedItemList(reload, false, 'all');
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getBasicCampaignList(reload);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<ItemController>().getRecommendedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<StoreController>().getRecommendedStoreList();
      Get.find<AdvertisementController>().getAdvertisementList();
    }
    if (AuthHelper.isLoggedIn()) {
      Get.find<StoreController>()
          .getVisitAgainStoreList(fromModule: fromModule);
      await Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (AuthHelper.isLoggedIn()) {
        Get.find<AddressController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();
      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool searchBgShow = false;
  final GlobalKey _headerKey = GlobalKey();

  final scrollcarusel = ScrollController();

  @override
  void initState() {
    super.initState();
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
              false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        _showReferBottomSheet();
      }
    });

    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          AddressHelper.getUserAddressFromSharedPref()!.latitude,
          AddressHelper.getUserAddressFromSharedPref()!.longitude,
          false,
          updateInAddress: true);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(milliseconds: 800),
              () => Get.find<HomeController>().changeFavVisibility());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context)
        ? Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraLarge)),
              insetPadding: const EdgeInsets.all(22),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const ReferBottomSheetWidget(),
            ),
            useSafeArea: false,
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false))
        : showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            context: Get.context!,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                  topRight: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            builder: (context) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: const ReferBottomSheetWidget(),
              );
            },
          ).then((value) =>
            Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
            splashController.module == null &&
            splashController.configModel!.module == null;
        bool isParcel = splashController.module != null &&
            splashController.configModel!.moduleConfig!.module!.isParcel!;
        // bool isPharmacy = splashController.module != null &&
        //     splashController.module!.moduleType.toString() ==
        //         AppConstants.pharmacy;
        // bool isFood = splashController.module != null &&
        //     splashController.module!.moduleType.toString() == AppConstants.food;
        // bool isShop = splashController.module != null &&
        //     splashController.module!.moduleType.toString() ==
        //         AppConstants.ecommerce;
        // bool isGrocery = splashController.module != null &&
        //     splashController.module!.moduleType.toString() ==
        //         AppConstants.grocery;

        return GetBuilder<HomeController>(
          builder: (homeController) {
            final cashBackofferList = AuthHelper.isLoggedIn() &&
                homeController.cashBackOfferList != null &&
                homeController.cashBackOfferList!.isNotEmpty;
            return Scaffold(
              appBar: ResponsiveHelper.isDesktop(context)
                  ? const WebMenuBar()
                  : null,
              endDrawer: const MenuDrawer(),
              endDrawerEnableOpenDragGesture: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: isParcel
                  ? const ParcelCategoryScreen()
                  : bodyhomescreen(splashController, context, showMobileModule),
              floatingActionButton: cashBackofferList
                  ? homeController.showFavButton
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: 50.0,
                              right:
                                  ResponsiveHelper.isDesktop(context) ? 50 : 0),
                          child: InkWell(
                            onTap: () =>
                                Get.dialog(const CashBackDialogWidget()),
                            child: const CashBackLogoWidget(),
                          ),
                        )
                      : null
                  : null,
            );
          },
        );
      },
    );
  }

  SafeArea bodyhomescreen(
    SplashController splashController,
    BuildContext context,
    bool showMobileModule,
  ) {
    bool isLoggedIn2 = AuthHelper.isLoggedIn();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          splashController.setRefreshing(true);
          if (Get.find<SplashController>().module != null) {
            await Get.find<LocationController>().syncZoneData();
            await Get.find<BannerController>().getBannerList(true);
            if (splashController.module!.moduleType.toString() ==
                AppConstants.grocery) {
              await Get.find<FlashSaleController>().getFlashSale(true, true);
            }
            await Get.find<BannerController>().getPromotionalBannerList(true);
            await Get.find<ItemController>()
                .getDiscountedItemList(true, false, 'all');
            await Get.find<CategoryController>().getCategoryList(true);
            await Get.find<StoreController>()
                .getPopularStoreList(true, 'all', false);
            await Get.find<CampaignController>().getItemCampaignList(true);
            Get.find<CampaignController>().getBasicCampaignList(true);
            await Get.find<ItemController>()
                .getPopularItemList(true, 'all', false);
            await Get.find<StoreController>()
                .getLatestStoreList(true, 'all', false);
            await Get.find<ItemController>()
                .getReviewedItemList(true, 'all', false);
            await Get.find<StoreController>().getStoreList(1, true);
            Get.find<AdvertisementController>().getAdvertisementList();
            if (AuthHelper.isLoggedIn()) {
              await Get.find<ProfileController>().getUserInfo();
              await Get.find<NotificationController>()
                  .getNotificationList(true);
              Get.find<CouponController>().getCouponList();
            }
            if (splashController.module!.moduleType.toString() ==
                AppConstants.pharmacy) {
              Get.find<ItemController>().getBasicMedicine(true, true);
              Get.find<ItemController>().getCommonConditions(true);
            }
            if (splashController.module!.moduleType.toString() ==
                AppConstants.ecommerce) {
              await Get.find<FlashSaleController>().getFlashSale(true, true);
              Get.find<ItemController>()
                  .getFeaturedCategoriesItemList(true, true);
              Get.find<BrandsController>().getBrandList();
            }
          } else {
            await Get.find<BannerController>().getFeaturedBanner();
            await Get.find<SplashController>().getModules();
            if (AuthHelper.isLoggedIn()) {
              await Get.find<AddressController>().getAddressList();
            }
            await Get.find<StoreController>().getFeaturedStoreList();
          }
          splashController.setRefreshing(false);
        },
        child: ResponsiveHelper.isDesktop(context)
            ? WebNewHomeScreen(
                scrollController: _scrollController,
              )
            : CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  /// App Bar
                  sliverappbartitle(context, splashController),

                  /// banner ganar puntos
                  showMobileModule
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: CarouselSlider.builder(
                              itemCount: bannerList.length,
                              itemBuilder: (context, index, _) {
                                final item = bannerList[index];
                                return InkWell(
                                  onTap: () {
                                    if (isLoggedIn2 == true) {
                                      Get.toNamed(RouteHelper.answerPolls);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlerDialogWidget();
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: index == 0
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Gif(
                                              image: AssetImage(item),
                                              autostart: Autostart.loop,
                                              fit: BoxFit.cover,
                                              fps: 10,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              item,
                                              fit: BoxFit.cover,
                                              cacheHeight: 300,
                                            ),
                                          ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                              ),
                            ),
                          ),
                        )
                      : const SliverToBoxAdapter(),

                  /// Search Button
                  !showMobileModule
                      ? sliverPersistentHeadernotMobile(context)
                      : const SliverToBoxAdapter(),

                  SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child:
                            !showMobileModule && splashController.module != null
                                ? switch (splashController.module!.moduleType
                                    .toString()) {
                                    AppConstants.pharmacy =>
                                      const PharmacyHomeScreen(),
                                    AppConstants.food => const FoodHomeScreen(),
                                    AppConstants.grocery =>
                                      const GroceryHomeScreen(),
                                    AppConstants.ecommerce =>
                                      const ShopHomeScreen(),
                                    _ => const SizedBox.shrink(),
                                  }
                                : ModuleView(
                                    splashController: splashController,
                                  ),
                      ),
                    ),
                  ),

                  !showMobileModule
                      ? SliverPersistentHeader(
                          key: _headerKey,
                          pinned: true,
                          delegate: SliverDelegate(
                            height: 85,
                            callback: (val) {
                              searchBgShow = val;
                            },
                            child: const AllStoreFilterWidget(),
                          ),
                        )
                      : const SliverToBoxAdapter(),

                  SliverToBoxAdapter(
                    child: !showMobileModule
                        ? Center(
                            child: GetBuilder<StoreController>(
                              builder: (storeController) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 0
                                              : 100),
                                  child: PaginatedListView(
                                    scrollController: _scrollController,
                                    totalSize:
                                        storeController.storeModel?.totalSize,
                                    offset: storeController.storeModel?.offset,
                                    onPaginate: (int? offset) async =>
                                        await storeController.getStoreList(
                                            offset!, false),
                                    itemView: ItemsView(
                                      isStore: true,
                                      items: null,
                                      isFoodOrGrocery: (splashController
                                                  .module!.moduleType
                                                  .toString() ==
                                              AppConstants.food ||
                                          splashController.module!.moduleType
                                                  .toString() ==
                                              AppConstants.grocery),
                                      stores:
                                          storeController.storeModel?.stores,
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ResponsiveHelper.isDesktop(context)
                                                ? Dimensions
                                                    .paddingSizeExtraSmall
                                                : Dimensions.paddingSizeSmall,
                                        vertical:
                                            ResponsiveHelper.isDesktop(context)
                                                ? Dimensions
                                                    .paddingSizeExtraSmall
                                                : Dimensions.paddingSizeDefault,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
      ),
    );
  }

  SliverPersistentHeader sliverPersistentHeadernotMobile(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(
          callback: (val) {},
          child: Center(
              child: Container(
            height: 50,
            width: Dimensions.webMaxWidth,
            color: searchBgShow
                ? Get.find<ThemeController>().darkTheme
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).cardColor
                : null,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 1),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                ),
                child: Row(children: [
                  Icon(
                    CupertinoIcons.search,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(
                      child: Text(
                    Get.find<SplashController>()
                            .configModel!
                            .moduleConfig!
                            .module!
                            .showRestaurantText!
                        ? 'search_food_or_restaurant'.tr
                        : 'search_item_or_store'.tr,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  )),
                ]),
              ),
            ),
          ))),
    );
  }

  SliverAppBar sliverappbartitle(
    BuildContext context,
    SplashController splashController,
  ) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).colorScheme.surface,
      title: Center(
          child: Container(
        width: Dimensions.webMaxWidth,
        height: Get.find<LocalizationController>().isLtr ? 60 : 70,
        color: Theme.of(context).colorScheme.surface,
        child: Row(children: [
          (splashController.module != null &&
                  splashController.configModel!.module == null)
              ? InkWell(
                  onTap: () {
                    splashController.removeModule();
                    Get.find<StoreController>().resetStoreData();
                  },
                  child: Image.asset(
                    Images.moduleIcon,
                    height: 25,
                    width: 25,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                )
              : const SizedBox(),
          SizedBox(
            width: (splashController.module != null &&
                    splashController.configModel!.module == null)
                ? Dimensions.paddingSizeSmall
                : 0,
          ),
          Expanded(
            child: InkWell(
              onTap: () => Get.find<LocationController>()
                  .navigateToLocationScreen('home'),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeSmall
                      : 0,
                ),
                child: GetBuilder<LocationController>(
                  builder: (locationController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AuthHelper.isLoggedIn()
                              ? AddressHelper.getUserAddressFromSharedPref()!
                                  .addressType!
                                  .tr
                              : 'your_location'.tr,
                          style: robotoMedium.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeDefault),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                AddressHelper.getUserAddressFromSharedPref()!
                                    .address!,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.expand_more,
                              color: Theme.of(context).disabledColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          InkWell(
            child: GetBuilder<NotificationController>(
                builder: (notificationController) {
              return Stack(children: [
                Icon(
                  CupertinoIcons.bell,
                  size: 25,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
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
        ]),
      )),
      actions: const [SizedBox()],
    );
  }
}

class AlerDialogWidget extends StatelessWidget {
  const AlerDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.height * 0.7,
        // color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.guest,
                width: MediaQuery.of(context).size.height * 0.25,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                'you_are_not_logged_in'.tr,
                style: robotoBold.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.023),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                'please_login_to_continue'.tr,
                style: robotoRegular.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.0175,
                    color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SizedBox(
                width: 200,
                child: CustomButton(
                  buttonText: 'login'.tr,
                  height: 40,
                  onPressed: () async {
                    if (!ResponsiveHelper.isDesktop(context)) {
                      await Get.toNamed(
                          RouteHelper.getSignInRoute(Get.currentRoute));
                    } else {
                      // Get.dialog(const SignInScreen(
                      //         exitFromApp:
                      //             true,
                      //         backFromThis:
                      //             true))
                      //     .then((value) =>
                      //         // callBack(
                      //     true));
                    }
                    if (Get.find<OrderController>().showBottomSheet) {
                      Get.find<OrderController>().showRunningOrders();
                    }
                    // callBack(true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  Function(bool isPinned)? callback;
  bool isPinned = false;

  SliverDelegate({required this.child, this.height = 50, this.callback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    isPinned = shrinkOffset == maxExtent /*|| shrinkOffset < maxExtent*/;
    callback!(isPinned);
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

final List<String> bannerList = [
  'assets/image/banner1.gif',
  'assets/image/banner2.jpeg',
  'assets/image/banner3.jpeg',
];
