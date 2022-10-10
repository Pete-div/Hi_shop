import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';

enum AuthMode { signUp, logIn }

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(225, 120, 300, 1).withOpacity(0.5),
                Color.fromRGBO(225, 120, 300, 1).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 80),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2)),
                        ]),
                    child: Text(
                      'My Shop',
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'ZakirahsBold',
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;

  final _passwordController = TextEditingController();
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 280), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));

    //   // _heightAnimation!.addListener(() {
    //   //   setState(() {

    //   //   });
    //   // });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _showErroDialog(String message) {
    showDialog(
      context: context,
      builder: (CTX) => AlertDialog(
        title: Text('An Error occurred!'),
        content: Text(message),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.logIn) {
// login
        await Provider.of<Auth>(context, listen: false).logIn(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        //  sign up
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INAVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErroDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you.Please try again later';
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (ctx, ch) => Container(
            height: _heightAnimation!.value.height,
            constraints:
                BoxConstraints(minHeight: _heightAnimation!.value.height),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16),
            child: ch),
        // AnimatedContainer(
        //   duration: Duration(milliseconds: 300),
        //   curve: Curves.fastOutSlowIn,
        //   height: _authMode == AuthMode.signUp ? 320 : 260,
        //     // height:  _heightAnimation!.value.height,
        //   constraints:
        //       BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
        //   width: deviceSize.width * 0.75,
        //   padding: EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email';
                  }
                },
                onSaved: (value) {
                  _authData['email'] = value as String;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password too short';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value as String;
                },
              ),
              // if (_authMode == AuthMode.signUp)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signUp ? 120 : 0),
                curve: Curves.easeIn,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                      enabled: _authMode == AuthMode.signUp,
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Password do not match!';
                              }
                            }
                          : null),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                OutlinedButton(
                  onPressed: _submit,
                  child:
                      Text(_authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP '),
                ),
              Padding(
                child: OutlinedButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.logIn ? 'SIGN UP' : 'LOGIN'} Instead'),
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              )
            ],
          )),
        ),
      ),
    );
  }
}
