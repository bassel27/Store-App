mixin AddTokenToUrl {
  String getTokenedUrl({required String url, required String token}) {
    return "$url?auth=$token";
  }
}
