import 'package:flutter/material.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generated/l10n.dart';

class PasswordInputText extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final bool isDense;
  final bool mostraIcona;
  final bool mostraCounter;
  final String? Function(String?)? validator;

  const PasswordInputText({
    super.key,
    this.label,
    this.controller,
    this.onFieldSubmitted,
    this.isDense = true,
    this.mostraIcona = true,
    this.mostraCounter = false,
    this.validator,
  });

  @override
  State<PasswordInputText> createState() => _PasswordInputTextState();
}

class _PasswordInputTextState extends State<PasswordInputText> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 50,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return S.current.msg_campo_vuoto;
              }
              return null;
            },
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          counterText: widget.mostraCounter == false ? "" : null,
          isDense: widget.isDense,
          labelText: widget.label != null ? widget.label!.capitalize() : S.current.password.capitalize(),
          prefixIcon: widget.mostraIcona ? const Icon(Icons.key) : null,
          suffixIcon: IconButton(
            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ));
  }
}
