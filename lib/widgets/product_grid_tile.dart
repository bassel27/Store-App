import 'package:flutter/material.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import '../models/product.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  const ProductGridTile(this.product);
  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
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
