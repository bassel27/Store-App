import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/splash_screen.dart';
import 'package:store_app/widgets/auth_button.dart';

import '../providers/auth_notifier.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});
  static const route = 'verify_email';
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  void checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
  }

  Future sendVerificationEmail() async {
    await context.read<AuthNotifier>().sendVerificationEmail();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const SplashScreen()
        : Scaffold(
            appBar: AppBar(title: const Text("Verify Email")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Check your inbox for a verification email to complete your account setup.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthButton(
                        child: "Ok",
                        onPressed: () async {
                          await context.read<AuthNotifier>().logout();
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthButton(
                        child: "Resend Email",
                        onPressed: () {
                          sendVerificationEmail();
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
