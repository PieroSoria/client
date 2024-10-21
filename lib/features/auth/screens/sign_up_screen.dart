import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import 'package:puntos_client/features/language/controllers/language_controller.dart';
import 'package:puntos_client/features/location/controllers/location_controller.dart';
import 'package:puntos_client/features/splash/controllers/splash_controller.dart';
import 'package:puntos_client/features/auth/controllers/auth_controller.dart';
import 'package:puntos_client/features/auth/domain/models/signup_body_model.dart';
import 'package:puntos_client/features/auth/screens/sign_in_screen.dart';
import 'package:puntos_client/features/auth/widgets/condition_check_box_widget.dart';
import 'package:puntos_client/helper/custom_validator.dart';
import 'package:puntos_client/helper/responsive_helper.dart';
import 'package:puntos_client/helper/route_helper.dart';
import 'package:puntos_client/helper/validate_check.dart';
import 'package:puntos_client/util/dimensions.dart';
import 'package:puntos_client/util/images.dart';
import 'package:puntos_client/util/styles.dart';
import 'package:puntos_client/common/widgets/custom_button.dart';
import 'package:puntos_client/common/widgets/custom_snackbar.dart';
import 'package:puntos_client/common/widgets/custom_text_field.dart';
import 'package:puntos_client/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class SignUpScreen extends StatefulWidget {
  final bool exitFromApp;
  const SignUpScreen({super.key, this.exitFromApp = false});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  final _datepickController = TextEditingController();
  String? _countryDialCode;
  GlobalKey<FormState>? _formKeySignUp;

  //departament

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

  @override
  void initState() {
    super.initState();

    _formKeySignUp = GlobalKey<FormState>();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
    initializeDateFormatting('es_ES', null).then((_) {});
    loadJsonData();
  }

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
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context)
              ? null
              : !widget.exitFromApp
                  ? AppBar(
                      leading: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back_ios_rounded,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      actions: const [SizedBox()],
                    )
                  : null),
          backgroundColor: ResponsiveHelper.isDesktop(context)
              ? Colors.transparent
              : Theme.of(context).cardColor,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: context.width > 700
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : null,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    )
                  : null,
              child: GetBuilder<AuthController>(builder: (authController) {
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Form(
                        key: _formKeySignUp,
                        child: Padding(
                          padding: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.all(40)
                              : EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(Images.logo, width: 125),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('sign_up'.tr,
                                    style: robotoBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                              Row(children: [
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'first_name'.tr,
                                    titleText: 'ex_jhon'.tr,
                                    controller: _firstNameController,
                                    focusNode: _firstNameFocus,
                                    nextFocus: _lastNameFocus,
                                    inputType: TextInputType.name,
                                    capitalization: TextCapitalization.words,
                                    prefixIcon: Icons.person,
                                    required: true,
                                    labelTextSize: Dimensions.fontSizeDefault,
                                    validator: (value) =>
                                        ValidateCheck.validateEmptyText(
                                            value, null),
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'last_name'.tr,
                                    titleText: 'ex_doe'.tr,
                                    controller: _lastNameController,
                                    focusNode: _lastNameFocus,
                                    nextFocus:
                                        ResponsiveHelper.isDesktop(context)
                                            ? _emailFocus
                                            : _phoneFocus,
                                    inputType: TextInputType.name,
                                    capitalization: TextCapitalization.words,
                                    prefixIcon: Icons.person,
                                    required: true,
                                    labelTextSize: Dimensions.fontSizeDefault,
                                    validator: (value) =>
                                        ValidateCheck.validateEmptyText(
                                            value, null),
                                  ),
                                )
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              Row(
                                children: [
                                  ResponsiveHelper.isDesktop(context)
                                      ? Expanded(
                                          child: CustomTextField(
                                            labelText: 'email'.tr,
                                            titleText: 'enter_email'.tr,
                                            controller: _emailController,
                                            focusNode: _emailFocus,
                                            nextFocus:
                                                ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? _phoneFocus
                                                    : _passwordFocus,
                                            inputType:
                                                TextInputType.emailAddress,
                                            prefixImage: Images.mail,
                                            required: true,
                                            validator: (value) =>
                                                ValidateCheck.validateEmail(
                                                    value),
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                      width: ResponsiveHelper.isDesktop(context)
                                          ? Dimensions.paddingSizeSmall
                                          : 0),
                                  Expanded(
                                    child: CustomTextField(
                                      labelText: 'phone'.tr,
                                      titleText: 'enter_phone_number'.tr,
                                      controller: _phoneController,
                                      focusNode: _phoneFocus,
                                      nextFocus:
                                          ResponsiveHelper.isDesktop(context)
                                              ? _passwordFocus
                                              : _emailFocus,
                                      inputType: TextInputType.phone,
                                      isPhone: true,
                                      onCountryChanged:
                                          (CountryCode countryCode) {
                                        _countryDialCode = countryCode.dialCode;
                                      },
                                      countryDialCode: _countryDialCode != null
                                          ? CountryCode.fromCountryCode(
                                                  Get.find<SplashController>()
                                                      .configModel!
                                                      .country!)
                                              .code
                                          : Get.find<LocalizationController>()
                                              .locale
                                              .countryCode,
                                      required: true,
                                      validator: (value) =>
                                          ValidateCheck.validatePhone(
                                              value, null),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              !ResponsiveHelper.isDesktop(context)
                                  ? CustomTextField(
                                      labelText: 'email'.tr,
                                      titleText: 'enter_email'.tr,
                                      controller: _emailController,
                                      focusNode: _emailFocus,
                                      nextFocus: _passwordFocus,
                                      inputType: TextInputType.emailAddress,
                                      prefixIcon: Icons.mail,
                                      required: true,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, null),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                  height: !ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.paddingSizeLarge
                                      : 0),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(children: [
                                        CustomTextField(
                                          labelText: 'password'.tr,
                                          titleText: '8_character'.tr,
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          nextFocus: _confirmPasswordFocus,
                                          inputType:
                                              TextInputType.visiblePassword,
                                          prefixIcon: Icons.lock,
                                          isPassword: true,
                                          required: true,
                                          validator: (value) =>
                                              ValidateCheck.validateEmptyText(
                                                  value, null),
                                        ),
                                      ]),
                                    ),
                                    SizedBox(
                                        width:
                                            ResponsiveHelper.isDesktop(context)
                                                ? Dimensions.paddingSizeSmall
                                                : 0),
                                    ResponsiveHelper.isDesktop(context)
                                        ? Expanded(
                                            child: CustomTextField(
                                            labelText: 'confirm_password'.tr,
                                            titleText: '8_character'.tr,
                                            controller:
                                                _confirmPasswordController,
                                            focusNode: _confirmPasswordFocus,
                                            nextFocus:
                                                Get.find<SplashController>()
                                                            .configModel!
                                                            .refEarningStatus ==
                                                        1
                                                    ? _referCodeFocus
                                                    : null,
                                            inputAction:
                                                Get.find<SplashController>()
                                                            .configModel!
                                                            .refEarningStatus ==
                                                        1
                                                    ? TextInputAction.next
                                                    : TextInputAction.done,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            prefixIcon: Icons.lock,
                                            isPassword: true,
                                            onSubmit: (text) =>
                                                (GetPlatform.isWeb)
                                                    ? _register(authController,
                                                        _countryDialCode!)
                                                    : null,
                                            required: true,
                                            validator: (value) =>
                                                ValidateCheck.validateEmptyText(
                                                    value, null),
                                          ))
                                        : const SizedBox()
                                  ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              !ResponsiveHelper.isDesktop(context)
                                  ? CustomTextField(
                                      labelText: 'confirm_password'.tr,
                                      titleText: '8_character'.tr,
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocus,
                                      nextFocus: Get.find<SplashController>()
                                                  .configModel!
                                                  .refEarningStatus ==
                                              1
                                          ? _referCodeFocus
                                          : null,
                                      inputAction: Get.find<SplashController>()
                                                  .configModel!
                                                  .refEarningStatus ==
                                              1
                                          ? TextInputAction.next
                                          : TextInputAction.done,
                                      inputType: TextInputType.visiblePassword,
                                      prefixIcon: Icons.lock,
                                      isPassword: true,
                                      onSubmit: (text) => (GetPlatform.isWeb)
                                          ? _register(
                                              authController, _countryDialCode!)
                                          : null,
                                      required: true,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, null),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0,
                              ),
                              (Get.find<SplashController>()
                                          .configModel!
                                          .refEarningStatus ==
                                      1)
                                  ? CustomTextField(
                                      labelText: 'refer_code'.tr,
                                      titleText: 'enter_refer_code'.tr,
                                      controller: _referCodeController,
                                      focusNode: _referCodeFocus,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.text,
                                      capitalization: TextCapitalization.words,
                                      prefixImage: Images.referCode,
                                      prefixSize: 14,
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 24),
                              (Get.find<SplashController>()
                                          .configModel!
                                          .refEarningStatus ==
                                      1)
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
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusDefault),
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              width: 1,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusDefault),
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              width: 0.3,
                                              color: Theme.of(context)
                                                  .primaryColor),
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
                                        var datePicked = await DatePicker
                                            .showSimpleDatePicker(
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
                                          String formattedDate = DateFormat(
                                                  'dd-MMMM-yyyy', 'es_ES')
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
                                  : const SizedBox(),
                              Align(
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
                              ),
                              SizedBox(
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
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: DropdownButtonFormField(
                                  validator: (value) =>
                                      ValidateCheck.validateEmptyText(
                                          value, null),
                                  hint:
                                      const Text("Selecciona un Departamento"),
                                  value: selectedDepartament,
                                  decoration: inputDecorationDropDow(context),
                                  items: departament.map((departamento) {
                                    return DropdownMenuItem<String>(
                                      value: departamento['departament'],
                                      child: Text(departamento['departament']),
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
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: DropdownButtonFormField<String>(
                                  validator: (value) =>
                                      ValidateCheck.validateEmptyText(
                                          value, null),
                                  hint: const Text("Selecciona una Provincia"),
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
                              ),
                              const SizedBox(height: 8),
                              Padding(
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
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              const ConditionCheckBoxWidget(
                                  forDeliveryMan: true),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              CustomButton(
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 45
                                    : null,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 180
                                    : null,
                                radius: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.radiusSmall
                                    : Dimensions.radiusDefault,
                                isBold: !ResponsiveHelper.isDesktop(context),
                                fontSize: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.fontSizeExtraSmall
                                    : null,
                                buttonText: 'sign_up'.tr,
                                isLoading: authController.isLoading,
                                onPressed: authController.acceptTerms
                                    ? () => _register(
                                        authController, _countryDialCode!)
                                    : null,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('already_have_account'.tr,
                                      style: robotoRegular.copyWith(
                                          color: Theme.of(context).hintColor)),
                                  InkWell(
                                    onTap: () {
                                      if (ResponsiveHelper.isDesktop(context)) {
                                        Get.back();
                                        Get.dialog(const SignInScreen(
                                            exitFromApp: false,
                                            backFromThis: false));
                                      } else {
                                        if (Get.currentRoute ==
                                            RouteHelper.signUp) {
                                          Get.back();
                                        } else {
                                          Get.toNamed(
                                              RouteHelper.getSignInRoute(
                                                  RouteHelper.signUp));
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                      child: Text('sign_in'.tr,
                                          style: robotoMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
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

  void _register(AuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();
    String bithday = _datepickController.text.trim();

    String numberWithCountryCode = countryCode + number;
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (_formKeySignUp!.currentState!.validate()) {
      if (firstName.isEmpty) {
        showCustomSnackBar('enter_your_first_name'.tr);
      } else if (lastName.isEmpty) {
        showCustomSnackBar('enter_your_last_name'.tr);
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
      } else if (email.isEmpty) {
        showCustomSnackBar('enter_email_address'.tr);
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('enter_a_valid_email_address'.tr);
      } else if (number.isEmpty) {
        showCustomSnackBar('enter_phone_number'.tr);
      } else if (!phoneValid.isValid) {
        showCustomSnackBar('invalid_phone_number'.tr);
      } else if (password.isEmpty) {
        showCustomSnackBar('enter_password'.tr);
      } else if (password.length < 6) {
        showCustomSnackBar('password_should_be'.tr);
      } else if (password != confirmPassword) {
        showCustomSnackBar('confirm_password_does_not_matched'.tr);
      } else {
        String? deviceToken = await authController.saveDeviceToken();

        SignUpBodyModel signUpBody = SignUpBodyModel(
          fName: firstName,
          lName: lastName,
          email: email,
          phone: numberWithCountryCode,
          password: password,
          refCode: referCode,
          birthday: formattedDateUs.toString(),
          gender: selectedGender,
          departamentId: selectedDepartamentId,
          provinceId: selectedProvinceId,
          districtId: selectedDistrictId,
          deviceToken: deviceToken,
        );
        authController.registration(signUpBody).then((status) async {
          if (status.isSuccess) {
            if (Get.find<SplashController>()
                .configModel!
                .customerVerification!) {
              List<int> encoded = utf8.encode(password);
              String data = base64Encode(encoded);
              Get.toNamed(RouteHelper.getVerificationRoute(
                  numberWithCountryCode,
                  status.message,
                  RouteHelper.signUp,
                  data));
            } else {
              Get.find<LocationController>()
                  .navigateToLocationScreen(RouteHelper.signUp);
              if (ResponsiveHelper.isDesktop(context)) {
                Get.back();
              }
            }
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}

class GenderWidget extends StatelessWidget {
  const GenderWidget(
      {super.key,
      required this.gender,
      required this.selected,
      required this.onTap});
  final String gender;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context)
                      .hintColor
                      .withOpacity(0.3), // color del borde
              width: 1, // grosor del borde
            ),
          ),
          child: AnimatedDefaultTextStyle(
            style: robotoRegular.copyWith(
              fontSize: selected ? 18 : Dimensions.fontSizeLarge,
              color: selected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).hintColor.withOpacity(.75),
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceInOut,
            child: Text(
              gender.tr,
            ),
          ),
        ),
      ),
    );
  }
}
