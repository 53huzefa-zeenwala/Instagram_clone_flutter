import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_with_android/reponsive/auth_methods.dart';
import 'package:project_with_android/screens/login_screens.dart';
import 'package:project_with_android/utils/colors.dart';
import 'package:project_with_android/utils/utils.dart';
import 'package:project_with_android/widgets/text_field_input.dart';

import '../reponsive/mobile_screen_layout.dart';
import '../reponsive/responsive_layout.dart';
import '../reponsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectedImage() async {
    Uint8List image = await pickImage(null);
    setState(() {
      _image = image;
    });
  }

  Future<void> signupUser() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AuthMethods().signUpUser(
        email: _emailController.text, password: _passwordController.text, username: _usernameController.text, bio: _bioController.text, file: _image);

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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  width: 120,
                ),
                SizedBox(
                  height: 48,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(radius: 64, backgroundImage: MemoryImage(_image!))
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.6UhgwprABi3-dz8Qs85FvwHaHa?rs=1&pid=ImgDetMain'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          splashRadius: 0.1,
                          onPressed: selectedImage,
                          icon: const Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(textEditingController: _usernameController, hintText: 'Enter Your UserName', textInputType: TextInputType.name),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(textEditingController: _bioController, hintText: 'Enter Your Bio', textInputType: TextInputType.text),
                SizedBox(
                  height: 24,
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
                    onTap: signupUser,
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: _isLoading
                          ? SizedBox(
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : const Text('Sign Up'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text("Already have an account?"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      )),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text(
                          "Log in",
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
