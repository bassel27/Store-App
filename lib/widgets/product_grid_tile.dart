import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context,
        listen:
            false); // the whole build method executes whenever this data changes if listen is true // listen: false to get the data which don't change (everything except is Favorite) so as not to rebuild
    final Cart cart = Provider.of<Cart>(context,
        listen:
            false); // you only add to the cart in this widget so there's no need to lsiten
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.route, arguments: product);
        },
        child: GridTile(
          footer: GridTileBar(
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
              },
            ),
            leading: Consumer<Product>(
              // this is the only part that will get rebuilt because this is what we need to change. Everything else doesn't change. Listen is always true in consumer another way to rebuild this part only is to place the following widgets in a separate file and use Provider.of(context) such that this file rebuilds itself without affecting the rest. // With consumer, you can split your widget such that only the part in the builder gets rebuilt
              builder: (context, product, _) => IconButton(
                // child is a reference to the Consumer's child property which doesn't rebuild
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
              ),
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
