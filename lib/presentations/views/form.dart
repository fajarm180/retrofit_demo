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
          XNumberForm(
            initialValue: '${product.weight ?? ''}',
            label: 'Weight',
            onSaved: (v) => product.weight =
                (v ?? '').isNotEmpty ? int.tryParse(v ?? '0') : null,
          ),
          XNumberForm(
            initialValue: '${product.dimensions?.width ?? ''}',
            label: 'Width',
            onSaved: (v) => product.dimensions?.width =
                (v ?? '').isNotEmpty ? double.tryParse(v ?? '0.0') : null,
          ),
          XNumberForm(
            initialValue: '${product.dimensions?.depth ?? ''}',
            label: 'Length',
            onSaved: (v) => product.dimensions?.depth =
                (v ?? '').isNotEmpty ? double.tryParse(v ?? '0.0') : null,
          ),
          XNumberForm(
            initialValue: '${product.dimensions?.height ?? ''}',
            label: 'Height',
            onSaved: (v) => product.dimensions?.height =
                (v ?? '').isNotEmpty ? double.tryParse(v ?? '0.0') : null,
          ),
          XTextForm(
            initialValue: product.images?.last,
            label: 'Image URL',
            maxLine: 3,
            onSaved: (v) => (v ?? '').isNotEmpty ? product.images = [v!] : null,
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;

                formKey.currentState?.save();

                final repo = ProductRepo();
                try {
                  await ((product.id == null)
                      ? repo.addProduct(product)
                      : repo.updateProduct(product));

                  navigator.pop();
                } catch (e) {
                  sm.showSnackBar(
                    const SnackBar(
                      content: Text('Error creating product'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
