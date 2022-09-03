import 'package:action_slider/action_slider.dart';
import 'package:cash_driver/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/homeBg.png"), fit: BoxFit.cover),
          ),
          child: Padding(
            padding:  EdgeInsets.all(10.h),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: kHeadingStyle1,
                    ),
                    Text(
                      '10 Points',
                      style: kBodyStyle7,
                    )
                  ],
                ),
              ),

              Spacer(),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 54.h,
                              width: 71.w,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(23.r),
                                child:
                                    Image.asset('assets/homeCar.png'),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LEK-626',
                                  style: kBodyStyle5,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'Liverpool, UK',
                                  style: kBodyStyle7,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 10.w,
                          bottom: 5.h,
                          child: Text(
                            '16:10 PM',
                            style: kBodyStyle7,
                          ))
                    ],
                  ),
                  Container(
                    height: 400.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: 77.h, horizontal: 36.w),
                    decoration: BoxDecoration(
                      color: Color(0xFF06E96D).withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r)),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to go?',
                          style: kBodyStyle8,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Unlock the most premium experience by using Cash Driver',
                          style: kBodyStyle1,
                        ),
                        SizedBox(height: 80.h,),
                        Center(
                          child: ActionSlider.standard(
                            width: 350.w,
                            height:70.h ,
                            backgroundColor: const Color(0xFF36B770),
                            toggleColor: Colors.white,
                            actionThresholdType: ThresholdType.release,
                            child: const Text('Slide to Start Tracking'),
                            action: (controller) async {
                              controller.loading(); //starts loading animation
                              await Future.delayed(const Duration(seconds: 3));
                              controller.success(); //starts success animation
                              await Future.delayed(const Duration(seconds: 1));
                              controller.reset(); //resets the slider
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final int kms;
  final int points;
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
