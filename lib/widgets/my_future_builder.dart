import 'package:flutter/material.dart';

import 'error_scaffold_body.dart';

// TODO: snackbar disappear on changing screen. (not here)
class ScaffoldFutureBuilder extends StatelessWidget {
  const ScaffoldFutureBuilder({
    Key? key,
    required this.future,
    required this.onSuccessWidget,
    this.onLoadingWidget = const CircularProgressIndicator(),
    this.onFailureWidget,
    this.appBar,
  });

  final Future future;
  /// Shouldn't be a screen.
  final Widget onSuccessWidget;
  final Widget onLoadingWidget;
  final AppBar? appBar;
  final Widget? onFailureWidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return onLoadingWidget;
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return onFailureWidget ??
                    ErrorScaffoldBody(snapshot.error as Exception);
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
