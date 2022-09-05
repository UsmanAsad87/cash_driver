import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:cash_driver/constants.dart';
import 'package:cash_driver/resources/ride_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;

import '../utils/toast.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> data = [];
  double totalDistance = 0;
  double points = 0;
  bool _isTracking = false;
  bool _isSpeedLess20 = false;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
  );

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calTotalDistance() {
    for (var i = 0; i < data.length - 1; i++) {
      //print(data[i]["lat"].toString()+' '+data[i]["lng"].toString()+' '+data[i+1]["lat"].toString()+' '+ data[i+1]["lng"].toString());
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
          data[i + 1]["lat"], data[i + 1]["lng"]);
      if (data[i]["speed"] > 20) {
        points += calculateDistance(data[i]["lat"], data[i]["lng"],
            data[i + 1]["lat"], data[i + 1]["lng"]);
      } else {
        _isSpeedLess20 = true;
      }
    }
    //print(totalDistance);
    return totalDistance;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (_isTracking) {
        if (position != null) {
          // print('${position.latitude.toString()}, ${position.longitude
          //     .toString()},${position.speed}');

          data.add({
            'lat': position.latitude,
            'lng': position.longitude,
            'speed': position.speed * 3.6
          });
        }
      }
    });
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

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
            padding: EdgeInsets.all(10.h),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
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
                                borderRadius: BorderRadius.circular(23.r),
                                child: Image.asset('assets/homeCar.png'),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                            DateFormat.jm().format(DateTime.now()),
                            style: kBodyStyle7,
                          ))
                    ],
                  ),
                  Container(
                    height: 400.h,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 77.h, horizontal: 36.w),
                    decoration: BoxDecoration(
                      color: Color(0xFF06E96D).withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: 80.h,
                        ),
                        Center(
                          child: ActionSlider.standard(
                            width: 350.w,
                            height: 70.h,
                            backgroundColor: _isTracking? Colors.red.withOpacity(0.5):const Color(0xFF36B770),
                            toggleColor: Colors.white,
                            actionThresholdType: ThresholdType.release,
                            child: _isTracking
                                ? const Text('Slide to Stop Tracking',style: TextStyle(color: Colors.white),)
                                : const Text('Slide to Start Tracking'),
                            action: (controller) async {
                              setState(() {
                                _isTracking = !_isTracking;
                              });
                              if (_isTracking == false) {
                                calTotalDistance();
                                print(totalDistance.toString().substring(0,3));
                                print(points);
                                print(_isSpeedLess20.toString());

                                if (totalDistance == 0 || points == 0) {
                                  showFlagMsg(
                                      context: context,
                                      msg: 'Distance Tracked is 0',
                                      textColor: Colors.red);
                                  return null;
                                }
                                String dis;
                                if(totalDistance<10){
                                  dis=totalDistance.toString().substring(0,3);
                                }else if(totalDistance<100){
                                  dis=totalDistance.toString().substring(0,4);
                                }else{
                                  dis=totalDistance.toString().substring(0,5);
                                }
                                String res = await RideMethods().createRide(
                                    distance: dis,
                                    isSpeedLess20: _isSpeedLess20,
                                    points: points.toInt().toString());
                                if (res != 'success') {
                                  showFlagMsg(
                                      context: context,
                                      msg: res,
                                      textColor: Colors.red);
                                } else {
                                  showToast('Tracked data saved Successfully');
                                }
                                return;
                              }
                              data.clear();
                              totalDistance = 0;
                              points = 0;
                              _isSpeedLess20 = false;

                              controller.loading(); //starts loading animation
                              Position position =
                                  await _getGeoLocationPosition();
                              // String location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                              // print(location);

                              controller.success(); //starts success animation
                              await Future.delayed(const Duration(seconds: 1));
                              controller.reset(); //resets the slider

                              // while (_isTracking) {
                              //   await Future.delayed(const Duration(seconds: 5));
                              //   position = await _getGeoLocationPosition();
                              //   location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                              //   print(location);
                              // }
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
