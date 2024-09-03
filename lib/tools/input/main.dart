import 'package:flutter/material.dart';

TextFormField inputWidget(TextEditingController varController,
    BuildContext context, String label, Placeholder, bool obscure) {
  return TextFormField(
    keyboardType: TextInputType.text,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: label,
      hintText: Placeholder, // Add hint text for clarity
    ),
    validator: (value) {
      if (value?.isEmpty ?? true) {
        return 'Please enter some text';
      }
      return null;
    },
    controller: varController,
  );
}
