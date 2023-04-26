import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:store_app/mixins/input_decration.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/screens/forgot_password_screen.dart';
import 'package:store_app/screens/signup_screen.dart';
import 'package:store_app/widgets/wide_elevated_button.dart';

import '../providers/auth_notifier.dart';

// TODO: handle connection errros and use future builder
// TODO: refactor
class AuthScreen extends StatelessWidget {
  static const route = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  Expanded(child: _AuthContainer()),
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

final GlobalKey<FormState> _formKey = GlobalKey();

class _AuthContainer extends StatelessWidget {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      // height: _authMode == AuthMode.SIGNUP ? 320 : 260,
      // constraints:
      //     BoxConstraints(minHeight: _authMode == AuthMode.SIGNUP ? 320 : 260),
      // width: deviceSize.width * 0.75,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Log in\nto your account",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              _EmailTextFormField(authData: _authData),
              const SizedBox(
                height: 17,
              ),
              _PasswordTextFormField(
                  authData: _authData, submitFunction: _submitForm),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(),
                  )),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              WideElevatedButton(
                onPressed: () {
                  _submitForm(context);
                },
                child: 'LOGIN',
              ),
              const SizedBox(
                height: 30,
              ),
              const _NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    // Log user in
    await Provider.of<AuthNotifier>(context, listen: false).login(
      _authData['email']!,
      _authData['password']!,
    );
  }
}

class _NoAccountText extends StatelessWidget {
  const _NoAccountText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(
              color: kTextDarkColor, fontSize: 15, fontWeight: FontWeight.w400),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignupScreen()));
                  },
                text: "Register Now",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w600))
          ]),
    );
  }
}

class _PasswordTextFormField extends StatelessWidget with MyInputDecoration {
  const _PasswordTextFormField(
      {Key? key,
      required Map<String, String> authData,
      required Function submitFunction})
      : _authData = authData,
        _submitFunction = submitFunction,
        super(key: key);

  final Map<String, String> _authData;
  final Function _submitFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: 'qwerty',
      decoration: authenticationInputDecoration(
          context: context,
          hintText: 'Password',
          icon: const Icon(Icons.password)),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _submitFunction(context);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _authData['password'] = value;
        }
      },
    );
  }
}

class _EmailTextFormField extends StatelessWidget with MyInputDecoration {
  const _EmailTextFormField({
    Key? key,
    required Map<String, String> authData,
  })  : _authData = authData,
        super(key: key);

  final Map<String, String> _authData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: 'bassel_sabour@hotmail.com',
      decoration: authenticationInputDecoration(
          context: context, hintText: 'Email', icon: const Icon(Icons.email)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        //TODO: email verification
        if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
          return 'Enter your email!';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _authData['email'] = value;
        }
      },
    );
  }
}
