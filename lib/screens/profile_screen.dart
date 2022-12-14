import 'dart:typed_data';

import 'package:cash_driver/constants.dart';
import 'package:cash_driver/resources/auth_methods.dart';
import 'package:cash_driver/screens/login_screen.dart';
import 'package:cash_driver/utils/select_image.dart';
import 'package:cash_driver/widgets/custom_button.dart';
import 'package:cash_driver/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/RideModel.dart';
import '../Models/UserModel.dart';
import '../provider/user_provider.dart';
import '../utils/loader.dart';
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
  final TextEditingController _cryptoWalletKeyController =
      TextEditingController();
  Uint8List? _image;
  int point = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _addController.dispose();
    _cryptoWalletKeyController.dispose();
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
    _cryptoWalletKeyController.text = user.cryptoWalletKey;

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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.w, 4.h),
                            blurRadius: 4.r,
                            color: Colors.black.withOpacity(0.25),
                          )
                        ],
                      ),
                      child: RawMaterialButton(
                        elevation: 2,
                        fillColor: const Color(0xFF0D2516),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: SizedBox(
                          height: 50.h,
                          width: 150.w,
                          child: Center(
                            child: Text('Logout', style: kBodyStyle3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 60.r,
                                backgroundImage: MemoryImage(_image!))
                            : user.profilePic.isEmpty
                                ? CircleAvatar(
                                    radius: 60.r,
                                    backgroundImage:
                                        NetworkImage(networkImageUrl))
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
                                backgroundColor: kEditButtonColor,
                                child: Center(
                                    child: IconButton(
                                        onPressed: selectImage,
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: kPrimaryColor,
                                        )))))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('rides')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return spinKit();
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return PointsTile(
                              points: '0', dateTime: DateTime.now());
                        }

                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          RideModel ride =
                              RideModel.fromJson(snapshot.data!.docs[i].data());
                          point += int.parse(ride.points);
                        }
                        return PointsTile(
                            points: point.toString(), dateTime: DateTime.now());
                      }),
                  SizedBox(
                    height: 20.h,
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
                        // Text(
                        //   'Age',
                        //   style: kHeadingStyle3,
                        // ),
                        // CustomTextField2(
                        //     obscure: false,
                        //     controller: _ageController,
                        //     hintText: '',
                        //     onChanged: (val) {},
                        //     onFieldSubmitted: (val) {}),
                        // Text(
                        //   'Address',
                        //   style: kHeadingStyle3,
                        // ),
                        // CustomTextField2(
                        //     obscure: false,
                        //     controller: _addController,
                        //     hintText: '',
                        //     onChanged: (val) {},
                        //     onFieldSubmitted: (val) {}),
                        Text(
                          'Crypto Wallet Key',
                          style: kHeadingStyle3,
                        ),
                        CustomTextField2(
                            obscure: false,
                            inputType: TextInputType.phone,
                            controller: _cryptoWalletKeyController,
                            hintText: 'Crypto Wallet Key',
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
                                //_ageController.text.isEmpty ||
                                _nameController.text.isEmpty ||
                                //_phoneController.text.isEmpty ||
                                _cryptoWalletKeyController.text.isEmpty) {
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
                                  //age: _ageController.text,
                                  age: '',
                                  name: _nameController.text,
                                  // phoneNumber: _phoneController.text,
                                  phoneNumber: '',
                                  // address: _addController.text,
                                  address: '',
                                  cryptoWalletKey: '',
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

class PointsTile extends StatelessWidget {
  final String points;
  final DateTime dateTime;

  const PointsTile({
    Key? key,
    required this.points,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        height: 80.h,
        width: double.infinity,
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: kWhiteColor, //const Color(0xFF06E96D),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.w, 4.h),
              blurRadius: 4.r,
              color: Colors.black.withOpacity(0.25),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Stack(
                    children: [
                      Positioned(
                          left: 0,
                          bottom: -2.h,
                          child: Text(
                            '${DateFormat.MMMd().format(dateTime)} - ${DateFormat.jm().format(dateTime)}',
                            style: kBodyStyle6a,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Total Points',
                              style: kBodyStyle5a,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Text(
                points,
                style: kBodyStyle5a,
              ),
            )
          ],
        ),
      ),
    );
  }
}
