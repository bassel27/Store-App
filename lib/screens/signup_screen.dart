import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/models/user/user.dart';
import 'package:store_app/screens/verifyEmailScreen.dart';
import 'package:store_app/widgets/auth_button.dart';
import 'package:uuid/uuid.dart';

import '../mixins/input_decration.dart';
import '../providers/auth_notifier.dart';

class SignupScreen extends StatelessWidget
    with MyInputDecoration, ErrorHandler {
  SignupScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController(text: "qwerty");
  User editedUser = User(
      email: '',
      firstName: '',
      lastName: '',
      id: const Uuid().v4(),
      password: '');
  late String password;
  final SizedBox mySizedBox = const SizedBox(
    height: 30,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create an account")),
      body: Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            children: [
              TextFormField(
                decoration:
                    inputDecoration(context, "First Name", Icons.person),
                initialValue: "bassel",
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your first name!';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    editedUser =
                        editedUser.copyWith(firstName: capitalize(value));
                  }
                },
              ),
              mySizedBox,
              TextFormField(
                decoration:
                    inputDecoration(context, "Last Name", Icons.person_add),
                initialValue: "attia",
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your last name!';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    editedUser =
                        editedUser.copyWith(lastName: capitalize(value));
                  }
                },
              ),
              mySizedBox,
              TextFormField(
                decoration: inputDecoration(context, "Email", Icons.email),
                initialValue: "bassel_sabour@hotmail.com",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    editedUser = editedUser.copyWith(email: value);
                  }
                },
              ),
              mySizedBox,
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration:
                    inputDecoration(context, "Password", Icons.password),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No password entered";
                  } else if (value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
              ),
              mySizedBox,
              TextFormField(
                obscureText: true,
                decoration: inputDecoration(
                    context, "Confirm password", Icons.password),
                initialValue: "qwerty",
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    editedUser = editedUser.copyWith(password: value);
                  }
                },
              ),
              mySizedBox,
              AuthButton(
                  child: "Finish setting up",
                  onPressed: () async {
                    try {
                      await _submitForm(context);
                    } on PlatformException catch (e) {
                      handleError(e);
                    } on FirebaseAuthException catch (e) {
                      handleError(e);
                    }
                  }),
            ]),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await Provider.of<AuthNotifier>(context, listen: false)
          .signup(editedUser);
      Navigator.pushReplacementNamed(
        context,
        VerifyEmailPage.route,
      );
    } on PlatformException catch (e) {
      handleError(e);
    } on FirebaseAuthException catch (e) {
      handleError(e);
    }
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
