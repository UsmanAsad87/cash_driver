import 'package:cash_driver/constants.dart';
import 'package:cash_driver/widgets/custom_button.dart';
import 'package:cash_driver/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _addController.dispose();
    _phoneController.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor2,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(networkImageUrl)),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),

                  Text(
                    'Full Name',
                    style: kHeadingStyle3,
                  ),
                  CustomTextField2(
                      obscure: false,
                      controller: _nameController,
                      hintText: '',
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {}),
                  Text(
                    'Email',
                    style: kHeadingStyle3,
                  ),
                  CustomTextField2(
                      obscure: false,
                      controller:_emailController,
                      hintText: '',
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {}),
                  Text(
                    'Age',
                    style: kHeadingStyle3,
                  ),
                  CustomTextField2(
                      obscure: false,
                      controller:_ageController,
                      hintText: '',
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {}),



                  Text(
                    'Address',
                    style: kHeadingStyle3,
                  ),
                  CustomTextField2(
                      obscure: false,
                      controller: _addController,
                      hintText: '',
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {}),

                  Text(
                    'Contact',
                    style: kHeadingStyle3,
                  ),
                  CustomTextField2(
                      obscure: false,
                      inputType: TextInputType.phone,
                      controller: _phoneController,
                      hintText: '',
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {}),
                  Center(
                      child: CustomButton(
                          onPressed: () {}, buttonText: 'Update Profile')),

                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
