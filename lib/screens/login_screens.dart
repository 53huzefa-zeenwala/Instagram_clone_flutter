import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_with_android/screens/signup_screen.dart';
import 'package:project_with_android/utils/colors.dart';
import 'package:project_with_android/widgets/text_field_input.dart';

import '../reponsive/auth_methods.dart';
import '../reponsive/mobile_screen_layout.dart';
import '../reponsive/responsive_layout.dart';
import '../reponsive/web_screen_layout.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (mounted && res != 'Success') {
      showSnackbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            constraints: BoxConstraints(maxWidth: 500),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  width: 120,
                ),
                SizedBox(
                  height: 64,
                ),
                TextFieldInput(textEditingController: _emailController, hintText: 'Enter Your Email', textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _passwordController, hintText: 'Enter Your Password', textInputType: TextInputType.visiblePassword),
                SizedBox(
                  height: 24,
                ),
                Material(
                  color: blueColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Colors.grey,
                    onTap: loginUser,
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: _isLoading
                          ? SizedBox(
                              width: 18,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : const Text('Log In'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text("Don't have an account?"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      )),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
