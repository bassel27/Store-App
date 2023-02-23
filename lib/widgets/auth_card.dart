import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/my_theme.dart';

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
  final _passwordController = TextEditingController(text: "qwerty");

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
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _EmailTextFormField(authData: _authData),
              _PasswordTextFormField(
                  passwordController: _passwordController,
                  authData: _authData,
                  submitFunction: _submit),
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
                ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGN UP',
                    style: const TextStyle(color: kTextLightColor),
                  ),
                ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: _switchAuthMode,
                child: Text(
                    '${_authMode == AuthMode.LOGIN ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.LOGIN) {
        // Log user in
        await Provider.of<AuthNotifier>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<AuthNotifier>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } catch (error) {
      handleError(error);
    }
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

class _PasswordTextFormField extends StatelessWidget {
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
      decoration: const InputDecoration(labelText: 'Password'),
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

class _EmailTextFormField extends StatelessWidget {
  const _EmailTextFormField({
    Key? key,
    required Map<String, String> authData,
  })  : _authData = authData,
        super(key: key);

  final Map<String, String> _authData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "bassel@hotmail.com",
      decoration: const InputDecoration(labelText: 'E-Mail'),
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
