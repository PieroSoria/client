import 'package:get/get.dart';
import 'package:puntos_client/util/html_type.dart';

abstract class HtmlServiceInterface {
  Future<Response> getHtmlText(HtmlType htmlType);
}
