import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:puntos_client/features/shared_points/controller/user_points_controller.dart';
import '../../../common/models/response_model.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../helper/auth_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import 'shared_points_screen.dart';

class SendPointsScreen extends StatefulWidget {
  final String scannedCode;
  final String message;

  SendPointsScreen({required this.scannedCode, required this.message});
  //const SendPointsScreen({super.key});

  @override
  State<SendPointsScreen> createState() => _SendPointsScreenState();
}

class _SendPointsScreenState extends State<SendPointsScreen> {
  final ProfileController profileController = Get.find<ProfileController>(); //
  final CouponController couponController = Get.find<CouponController>(); //
  final UserPointsController userPointsController =
      Get.find<UserPointsController>();

  ScrollController scrollController = ScrollController();
  final TextEditingController _pointsController = TextEditingController();

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

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(title: 'Enviar Puntos Smart'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${widget.message}', //"Nombre Persona",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  '${widget.scannedCode}', //,"2342435 código",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: TextFormField(
                      controller: _pointsController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      maxLength: 4,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        counterText: '',
                      ),
                      textAlign: TextAlign.right,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Permitir solo dígitos
                        //CustomNumericInputFormatter(), // Personalizado para pegado
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "PS",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      final points =
                          double.tryParse(_pointsController.text) ?? 0;
                      if (points > 0) {
                        String enteredPoints = _pointsController.text.trim();

                        ResponseModel responseModel = await userPointsController
                            .sendPoints('${widget.scannedCode}', enteredPoints);
                        if (responseModel.isSuccess) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return dialog_points();
                              });

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(responseModel.message.toString()),
                          //     backgroundColor: Colors.green,
                          //   ),
                          // );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(responseModel.message.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => SharedPointsScreen()),
                        // );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Por favor ingrese un valor mayor a 0'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Theme.of(context).primaryColor, // Color del texto
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Tamaño del botón
                    ),
                    child: Text("Enviar"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(() => SharedPointsScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.white, //Theme.of(context).primaryColor,
                      backgroundColor:
                          const Color(0XFF30384F), // Color del texto
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Tamaño del botón
                      //elevation: 0,
                    ),
                    child: Text("Regresar"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class dialog_points extends StatelessWidget {
  const dialog_points({
    Key? key,
    // Obligatorio al instanciar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Puntos Smart', // Aquí va tu título
          style: TextStyle(
            fontSize: 24, // Tamaño de la fuente
            fontWeight: FontWeight.bold, // Negrita
            fontFamily:
                'Roboto', // Tipografía, puedes cambiarla según el font que prefieras
          ),
        ),
      ),
      content: Text(
        'Sus puntos fueron enviados correctamente',
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Reenviar puntos'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.off(() => SharedPointsScreen());
          },
          child: Text('Regresar'),
        ),
      ],
    );
  }
}
