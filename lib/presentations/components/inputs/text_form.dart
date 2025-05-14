import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

class XTextForm extends StatelessWidget {
  const XTextForm({
    super.key,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.secureText = false,
    this.validator,
    this.title,
    this.label,
    this.hintText,
    this.placeholder,
    this.prefixIcon,
    this.suffixIconButton,
    this.enabled = true,
    this.isRequired = false,
    this.textInputAction,
    this.onSaved,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmit,
    this.autovalidateMode,
    this.requiredErrorText,
    this.maxLine,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool secureText;
  final FormFieldValidator<String>? validator;
  final String? title;
  final String? label;
  final String? hintText;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIconButton;
  final bool enabled;
  final bool isRequired;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final void Function(String? newValue)? onSaved;
  final void Function(String? newValue)? onChanged;
  final void Function(String? newValue)? onSubmit;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? requiredErrorText;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title?.isNotEmpty ?? false)
          Row(
            children: [
              Flexible(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    text: title ?? '',
                    children: [
                      if (isRequired)
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isRequired ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  hintText ?? '',
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        TextFormField(
          maxLines: maxLine ?? 1,
          onTap: onTap,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onSubmit,
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: secureText,
          textInputAction: textInputAction,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          validator: (v) {
            FormBuilderValidators.required<String>(
              errorText: requiredErrorText ?? 'Input tidak boleh kosong',
            );

            return validator?.call(v);
          },
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            label: (label ?? '').isNotEmpty ? _label : null,
            prefixIcon: prefixIcon,
            hintText: placeholder ?? '',
            suffixIcon: suffixIconButton,
            enabled: enabled,
          ),
        ),
        const Gap(16),
      ],
    );
  }

  Widget get _label => RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: label ?? ''),
            if (isRequired)
              const TextSpan(
                text: '*',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
          ],
        ),
      );
}
