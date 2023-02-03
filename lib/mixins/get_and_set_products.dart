import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/products_notifier.dart';

mixin GetAndSetProducts {
  Future<void> getAndSetProducts(
      ProductsNotifier productsProvider, BuildContext context) {
    ProductsNotifier productsProvider =
        Provider.of<ProductsNotifier>(context, listen: false);
    if (!productsProvider.areProductsFetched) {
      return productsProvider.getAndSetProducts();
    } else {
      return Future.delayed(Duration.zero);
    }
  }
}
