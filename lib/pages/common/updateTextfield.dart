import 'package:flutter/material.dart';

import '../../components/buttons.dart';
import '../../models/resultHandler.dart';
import '../../scoped-models/main.dart';

class UpdateTextFieldPage extends StatefulWidget {
  final TextFormField textfield;
  final String buttonText;
  final TextEditingController textController;
  final Function updateFunc;

  UpdateTextFieldPage({@required this.textfield, @required this.buttonText, @required this.textController, @required this.updateFunc}) ;
  @override
  State<StatefulWidget> createState() {
    return UpdateTextFieldState();
  }
}

class UpdateTextFieldState extends State<UpdateTextFieldPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: widget.textfield,
                ),
                Spacer(),
                LoadingButton(
                  onPress: (BuildContext context, MainModel model) async {
                    if (_formKey.currentState.validate()) {
                      ResultHandler result = await widget.updateFunc(widget.textController.text);
                      result.isSuccess ? Navigator.pop(context) : Scaffold.of(context).showSnackBar(SnackBar(content: Text(result.errorMessage.toString())));
                    }
                  },
                  name: 'Update ${widget.buttonText}',
                )
              ],
            )),
      ),
    );
  }
}
