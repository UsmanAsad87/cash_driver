import 'package:cash_driver/constants.dart';
import 'package:cash_driver/widgets/custom_button.dart';
import 'package:cash_driver/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

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
                        Text(
                          'Email',
                          style: kHeadingStyle2,
                        ),
                        CustomTextField(
                            obscure: false,
                            controller: _emailController,
                            hintText: 'Enter your email',
                            onChanged: (val) {},
                            onFieldSubmitted: (val) {}),
                        Text(
                          'Password',
                          style: kHeadingStyle2,
                        ),
                        CustomTextField(
                            obscure: true,
                            controller: _passController,
                            hintText: 'Enter your password',
                            onChanged: (val) {},
                            onFieldSubmitted: (val) {}),
                        InkWell(
                          onTap: () {},
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
                                onPressed: () {}, buttonText: 'Login')),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){},
                                  child: Image.asset(
                                'assets/fb.png',
                                    scale: 2,
                              )),
                              SizedBox(width: 15.w,),
                              InkWell(
                                  onTap: (){},
                                  child: Image.asset(
                                    'assets/twitter.png',
                                    scale: 2,
                                  )),
                              SizedBox(width: 15.w,),
                              InkWell(
                                  onTap: (){},
                                  child: Image.asset(
                                    'assets/linkedin.png',
                                    scale: 2,
                                  )),
                            ],
                          ),
                        ),
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
                                onPressed: () {}, buttonText: 'Sign Up')),
                        SizedBox(
                          height: 40.h,
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
