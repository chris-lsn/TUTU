import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './connected.dart';

class MainModel extends Model with ConnectedModel, UserModel, CasesModel, UtilityModel {}
