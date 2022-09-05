import 'dart:typed_data';

import 'package:cash_driver/constants.dart';
import 'package:cash_driver/resources/auth_methods.dart';
import 'package:cash_driver/utils/select_image.dart';
import 'package:cash_driver/widgets/custom_button.dart';
import 'package:cash_driver/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Models/UserModel.dart';
import '../provider/user_provider.dart';
import '../utils/toast.dart';

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
  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _addController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _ageController.text = user.age;
    _addController.text = user.address;
    _phoneController.text = user.phoneNumber;

    bool _isLoading = false;
    GlobalKey<FormState> profileKey = GlobalKey<FormState>();

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
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                            radius: 60.r, backgroundImage: MemoryImage(_image!))
                            : user.profilePic.isEmpty
                            ? CircleAvatar(
                            radius: 60.r,
                            backgroundImage: NetworkImage(networkImageUrl))
                            : CircleAvatar(
                            radius: 60.r,
                            backgroundImage: NetworkImage(
                              user.profilePic,
                            )),
                        Positioned(
                            right: 2,
                            bottom: 2,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor:kEditButtonColor,
                                child: Center(
                                    child: IconButton(
                                        onPressed: selectImage,
                                        icon:  Icon(
                                          Icons.edit,
                                          size: 15,
                                          color:
                                          kPrimaryColor,
                                        )))))

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Form(
                    key: profileKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            controller: _emailController,
                            hintText: '',
                            onChanged: (val) {},
                            onFieldSubmitted: (val) {}),
                        Text(
                          'Age',
                          style: kHeadingStyle3,
                        ),
                        CustomTextField2(
                            obscure: false,
                            controller: _ageController,
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
                      ],
                    ),
                  ),
                  Center(
                      child: CustomButton(
                          isLoading: _isLoading,
                          onPressed: () async {
                            if (_emailController.text.isEmpty ||
                                _ageController.text.isEmpty ||
                                _nameController.text.isEmpty ||
                                _phoneController.text.isEmpty ||
                                _addController.text.isEmpty) {
                              showFlagMsg(
                                  context: context,
                                  msg: 'Enter all required fields',
                                  textColor: Colors.red);
                              return null;
                            }
                            final form = profileKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              setState(() {
                                _isLoading = true;
                              });
                              String res = await AuthMethods().updateUser(
                                  file: _image,
                                  email: _emailController.text,
                                  age: _ageController.text,
                                  name: _nameController.text,
                                  phoneNumber: _phoneController.text,
                                  address: _addController.text,
                                  context: context,
                                  userdata: user);
                              setState(() {
                                _isLoading = false;
                              });
                              if (res != 'success') {
                                showFlagMsg(
                                    context: context,
                                    msg: res,
                                    textColor: Colors.red);
                              } else {
                                showToast('Account Updated Successfully');
                              }
                            } else {
                              showFlagMsg(
                                  context: context,
                                  msg: 'Required fields are missing',
                                  textColor: Colors.red);
                            }
                          },
                          buttonText: 'Update Profile')),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
