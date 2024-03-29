import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products_provider.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';
import 'package:shop_flutter_app/widget/app_drawer.dart';
import 'package:shop_flutter_app/widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const pathName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true),
          child: FutureBuilder(
            future: Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<ProductsProvider>(
                  builder: (ctx, products, child) => _generateListView(products),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          )),
    );
  }

  Widget _generateListView(ProductsProvider provider) {
    return ListView.builder(
      itemBuilder: (_, index) => Column(
        children: <Widget>[
          UserProductItem(
              provider.products[index].title,
              provider.products[index].imageUrl,
              provider.products[index].id),
          Divider(),
        ],
      ),
      padding: EdgeInsets.all(8),
      itemCount: provider.products.length,
    );
  }
}
