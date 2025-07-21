import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/repository/product.dart';
import 'package:retrofit_demo/presentations/components/dialogs/delete_dialog.dart';
import 'package:retrofit_demo/presentations/components/layout/list_view.dart';
import 'package:retrofit_demo/presentations/components/search_bar.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('List Product'),
        ),
        body: ProductListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'product_form'),
          tooltip: 'Add Product',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final sc = TextEditingController();
  List<Product> items = [];
  final length = 10;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: XSearchBar(
            controller: sc,
            onSearch: (v) => onRefresh(),
          ),
        ),
        Expanded(
          child: XListView(
            initialRefresh: true,
            onRefresh: () async {
              sc.clear();
              onRefresh();
            },
            onLoading: onLoading,
            itemsCount: items.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductListTile(item: items[i]),
            ),
          ),
        ),
      ],
    );
  }

  void onRefresh() async {
    try {
      final result = await ProductRepo().getProducts(query: sc.text);

      setState(() {
        items.clear();
        items = result;
        page = 1;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<LoadStatus> onLoading() async {
    try {
      final result = await ProductRepo().getProducts(
        query: sc.text,
        page: page + 1,
      );

      setState(() {
        items.addAll(result);
        page++;
      });

      if (result.isEmpty) {
        return LoadStatus.noMore;
      } else {
        return LoadStatus.idle;
      }
    } catch (e) {
      return LoadStatus.failed;
    }
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.item,
  });

  final Product item;

  @override
  Widget build(BuildContext context) {
    final sm = ScaffoldMessenger.of(context);

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      onTap: () => goToForm(context),
      leading: Image.network(
        height: 50,
        width: 50,
        item.images?.first ?? '',
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.image,
          size: 50,
        ),
      ),
      title: Text(item.label ?? ''),
      subtitle: Text('Rp. ${item.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () => goToForm(context),
            icon: const Icon(Icons.edit),
          ),
          const Gap(5),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (context) => const DeleteDialog(),
            ).then(
              (value) {
                if (!(value ?? false)) return;

                try {
                  ProductRepo().deleteProduct(item.id ?? 0);

                  sm.showSnackBar(const SnackBar(
                    content: Text('Product deleted'),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  sm.showSnackBar(
                    const SnackBar(
                      content: Text('Error deleting product'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void goToForm(BuildContext context) {
    Navigator.pushNamed(context, 'product_form', arguments: {
      'product': item,
    });
  }
}
