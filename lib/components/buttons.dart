import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class LoadingButton extends StatelessWidget {
  final Function onPress;
  final String name;

  LoadingButton({@required this.onPress, @required this.name});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: RaisedButton(
              child: model.isLoading
                  ? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
              color: Colors.black,
              disabledColor: Color(0xFF424242),
              splashColor: Color(0xFF6d6d6d),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              onPressed: onPress == null || model.isLoading ? null : () async => onPress(context, model)));
    });
  }
}
