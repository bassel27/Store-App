import 'package:flutter/material.dart';
import 'package:store_app/models/product.dart';

/// For TextFormField validators.
const TextStyle kErrorTextStyle =
    TextStyle(fontWeight: FontWeight.w400, color: Colors.red);

const String kCurrency = 'EGP';
const kBaseUrl = 'https://shop-app-f7639-default-rtdb.firebaseio.com';
final kProductsUri = Uri.parse(
    'https://shop-app-f7639-default-rtdb.firebaseio.com/products.json'); //create a products folder or add to it if it already exists
const kProductsUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/products.json';
const kOrdersUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/orders.json';
