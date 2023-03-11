import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/mixins/input_decration.dart';
import 'package:store_app/providers/auth_notifier.dart';
import 'package:store_app/widgets/auth_button.dart';

import '../helper/dialog_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with MyInputDecoration, ErrorHandler {
  final emailController = TextEditingController();
  //TODO: add dispose for all controllers used in the app
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Text(
              "Receive an email to\nreset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                decoration: inputDecoration(context:context, hintText:'Email', icon:Icon(Icons.email)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AuthButton(
                child: "Reset Password",
                onPressed: () async {
                  dismissKeyboard();
                  DialogHelper.showLoading();
                  try {
                    await Provider.of<AuthNotifier>(context, listen: false)
                        .resetPassword(emailController.text);
                    DialogHelper.hideCurrentDialog();
                    showSuccessDialog();
                  } on PlatformException catch (e) {
                    handleException(e);
                  } on FirebaseAuthException catch (e) {
                    handleException(e);
                  }
                }),
          ],
        ),
      ),
    );
  }

  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "An Email was sent to reset your password.",
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
