import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/repository/product.dart';
import 'package:retrofit_demo/presentations/components/dialogs/delete_dialog.dart';
import 'package:retrofit_demo/presentations/components/layout/list_view.dart';

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
        // body: BlocConsumer<ProductBloc, ProductState>(
        //   listener: (context, state) => switch (state) {
        //     ProductStateComplete _ => Future.delayed(
        //         const Duration(seconds: 1),
        //         () {
        //           try {
        //             refreshController.requestRefresh();
        //           } catch (e) {
        //             context.read<ProductBloc>().add(ProductEventRefreshList());
        //           }
        //         },
        //       ),
        //     ProductListComplete _ => refreshController.twoLevelComplete(),
        //     ProductStateError _ => () {
        //         refreshController.loadFailed();
        //         refreshController.refreshFailed();
        //       },
        //     _ => null,
        //   },
        //   builder: (context, state) => Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(12.0),
        //         child: XSearchBar(
        //             // onSearch: (v) => context
        //             //     .read<ProductBloc>()
        //             //     .add(ProductEventFilterList(search: v)),
        //             ),
        //       ),
        //       Expanded(
        //         child: ProductListView(),
        //       ),
        //     ],
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // context.goNamed(Routes.addProduct);
          },
          // onPressed: () => context.goNamed(Routes.addProduct),
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
  final refreshController = RefreshController(initialRefresh: true);
  List<Product> items = [];
  final length = 10;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return XListView(
      refreshController: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      itemsCount: items.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProductListTile(item: items[i]),
      ),
    );
  }

  void onRefresh() async {
    final result = await ProductRepo().getProducts();

    setState(() {
      items.clear();
      items = result;
      page = 1;
    });

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    final result = await ProductRepo().getProducts(page: page + 1);

    items = items + result;
    refreshController.loadComplete();
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
    // final bloc = context.read<ProductBloc>();

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
      // onTap: () => context.goNamed(
      //   Routes.detailProduct,
      //   pathParameters: {'productId': item.id ?? ''},
      //   extra: item,
      // ),
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
            onPressed: () {},
            // onPressed: () => context.goNamed(
            //   Routes.detailProduct,
            //   pathParameters: {'productId': item.id ?? ''},
            //   extra: item,
            // ),
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
            )
            // .then(
            //   (value) => (value ?? false)
            //       ? bloc.add(ProductEventDeleteProduct(item.id ?? ''))
            //       : null,
            // )
            ,
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
