import 'package:flutter/material.dart';

/// Returns true if [toValidate] is an email.
bool isValidEmail(final String toValidate) {
  final RegExp emailMatcher = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+(\.[a-zA-Z]+)+");

  return emailMatcher.hasMatch(toValidate);
}

/// Template Widget for a user credential input field.
class CredentialInputField extends StatefulWidget {
  const CredentialInputField({
    Key? key,
    required this.obscureText,
    required this.error,
    required this.label,
    required this.controller
  }) : super(key: key);

  final bool obscureText;
  final String? error;
  final String label;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _CredentialInputFieldState();
}

class _CredentialInputFieldState extends State<CredentialInputField> {
  late bool _passwordHidden = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: widget.label,
        border: const UnderlineInputBorder(),
        errorText: widget.error,
        suffixIcon: widget.obscureText ? IconButton(
          icon: Icon(_passwordHidden ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _passwordHidden = !_passwordHidden),
          iconSize: 20,
          alignment: Alignment.bottomCenter,
        ) : null,
      ),
      obscureText: _passwordHidden,
      controller: widget.controller,
    );
  }
}
