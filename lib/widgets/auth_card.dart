import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/error_handler.dart';
import '../providers/auth_notifier.dart';

enum AuthMode { SIGNUP, LOGIN }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with ErrorHandler {
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.SIGNUP ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SIGNUP ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _EmailTextFormField(authData: _authData),
                _PasswordTextFormField(
                    passwordController: _passwordController,
                    authData: _authData),
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
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGN UP'),
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
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      handleError(HttpException(errorMessage));
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
  const _PasswordTextFormField({
    Key? key,
    required TextEditingController passwordController,
    required Map<String, String> authData,
  })  : _passwordController = passwordController,
        _authData = authData,
        super(key: key);

  final TextEditingController _passwordController;
  final Map<String, String> _authData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
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
