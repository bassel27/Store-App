import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/mixins/input_decration.dart';
import 'package:store_app/models/my_theme.dart';
import 'package:store_app/screens/signup_screen.dart';
import 'package:store_app/widgets/auth_button.dart';

import '../controllers/error_handler.dart';
import '../providers/auth_notifier.dart';

enum AuthMode { SIGNUP, LOGIN }

class AuthContainer extends StatefulWidget {
  @override
  _AuthContainerState createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> with ErrorHandler {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController(
      // text: "qwerty"
      );

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
                  passwordController: _passwordController,
                  authData: _authData,
                  submitFunction: _submitForm),
              if (_authMode == AuthMode.SIGNUP)
                _ReenterPasswordTextFormField(
                    authMode: _authMode,
                    passwordController: _passwordController),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                AuthButton(
                  onPressed: _submitForm,
                  child: _authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGN UP',
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

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // Log user in
    await Provider.of<AuthNotifier>(context, listen: false).login(
      _authData['email']!,
      _authData['password']!,
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() {
        _authMode = AuthMode.SIGNUP;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LOGIN;
      });
    }
  }
}

class _ReenterPasswordTextFormField extends StatelessWidget {
  const _ReenterPasswordTextFormField({
    Key? key,
    required AuthMode authMode,
    required TextEditingController passwordController,
  })  : _authMode = authMode,
        _passwordController = passwordController,
        super(key: key);

  final AuthMode _authMode;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: _authMode == AuthMode.SIGNUP,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      validator: _authMode == AuthMode.SIGNUP
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
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
          style: const TextStyle(color: kTextDarkColor, fontSize: 15),
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
      required TextEditingController passwordController,
      required Map<String, String> authData,
      required Function submitFunction})
      : _passwordController = passwordController,
        _authData = authData,
        _submitFunction = submitFunction,
        super(key: key);

  final TextEditingController _passwordController;
  final Map<String, String> _authData;
  final Function _submitFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: inputDecoration(context, 'Password', Icons.password),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _submitFunction();
      },
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Password is too short!';
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
      decoration: inputDecoration(context, 'Email', Icons.email),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        //TODO: email verification
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
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
