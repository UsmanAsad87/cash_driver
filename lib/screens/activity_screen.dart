import 'package:cash_driver/Models/RideModel.dart';
import 'package:cash_driver/constants.dart';
import 'package:cash_driver/screens/withdrawa_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/loader.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = '/activity_screen';

  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int withdrawalAmount = 0;

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
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Activity',
                            style: kHeadingStyle1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawalScreen(
                                          withdrawalAmount: withdrawalAmount,
                                        ))),
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
                                fillColor: const Color(0xFF0D2516),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WithdrawalScreen(
                                              withdrawalAmount:
                                                  withdrawalAmount,
                                            ))),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: SizedBox(
                                  height: 50.h,
                                  width: 150.w,
                                  child: Center(
                                    child:
                                        Text('Withdrawal', style: kBodyStyle3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
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
                          return Padding(
                              padding: EdgeInsets.all(30.h),
                              child: spinKit(color: kPrimaryColor));
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0.w, top: 30.h),
                                child: Text(
                                  'There are no Activities',
                                  style: kBodyStyle8,
                                ),
                              ));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            RideModel ride = RideModel.fromJson(
                                snapshot.data!.docs[index].data());

                            withdrawalAmount =
                                withdrawalAmount + int.parse(ride.points);
                            debugPrint('withdrawal amount: $withdrawalAmount');

                            return ActivityTile(
                                kms: ride.distance,
                                points: ride.points,
                                isAlert: ride.isSpeedLess20);
                          },
                        );
                      }),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String kms;
  final String points;
  final bool isAlert;

  const ActivityTile({
    Key? key,
    required this.kms,
    required this.points,
    required this.isAlert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Stack(
        children: [
          Container(
            height: 80.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF06E96D).withOpacity(0.4),
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
              children: [
                Image.asset('assets/car.png'),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '$kms Km',
                  style: kBodyStyle5,
                )
              ],
            ),
          ),
          if (isAlert)
            Positioned(
                right: 10.w,
                top: 10.h,
                child: Image.asset(
                  'assets/alert.png',
                  height: 30,
                  width: 30,
                )),
          Positioned(
              right: 10.w,
              bottom: 5.h,
              child: Text(
                '$points Points',
                style: kBodyStyle6,
              ))
        ],
      ),
    );
  }
}
