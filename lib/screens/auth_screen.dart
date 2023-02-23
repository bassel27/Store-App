import 'package:flutter/material.dart';
import 'package:store_app/models/my_theme.dart';

import '../widgets/auth_card.dart';

// TODO: handle connection errros and use future builder
// TODO: refactor
class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 130, 196, 227),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const _BrandName(),
                  Expanded(child: AuthContainer()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandName extends StatelessWidget {
  const _BrandName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: const Center(
        child: Text(
          "Brandatak Store",
          style: TextStyle(
              color: kTextLightColor,
              fontWeight: FontWeight.w500,
              fontSize: 30),
        ),
      ),
    );
  }
}
