import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/repository/product.dart';
import 'package:retrofit_demo/presentations/components/inputs/number_form.dart';
import 'package:retrofit_demo/presentations/components/inputs/text_form.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key, this.product});
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final product = this.product ?? Product();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ProductForm(product: product),
        ),
      ),
    );
  }
}

class ProductForm extends StatelessWidget {
  const ProductForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final sm = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final isShowDetailForm = ValueNotifier<bool>(false);

    return Form(
      key: formKey,
      child: Column(
        children: [
          const Gap(16),
          XTextForm(
            initialValue: product.label,
            label: 'Name',
            isRequired: true,
            onSaved: (v) => product.label = v,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(3),
            ]),
          ),
          XNumberForm(
            initialValue: '${product.price ?? ''}',
            label: 'Price',
            isRequired: true,
            onSaved: (v) => product.price = double.tryParse(v ?? '0.0'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.min(0),
            ]),
          ),
          XTextForm(
            initialValue: product.description,
            label: 'Description',
            onSaved: (v) => product.description = v,
            maxLine: 5,
          ),
          Row(
            children: [
              Text(
                'Show detail form',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Gap(8),
              ValueListenableBuilder(
                valueListenable: isShowDetailForm,
                builder: (ctx, show, child) {
                  return Switch(
                    value: show,
                    onChanged: (v) => isShowDetailForm.value = v,
                  );
                },
              )
            ],
          ),
          const Gap(16),
          ValueListenableBuilder(
            valueListenable: isShowDetailForm,
            builder: (ctx, show, child) {
              return (show)
                  ? Column(
                      children: [
                        XNumberForm(
                          initialValue: '${product.weight ?? ''}',
                          label: 'Weight',
                          onSaved: (v) => product.weight = (v ?? '').isNotEmpty
                              ? int.tryParse(v ?? '0')
                              : null,
                        ),
                        XNumberForm(
                          initialValue: '${product.dimensions?.width ?? ''}',
                          label: 'Width',
                          onSaved: (v) => product.dimensions?.width =
                              (v ?? '').isNotEmpty
                                  ? double.tryParse(v ?? '0.0')
                                  : null,
                        ),
                        XNumberForm(
                          initialValue: '${product.dimensions?.depth ?? ''}',
                          label: 'Length',
                          onSaved: (v) => product.dimensions?.depth =
                              (v ?? '').isNotEmpty
                                  ? double.tryParse(v ?? '0.0')
                                  : null,
                        ),
                        XNumberForm(
                          initialValue: '${product.dimensions?.height ?? ''}',
                          label: 'Height',
                          onSaved: (v) => product.dimensions?.height =
                              (v ?? '').isNotEmpty
                                  ? double.tryParse(v ?? '0.0')
                                  : null,
                        ),
                        XTextForm(
                          initialValue: product.images?.last,
                          label: 'Image URL',
                          maxLine: 3,
                          onSaved: (v) => (v ?? '').isNotEmpty
                              ? product.images = [v!]
                              : null,
                        ),
                      ],
                    )
                  : Container();
            },
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;

                log('Before Save: ${product.toJson()}');

                formKey.currentState?.save();

                log('After Save: ${product.toJson()}');

                final repo = ProductRepo();
                try {
                  await ((product.id == null)
                      ? repo.addProduct(product)
                      : repo.updateProduct(product));

                  navigator.pop();
                } catch (e) {
                  sm.showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Error creating product'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ),
          const Gap(kBottomNavigationBarHeight)
        ],
      ),
    );
  }
}
