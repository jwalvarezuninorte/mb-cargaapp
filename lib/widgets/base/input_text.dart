import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.formatter,
    required this.keyboardType,
    this.maxLines = 1,
    this.suffix = '',
    this.padding,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final InputFormatter formatter;
  final TextInputType keyboardType;
  final int? maxLines;

  final String? suffix;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? AppTheme.padding / 2),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          suffixText: suffix as String,
        ),
        style: TextStyle(
          color: AppTheme.dark,
          fontSize: 16,
        ),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: getInputFormatter(formatter),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}

List<TextInputFormatter> getInputFormatter(InputFormatter formatter) {
  switch (formatter) {
    case InputFormatter.text:
      return [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))];
    case InputFormatter.number:
      return [FilteringTextInputFormatter.allow(RegExp('[0-9 ]'))];
    default:
      return [];
  }
}

enum InputFormatter {
  text,
  number,
  email,
  phone,
  date,
  time,
  dateTime,
  dni,
  none,
  address,
  password,
  confirmPassword,
  url,
  multiline,
  multilineNumber,
  multilineEmail,
  multilinePhone,
  multilineDate,
  multilineTime,
  multilineDateTime,
  multilineDni,
  multilineAddress,
  multilinePassword,
  multilineConfirmPassword,
  multilineUrl,
}
