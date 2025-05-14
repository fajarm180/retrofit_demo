import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retrofit_demo/presentations/components/inputs/text_form.dart';

class XNumberForm extends XTextForm {
  const XNumberForm({
    super.key,
    super.controller,
    super.initialValue,
    super.secureText = false,
    super.validator,
    super.label,
    super.hintText,
    super.placeholder,
    super.prefixIcon,
    super.suffixIconButton,
    super.enabled = true,
    super.textInputAction,
    super.onSaved,
    super.isRequired = false,
    this.isDecimal = false,
    super.keyboardType,
    super.inputFormatters,
  });

  final bool isDecimal;

  @override
  TextInputType get keyboardType =>
      super.keyboardType ?? TextInputType.numberWithOptions(decimal: isDecimal);
}
