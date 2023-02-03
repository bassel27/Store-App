import 'package:flutter/material.dart';

import 'error_scaffold_body.dart';

class GetAndSetFutureBuilder extends StatelessWidget {
  const GetAndSetFutureBuilder({
    Key? key,
    required Future fetchAndSetProductsFuture,
    required Widget successfulScaffoldBody,
  })  : _fetchAndSetProductsFuture = fetchAndSetProductsFuture,
        _successfulWidgetBody = successfulScaffoldBody,
        super(key: key);

  final Future _fetchAndSetProductsFuture;
  final Widget _successfulWidgetBody;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _fetchAndSetProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorScaffoldBody(snapshot.error as Exception);
            } else {
              return _successfulWidgetBody;
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
