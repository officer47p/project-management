import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthType { SignUp, SignIn }

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    with TickerProviderStateMixin {
  bool _isInited = false;
  bool _isLoading = false;
  AuthType _authType = AuthType.SignIn;
  final formKey = GlobalKey<FormState>();
  String passRep = "";
  Map credentials = {};
  String errMsg;
  @override
  void didChangeDependencies() {
    if (!_isInited) {
      tryToSignIn();
      _isInited = true;
    }
    super.didChangeDependencies();
  }

  Future<void> tryToSignIn() async {
    setState(() {
      _isLoading = true;
    });
    final res = await Provider.of<Auth>(context).loadAuthData();
    setState(() {
      _isLoading = false;
    });
    // print(res);
  }

  Future<void> authenticate() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // print(credentials);
      setState(() {
        errMsg = null;
        _isLoading = true;
      });
      try {
        if (_authType == AuthType.SignIn) {
          await Provider.of<Auth>(context, listen: false).signIn(
            credentials["email"],
            credentials["password"],
          );
        } else if (_authType == AuthType.SignUp) {
          await Provider.of<Auth>(context, listen: false)
              .signUp(credentials["email"], credentials["password"]);
        }
      } catch (err) {
        // print(err);
        setState(
          () {
            errMsg = 'Authentication failed';
            if (err.toString().contains('EMAIL_EXISTS')) {
              errMsg = 'This email address is already in use.';
            } else if (err.toString().contains('INVALID_EMAIL')) {
              errMsg = 'This is not a valid email address';
            } else if (err.toString().contains('WEAK_PASSWORD')) {
              errMsg = 'This password is too weak.';
            } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
              errMsg = 'Could not find a user with that email.';
            } else if (err.toString().contains('INVALID_PASSWORD')) {
              errMsg = 'Invalid password.';
            }
          },
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/login.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height:
                  _isLoading ? MediaQuery.of(context).size.height * 0.2 : null,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: _isLoading ? 0 : 1,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _authType == AuthType.SignUp
                                ? "Sign Up"
                                : "Sign in",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontSize: 40,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (errMsg != null) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                errMsg,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Ubuntu"),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.pink, width: 3),
                                color: Colors.pink.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "Email",
                            ),
                            onSaved: (newValue) =>
                                credentials["email"] = newValue,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please Enter Your Email";
                              else if (value.contains("@") != true)
                                return "Please Enter A Valid Email Address";
                              else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "Password",
                            ),
                            obscureText: true,
                            onFieldSubmitted: _authType == AuthType.SignIn
                                ? (value) => authenticate()
                                : (val) {},
                            onSaved: (newValue) =>
                                credentials["password"] = newValue,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please Enter Your Password";
                              else if (value.length < 8)
                                return "A Password Must Be At Least 8 Characters";
                              else if (_authType == AuthType.SignUp &&
                                  value != passRep)
                                return "Passwords Don't match";
                              else
                                return null;
                            },
                          ),
                          if (_authType == AuthType.SignUp) ...[
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Ubuntu",
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "Repeat Password",
                              ),
                              obscureText: true,
                              onFieldSubmitted: _authType == AuthType.SignUp
                                  ? (value) => authenticate()
                                  : (val) {},
                              onChanged: (value) => passRep = value,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please Repeat Your Password";
                                else if (value.length < 8)
                                  return "A Password Must Be At Least 8 Characters";
                                else
                                  return null;
                              },
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            child: Text(
                              _authType == AuthType.SignUp
                                  ? "Sign Up"
                                  : "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Ubuntu",
                                fontSize: 20,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: authenticate,
                            color: Colors.pink,
                          ),
                          FlatButton(
                            child: Text(
                              _authType == AuthType.SignUp
                                  ? "Alredy have an account?"
                                  : "Don't have an account?",
                              style: TextStyle(fontFamily: "Ubuntu"),
                            ),
                            onPressed: () {
                              setState(() {
                                _authType = _authType == AuthType.SignIn
                                    ? AuthType.SignUp
                                    : AuthType.SignIn;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
