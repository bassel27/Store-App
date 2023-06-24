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
const String kPlaceHolder = "assets/gifs/placeholder.gif";
const String kMyChatId = "NPk9JESVRMmRf533mww8";
const String kThemePreferenceKey = 'themePreference';
const double kPhotoPadding = 9;


const String kTermsAndConditions = '''
Please read these terms and conditions carefully before using our app.

1. **Acceptance of Terms**
   By downloading, installing, or using this app, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, please do not use the app.

2. **Applicability**
   These terms and conditions apply to all users of the app, including registered users and guests.

3. **User Responsibilities**
   - You are responsible for maintaining the confidentiality of your account credentials.
   - You agree not to use the app for any illegal or unauthorized purpose.
   - You agree not to interfere with the security or integrity of the app or its services.

4. **Intellectual Property**
   - All intellectual property rights related to the app, including trademarks, logos, and content, belong to the app's owner.
   - You may not copy, modify, distribute, or reproduce any part of the app without prior written permission.

5. **Privacy**
   - We respect your privacy and handle your personal information in accordance with our Privacy Policy.
   - By using the app, you consent to the collection, storage, and use of your personal information as described in the Privacy Policy.

6. **Disclaimer of Warranty**
   - The app is provided on an "as is" basis, without warranties of any kind.
   - We do not guarantee the accuracy, reliability, or availability of the app or its services.

7. **Limitation of Liability**
   - We are not liable for any damages or losses arising from your use of the app.
   - We are not responsible for any content posted by users or third parties.

8. **Modifications**
   - We reserve the right to modify or discontinue the app or its services at any time.
   - We may update these terms and conditions periodically, and your continued use of the app after any changes constitutes acceptance of those changes.
            ''';
