import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this.hasAccount, {super.key});
  final bool hasAccount;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _enteredEmail;
  var _enteredPassword;
  var _enteredUsername;
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.hasAccount ? 'Sign In' : 'Sign Up',
                style: const TextStyle(fontFamily: 'Pizzaman', fontSize: 30),
              ),
              const SizedBox(
                height: 100,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 84, 80, 80)),
                          ),
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) {
                          if (val == null ||
                              val.trim().isEmpty ||
                              !EmailValidator.validate(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _enteredEmail = val;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      if (!widget.hasAccount)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (val) {
                            if (val == null ||
                                val.trim().isEmpty ||
                                val.length < 8 ||
                                val.length > 20) {
                              return 'Please enter a valid username';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _enteredUsername = val;
                          },
                        ),
                      if (!widget.hasAccount) const SizedBox(height: 40),
                      TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password_rounded),
                        ),
                        autocorrect: false,
                        obscureText: true,
                        validator: (val) {
                          if (val == null ||
                              val.trim().isEmpty ||
                              val.length < 8) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _enteredPassword = val;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                              widget.hasAccount ? 'Login' : 'Create an account',
                              style: const TextStyle(
                                  fontFamily: 'Pizzaman', fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '- OR -',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.hasAccount ? 'Sign In with' : 'Sign Up with',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      'assets/images/google_logo.jpg',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/apple_logo.png')),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
