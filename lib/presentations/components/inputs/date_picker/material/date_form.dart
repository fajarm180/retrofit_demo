import 'package:flutter/material.dart';

class MDateForm extends FormField<DateTime?> {
  MDateForm({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled = true,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    Widget? label,
    String? hintText,
    this.requiredErrorText,
    VoidCallback? onClear,
    ValueChanged<DateTime?>? onChanged,
    this.required = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTime? v)? displayFormat,
    bool Function(DateTime? v)? selectableDayPredicate,
  }) : super(builder: (state) {
          void onChangedHandler(DateTime? value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          void selectDate() async {
            DateTime? result = await showDatePicker(
              context: state.context,
              initialDate: state.value,
              selectableDayPredicate: selectableDayPredicate,
              firstDate: firstDate ?? DateTime(1970),
              lastDate: lastDate ?? DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              barrierDismissible: false,
              builder: (context, child) {
                return Theme(data: Theme.of(context), child: child!);
              },
            );

            if (result != null) {
              onChangedHandler(result);
            }
          }

          return TextFormField(
            key: ValueKey(state.value ?? state.errorText),
            initialValue: (state.value != null)
                ? (displayFormat != null)
                    ? displayFormat(state.value)
                    : state.value.toString().split(' ')[0]
                : null,
            autovalidateMode: autovalidateMode,
            onSaved: (v) => onSaved?.call(state.value),
            onChanged: (v) => onChanged?.call(state.value),
            onTap: selectDate,
            readOnly: true,
            forceErrorText: (state.hasError) ? state.errorText : null,
            decoration: InputDecoration(
              label: label,
              hintText: hintText ?? '',
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.value != null && enabled)
                      InkWell(
                        onTap: onClear ?? () => onChangedHandler(null),
                        child: const Icon(Icons.clear),
                      ),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
              enabled: enabled,
            ),
          );
        });

  final String? requiredErrorText;
  final bool required;

  @override
  FormFieldValidator<DateTime?>? get validator => (value) {
        if (required && (value == null)) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
