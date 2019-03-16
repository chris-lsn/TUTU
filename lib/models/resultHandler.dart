import 'package:flutter/foundation.dart';

import '../resources/errorMessage.dart';

class ResultHandler {
  final bool isSuccess;
  final ErrorMessage errorMessage;

  ResultHandler({@required this.isSuccess, this.errorMessage});
}