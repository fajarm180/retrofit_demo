import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CDateRangeForm extends FormField<DateTimeRange?> {
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
    ValueChanged<DateTimeRange?>? onChanged,
    this.required = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTimeRange? v)? dateFormat,
    bool Function(DateTime? v)? selectableDayPredicate,
  }) : super(builder: (state) {
          void onChangedHandler(DateTimeRange? value) {
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
              value: state.value != null
                  ? [state.value!.start, state.value!.end]
                  : [],
              borderRadius: BorderRadius.circular(15),
            );

            if (result != null) {
              onChangedHandler(DateTimeRange(
                start: result.first!,
                end: result.last!,
              ));
            }
          }

          String? formatDate(DateTimeRange? value) {
            if (value == null) return null;

            if (dateFormat != null) {
              return dateFormat(value);
            }

            return '${value.start.toString().split(' ')[0]} - ${value.end.toString().split(' ')[0]}';
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
  FormFieldValidator<DateTimeRange?>? get validator => (value) {
        if (required && (value == null)) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
