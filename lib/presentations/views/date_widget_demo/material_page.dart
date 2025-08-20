import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retrofit_demo/presentations/components/inputs/date_picker/material/date_form.dart';
import 'package:retrofit_demo/presentations/components/inputs/date_picker/material/date_range_form.dart';
import 'package:retrofit_demo/presentations/components/layout/base_layout.dart';

class MatDateWidgetPage extends StatelessWidget {
  const MatDateWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final formKey = GlobalKey<FormState>();

    return XBaseLayout(
      pageTitle: 'Material Date Widget',
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Date Input'),
            MDateForm(required: true),
            const Gap(16),
            Text('Date Range Input'),
            MDateRangeForm(required: true),
            const Gap(16),
            // Text('Multi Date Input'),
            // CMultiDateForm(required: true),
            // const Gap(16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(color: color.onSurface.withAlpha(123)),
        ),
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          onPressed: () async {
            if (!(formKey.currentState?.validate() ?? false)) return;
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
