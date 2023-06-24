import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/models/my_theme.dart';

import 'FAB_back.dart';

// TODO: handle connection errros and use future builder
// TODO: refactor
class BrandatakStack extends StatelessWidget {
  final Widget child;
  final bool addBackButton;
  const BrandatakStack({required this.child, this.addBackButton = false});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: addBackButton
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Align(alignment: Alignment.topLeft, child: FABBack(34)),
            )
          : null,
      body: Stack(
        children: <Widget>[
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
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
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 25),
                    child: child,
                  )),
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
      margin: const EdgeInsets.only(top: 50, bottom: 40),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                "assets/images/shopping.png",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            RichText(
              text: TextSpan(
                //sourceSerif4
                style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                    color: kTextLightColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'BRAND'),
                  TextSpan(
                      text: 'atak',
                      style: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
