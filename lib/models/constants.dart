import 'package:flutter/material.dart';

/// For TextFormField validators.
const TextStyle kErrorTextStyle =
    TextStyle(fontWeight: FontWeight.w400, color: Colors.red);
// TODO: put constant urls in the files where they are used.
const String kCurrency = 'EGP';
const kBaseUrl = 'https://shop-app-f7639-default-rtdb.firebaseio.com';
const kProductsUrl = '$kBaseUrl/products.json';
const kOrdersUrl = '$kBaseUrl/orders.json';
const String kCartUrl = '$kBaseUrl/cart.json';
const String kCartBaseUrl = '$kBaseUrl/cart';
const kOrdersBaseUrl = '$kBaseUrl/orders';
const kUserFavoritesBaseUrl = "$kBaseUrl/userFavorites";
const kProductsBaseUrl = '$kBaseUrl/products';
const String kErrorMessage =
    "Oops! Something went wrong. Check your internet connection and try again.";

/// Default timeout duration for http requests in seconds.
const int kDefaultTimeOutDuation = 5;
const kWebApiKey = "AIzaSyCijND-gjHHDpFCYjm0_IVhn0hWBQqAQrM";
const kSignUpUrl =
    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$kWebApiKey";
const kLoginUrl =
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$kWebApiKey";
