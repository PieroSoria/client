import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:puntos_client/features/auth/screens/sign_up_screen.dart';
import 'package:puntos_client/features/language/controllers/language_controller.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/features/auth/controllers/auth_controller.dart';
import 'package:puntos_client/features/auth/domain/models/social_log_in_body.dart';
import 'package:puntos_client/features/verification/controllers/verification_controller.dart';
import 'package:puntos_client/helper/custom_validator.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/helper/validate_check.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:puntos_client/common/widgets/custom_app_bar.dart';
import 'package:puntos_client/common/widgets/custom_button.dart';
import 'package:puntos_client/common/widgets/custom_snackbar.dart';
import 'package:puntos_client/common/widgets/custom_text_field.dart';
import 'package:puntos_client/common/widgets/footer_view.dart';
import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBody? socialLogInBody;
  const ForgetPassScreen(
      {super.key,
      required this.fromSocialLogin,
      required this.socialLogInBody});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final _datepickController = TextEditingController();
  @override
  void initState() {
    loadJsonData();
    super.initState();
  }

  final TextEditingController _numberController = TextEditingController();
  String? _countryDialCode = CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel!.country!)
      .dialCode;
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();

  //
  List<dynamic> departament = [];
  List<dynamic> province = [];
  List<dynamic> district = [];

  String? selectedDepartament;
  String? selectedDepartamentId;
  String? selectedProvince;
  String? selectedProvinceId;
  String? selectedDistrict;
  String? selectedDistrictId;
  DateTime? formattedDateUs;

  List<dynamic> filteredProvince = [];
  List<dynamic> filteredDistrict = [];
  String selectedGender = 'other';

  Future<void> loadJsonData() async {
    String departamentJson =
        await rootBundle.loadString('assets/data/departament.json');
    String provinceJson =
        await rootBundle.loadString('assets/data/province.json');
    String districtJson =
        await rootBundle.loadString('assets/data/district.json');

    setState(() {
      departament = jsonDecode(departamentJson)
          .firstWhere((element) => element['name'] == 'departament')['data'];
      province = jsonDecode(provinceJson)
          .firstWhere((element) => element['name'] == 'province')['data'];
      district = jsonDecode(districtJson)
          .firstWhere((element) => element['name'] == 'district')['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FooterView(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: context.width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: Column(
                  children: [
                    Image.asset(Images.forgot, height: 220),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                          widget.fromSocialLogin
                              ? 'please_data'.tr
                              : 'please_enter_mobile'.tr,
                          style: robotoRegular,
                          textAlign: TextAlign.center),
                    ),
                    Form(
                      key: _formKeyPhone,
                      child: Column(
                        children: [
                          CustomTextField(
                            titleText: 'enter_phone_number'.tr,
                            controller: _numberController,
                            inputType: TextInputType.phone,
                            inputAction: TextInputAction.done,
                            isPhone: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onCountryChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            labelText: 'phone'.tr,
                            validator: (value) =>
                                ValidateCheck.validatePhone(value, null),
                            countryDialCode: _countryDialCode != null
                                ? CountryCode.fromCountryCode(
                                        Get.find<SplashController>()
                                            .configModel!
                                            .country!)
                                    .code
                                : Get.find<LocalizationController>()
                                    .locale
                                    .countryCode,
                            onSubmit: (text) => GetPlatform.isWeb
                                ? _forgetPass(_countryDialCode!)
                                : null,
                          ),
                          widget.fromSocialLogin
                              ? const SizedBox(height: 24)
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? TextFormField(
                                  validator: (value) =>
                                      ValidateCheck.validateEmptyText(
                                          value, null),
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge),
                                  controller: _datepickController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'birthdate'.tr,
                                    hintStyle: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).hintColor),
                                    label: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'birthdate'.tr,
                                            style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(.75),
                                            ),
                                          ),

                                          TextSpan(
                                              text: ' *',
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),

                                          // if(widget.isEnabled == false)
                                          //   TextSpan(text: widget.fromUpdateProfile ? ' (${'phone_number_can_not_be_edited'.tr})' : ' (${'non_changeable'.tr})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error)),
                                        ],
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.date_range,
                                      color: Colors.grey,
                                    ),
                                    suffix: GestureDetector(
                                      onTap: () {
                                        _datepickController.clear();
                                      },
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 0.3,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          width: 0.3,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    isDense: true,
                                  ),
                                  onTap: () async {
                                    var datePicked =
                                        await DatePicker.showSimpleDatePicker(
                                      titleText: 'Selecciona fecha',
                                      context,
                                      initialDate: DateTime(2020),
                                      firstDate: DateTime(1930),
                                      lastDate: DateTime(2024),
                                      dateFormat: "dd-MMMM-yyyy",
                                      locale: DateTimePickerLocale.es,
                                      looping: true,
                                    );

                                    if (datePicked != null) {
                                      formattedDateUs = DateTime(
                                        datePicked.year,
                                        datePicked.month,
                                        datePicked.day,
                                      );
                                      await initializeDateFormatting(
                                          'es_ES', null);
                                      String formattedDate =
                                          DateFormat('dd-MMMM-yyyy', 'es_ES')
                                              .format(datePicked);
                                      await initializeDateFormatting(
                                          'en_US', null);
                                      await initializeDateFormatting(
                                          'en_US', null);

                                      setState(() {
                                        _datepickController.text =
                                            formattedDate;
                                      });
                                    }
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? Align(
                                  alignment: const AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Text(
                                      'gender'.tr,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(.75),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GenderWidget(
                                        gender: 'male',
                                        selected: selectedGender == 'male',
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 'male';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      GenderWidget(
                                        gender: 'female',
                                        selected: selectedGender == 'female',
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 'female';
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      GenderWidget(
                                        gender: 'other',
                                        selected: selectedGender == 'other',
                                        onTap: () {
                                          setState(() {
                                            selectedGender = 'other';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? const SizedBox(height: 24)
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: DropdownButtonFormField(
                                    validator: (value) =>
                                        ValidateCheck.validateEmptyText(
                                            value, null),
                                    hint: const Text(
                                        "Selecciona un Departamento"),
                                    value: selectedDepartament,
                                    decoration: inputDecorationDropDow(context),
                                    items: departament.map((departamento) {
                                      return DropdownMenuItem<String>(
                                        value: departamento['departament'],
                                        child:
                                            Text(departamento['departament']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDepartament = value;

                                        selectedDepartamentId = departament
                                            .firstWhere((departamento) =>
                                                departamento['departament'] ==
                                                value)['id']
                                            .toString();

                                        filteredProvince =
                                            province.where((provincia) {
                                          return provincia['departament_id'] ==
                                              departament.firstWhere((d) =>
                                                  d['departament'] ==
                                                  value)['id'];
                                        }).toList();
                                        selectedProvince =
                                            null; // Resetear selección de provincia
                                        filteredDistrict =
                                            []; // Limpiar distritos filtrados
                                        selectedDistrict =
                                            null; // Resetear selección de distrito
                                      });
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? const SizedBox(height: 8)
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) =>
                                        ValidateCheck.validateEmptyText(
                                            value, null),
                                    hint:
                                        const Text("Selecciona una Provincia"),
                                    value: selectedProvince,
                                    decoration: inputDecorationDropDow(context),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProvince = value;
                                        selectedProvinceId = province
                                            .firstWhere((province) =>
                                                province['province'] ==
                                                value)['id']
                                            .toString();

                                        filteredDistrict =
                                            district.where((district) {
                                          return district['province_id'] ==
                                              filteredProvince.firstWhere(
                                                  (provincia) =>
                                                      provincia['province'] ==
                                                      value)['id'];
                                        }).toList();
                                        selectedDistrict =
                                            null; // Resetear selección de distrito
                                      });
                                    },
                                    items: filteredProvince.map((provincia) {
                                      return DropdownMenuItem<String>(
                                        value: provincia['province'],
                                        child: Text(provincia['province']),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? const SizedBox(height: 8)
                              : const SizedBox.shrink(),
                          widget.fromSocialLogin
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) =>
                                        ValidateCheck.validateEmptyText(
                                            value, null),
                                    hint: const Text("Selecciona una Distrito"),
                                    value: selectedDistrict,
                                    decoration: inputDecorationDropDow(context),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDistrict = value;
                                        selectedDistrictId = district
                                            .firstWhere((district) =>
                                                district['district'] ==
                                                value)['id']
                                            .toString();
                                      });
                                    },
                                    items: filteredDistrict.map((district) {
                                      return DropdownMenuItem<String>(
                                        value: district['district'],
                                        child: Text(district['district']),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    GetBuilder<VerificationController>(
                      builder: (verificationController) {
                        return CustomButton(
                          buttonText: 'next'.tr,
                          isLoading: verificationController.isLoading,
                          onPressed: () => _forgetPass(_countryDialCode!),
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${'if_you_have_any_queries_feel_free_to_contact_with_our'.tr} ',
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).hintColor,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            TextSpan(
                              text: 'help_and_support'.tr,
                              style: robotoMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Get.toNamed(RouteHelper.getSupportRoute()),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecorationDropDow(BuildContext context) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 0.3,
          color: Theme.of(context).disabledColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Theme.of(context).primaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 0.3,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _forgetPass(
    String countryCode,
  ) async {
    String phone = _numberController.text.trim();

    String bithday = _datepickController.text.trim();

    String numberWithCountryCode = countryCode + phone;
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (_formKeyPhone.currentState!.validate()) {
      if (widget.fromSocialLogin) {
        if (phone.isEmpty) {
          showCustomSnackBar('enter_phone_number'.tr);
        } else if (bithday.isEmpty) {
          showCustomSnackBar('enter_your_birtday'.tr);
        } else if (selectedGender.isEmpty) {
          showCustomSnackBar('enter_your_gender'.tr);
        } else if (selectedDepartamentId == null) {
          showCustomSnackBar('enter_your_departament'.tr);
        } else if (selectedProvinceId == null) {
          showCustomSnackBar('enter_your_province'.tr);
        } else if (selectedDistrictId == null) {
          showCustomSnackBar('enter_your_district'.tr);
        } else if (!phoneValid.isValid) {
          showCustomSnackBar('invalid_phone_number'.tr);
        } else {
          widget.socialLogInBody!.phone = numberWithCountryCode;
          widget.socialLogInBody!.birthday = formattedDateUs.toString();
          widget.socialLogInBody!.gender = selectedGender;
          widget.socialLogInBody!.departamentId = selectedDepartamentId;
          widget.socialLogInBody!.provinceId = selectedProvinceId;
          widget.socialLogInBody!.districtId = selectedDistrictId;
          String? deviceToken =
              await Get.find<AuthController>().saveDeviceToken();
          widget.socialLogInBody!.deviceToken = deviceToken;
          Get.find<AuthController>().registerWithSocialMedia(
            widget.socialLogInBody!,
          );
        }
      } else {
        if (phone.isEmpty) {
          showCustomSnackBar('enter_phone_number'.tr);
        } else {
          Get.find<VerificationController>()
              .forgetPassword(numberWithCountryCode)
              .then(
            (status) async {
              if (status.isSuccess) {
                Get.toNamed(RouteHelper.getVerificationRoute(
                    numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
              } else {
                showCustomSnackBar(status.message);
              }
            },
          );
        }
      }
    }
  }
}
