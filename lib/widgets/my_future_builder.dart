import 'package:flutter/material.dart';

import 'error_scaffold_body.dart';

// TODO: snackbar disappear on changing screen. (not here)
class ScaffoldFutureBuilder extends StatelessWidget {
  const ScaffoldFutureBuilder({
    Key? key,
    required this.getAndSetProductsFuture,
    required this.onSuccessWidget,
    this.onLoadingWidget = const CircularProgressIndicator(),
    this.appBar,
  });

  final Future getAndSetProductsFuture;
  final Widget onSuccessWidget;
  final Widget onLoadingWidget;
  final AppBar? appBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: FutureBuilder(
          future: getAndSetProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return onLoadingWidget;
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScaffoldBody(snapshot.error as Exception);
              } else {
                return onSuccessWidget;
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
