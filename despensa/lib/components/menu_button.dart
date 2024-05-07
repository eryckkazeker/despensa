import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  final String _buttonText;
  final VoidCallback? _function;
  final Color? backgroundColor;
  final Color? textColor;

  MenuButton(this._buttonText, this._function, {this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(backgroundColor: this.backgroundColor != null ? MaterialStatePropertyAll(this.backgroundColor) : MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
        foregroundColor: this.textColor != null ? MaterialStatePropertyAll(this.textColor) : MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary)),
      onPressed: _function, 
      child: Text(
        _buttonText,
        style: TextStyle(
          color: this.textColor,
        ),
      ));
  }
}