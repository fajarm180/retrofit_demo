import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CDateRangeForm extends FormField<List<DateTime?>?> {
  CDateRangeForm({
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
    ValueChanged<List<DateTime?>?>? onChanged,
    this.required = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(List<DateTime?>? v)? dateFormat,
    bool Function(DateTime? v)? selectableDayPredicate,
  }) : super(builder: (state) {
          void onChangedHandler(List<DateTime?>? value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          void selectDate() async {
            final result = await showCalendarDatePicker2Dialog(
              context: state.context,
              barrierDismissible: false,
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.range,
                firstDate: firstDate,
                lastDate: lastDate,
                selectableDayPredicate: selectableDayPredicate,
              ),
              dialogSize: const Size(325, 400),
              value: state.value ?? [],
              borderRadius: BorderRadius.circular(15),
            );

            if (result != null) onChangedHandler(result);
          }

          String? formatDate(List<DateTime?>? value) {
            if (value == null) return null;

            if (dateFormat != null) {
              return dateFormat(value);
            }

            return '${value.first.toString().split(' ')[0]} - ${value.last.toString().split(' ')[0]}';
          }

          return TextFormField(
            key: ValueKey(state.value ?? state.errorText),
            initialValue: formatDate(state.value),
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
  FormFieldValidator<List<DateTime?>?>? get validator => (value) {
        if (required && (value == null)) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
