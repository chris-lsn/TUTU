import 'package:flutter/foundation.dart';

import '../resources/errorMessage.dart';

class ResultHandler {
  final bool isSuccess;
  final ErrorMessage err_message;

  ResultHandler({@required this.isSuccess, this.err_message});
}