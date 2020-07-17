import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  final String _buttonText;
  final VoidCallback _function;
  final Color backgroundColor;
  final Color textColor;

  MenuButton(this._buttonText, this._function, {this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.backgroundColor != null ? this.backgroundColor : Theme.of(context).accentColor,
      onPressed: _function,
      child: Text(
        _buttonText,
        style: TextStyle(
          color: this.textColor != null ? this.textColor : Colors.white,
        ),
      ),
    );
  }
}