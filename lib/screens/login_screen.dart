import 'package:cash_driver/constants.dart';
import 'package:cash_driver/screens/forget_pass.dart';
import 'package:cash_driver/screens/main_menu.dart';
import 'package:cash_driver/screens/signup_screen.dart';
import 'package:cash_driver/utils/validator.dart';
import 'package:cash_driver/widgets/custom_button.dart';
import 'package:cash_driver/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/auth_methods.dart';
import '../utils/toast.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  GlobalKey<FormState> loginInKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 50.h),
                child: Container(
                  width: 360.w,
                  height: 113.h,
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            'assets/logo.png',
                          ))),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: (size.height * 0.25),
              child: Container(
                height: size.height - (size.height * 0.25),
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(5.w, -3.h),
                      blurRadius: 20.r,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          'Login',
                          style: kHeadingStyle1,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Form(
                          key: loginInKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: kHeadingStyle2,
                              ),
                              CustomTextField(
                                  validatorFn: emailValidator,
                                  obscure: false,
                                  controller: _emailController,
                                  hintText: 'Enter your email',
                                  onChanged: (val) {},
                                  onFieldSubmitted: (val) {}),
                              Text(
                                'Password',
                                style: kHeadingStyle2,
                              ),
                              // CustomTextField(
                              //     validatorFn: passValidator,
                              //     obscure: true,
                              //     controller: _passController,
                              //     hintText: 'Enter your password',
                              //     onChanged: (val) {},
                              //     onFieldSubmitted: (val) {}),
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h, top: 5.h),
                                padding: EdgeInsets.only(
                                    left: 20.w,
                                    top: 10.h,
                                    right: 10.w,
                                    bottom: 3.w),
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.w, 4.h),
                                      blurRadius: 50.r,
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  validator: passValidator,
                                  obscureText: obscure,
                                  controller: _passController,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: kBodyStyle1,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    alignLabelWithHint: true,
                                    hintStyle: kBodyStyle1a,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        obscure = !obscure;
                                        setState(() {});
                                      },
                                      icon: obscure
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: kPrimaryColor,
                                              size: 20,
                                            )
                                          : Icon(Icons.visibility,
                                              color: kPrimaryColor, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForgetPassScreen()));
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child:
                                  Text('Forget Password?', style: kBodyStyle2)),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                            child: CustomButton(
                                isLoading: _isLoading,
                                onPressed: () async {
                                  if (_emailController.text.isEmpty ||
                                      _passController.text.isEmpty) {
                                    showFlagMsg(
                                        context: context,
                                        msg: 'Enter all Fields',
                                        textColor: Colors.red);
                                    return null;
                                  }
                                  final form = loginInKey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    String res = await AuthMethods().loginUser(
                                        email: _emailController.text,
                                        password: _passController.text);
                                    if (res == "success") {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (!mounted) return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => MainMenu()));
                                    } else {
                                      showFlagMsg(
                                          context: context,
                                          msg: res,
                                          textColor: Colors.red);
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    showFlagMsg(
                                        context: context,
                                        msg: 'Required fields are missing',
                                        textColor: Colors.red);
                                  }
                                },
                                buttonText: 'Login')),
                        SizedBox(
                          height: 20.h,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10.h),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       InkWell(
                        //           onTap: () {},
                        //           child: Image.asset(
                        //             'assets/fb.png',
                        //             scale: 2,
                        //           )),
                        //       SizedBox(
                        //         width: 15.w,
                        //       ),
                        //       InkWell(
                        //           onTap: () {},
                        //           child: Image.asset(
                        //             'assets/twitter.png',
                        //             scale: 2,
                        //           )),
                        //       SizedBox(
                        //         width: 15.w,
                        //       ),
                        //       InkWell(
                        //           onTap: () {},
                        //           child: Image.asset(
                        //             'assets/linkedin.png',
                        //             scale: 2,
                        //           )),
                        //     ],
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {},
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Don’t have an account?',
                                  style: kBodyStyle2)),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                            child: CustomButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SignupScreen()));
                                },
                                buttonText: 'Sign Up')),
                        SizedBox(
                          height: 60.h,
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
