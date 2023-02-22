import 'package:flutter/material.dart';

/// For TextFormField validators.
const TextStyle kErrorTextStyle =
    TextStyle(fontWeight: FontWeight.w400, color: Colors.red);
// TODO: put constant urls in the files where they are used.
const String kCurrency = 'EGP';
const kBaseUrl = 'https://shop-app-f7639-default-rtdb.firebaseio.com';

const kProductsUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/products.json';
const kOrdersUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/orders.json';
const String kCartUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/cart.json';
const String kCartBaseUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/cart';
const kOrdersBaseUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/orders';
const kUserFavoritesBaseUrl = "$kBaseUrl/userFavorites/";
const kProductsBaseUrl =
    'https://shop-app-f7639-default-rtdb.firebaseio.com/products';
const String kErrorMessage =
    "Oops! Something went wrong. Check your internet connection and try again.";

/// Default timeout duration for http requests in seconds.
const int kDefaultTimeOutDuation = 5;
const kSignUpUrl =
    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCijND-gjHHDpFCYjm0_IVhn0hWBQqAQrM";
const kLoginUrl =
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCijND-gjHHDpFCYjm0_IVhn0hWBQqAQrM";
