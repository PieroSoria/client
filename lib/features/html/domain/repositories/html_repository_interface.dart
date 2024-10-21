import 'package:puntos_client/interfaces/repository_interface.dart';
import 'package:puntos_client/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}
