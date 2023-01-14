import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/widgets/price_text.dart';

import '../providers/productNotifier.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = 'productDetail';
  @override
  Widget build(BuildContext context) {
    // TODO: use provider
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 9, left: 5, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.title,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                PriceText(product.price),
                Text("Descripton: ${product.description}"),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: kAccentColor, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 40,
            child: Center(
              child: Text(
                "ADD TO CART",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: kAccentColor,
                ),
                onPressed: () {},
                child: Text(
                  "ADD TO CART",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                )),
          )
        ],
      ),
    );
  }
}
