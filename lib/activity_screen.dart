import 'package:cash_driver/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = '/activity_screen';
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
                    height: 20.h,
                  ),
                  Text(
                    'Activity',
                    style: kHeadingStyle1,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                      itemBuilder:(context,index){
                    return ActivityTile(kms: 250,  points: 20, isAlert: index%2==0?true:false);
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
  final int kms;
  final int points;
  final bool isAlert;
  const ActivityTile({
    Key? key, required this.kms, required this.points, required this.isAlert,
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
          if(isAlert)
          Positioned(
              right: 10.w,
              top: 10.h,
              child: Image.asset('assets/alert.png',height: 30,width: 30,)),
          Positioned(
              right: 10.w,
              bottom: 5.h,
              child: Text('$points Points',style: kBodyStyle6,))

        ],
      ),
    );
  }
}
