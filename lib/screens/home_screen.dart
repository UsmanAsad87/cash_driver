import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:action_slider/action_slider.dart';
import 'package:cash_driver/Models/RideModel.dart';
import 'package:cash_driver/constants.dart';
import 'package:cash_driver/resources/ride_methods.dart';
import 'package:cash_driver/screens/show_on_map_screen.dart';
import 'package:cash_driver/utils/loader.dart';
import 'package:cash_driver/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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
  String? currentLocation = 'Location';

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
            .listen((Position? position) async {
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

  Future<void> getCurrentLocation() async {
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      if (position != null) {
        List<Placemark> placeMarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        currentLocation =
            '${placeMarks[0].subLocality}, ${placeMarks[0].locality} ${placeMarks[0].country}';
        debugPrint('Address ${placeMarks[0].locality}');
        debugPrint('Address ${placeMarks[0].country}');
        debugPrint('Address ${placeMarks[0].subLocality}');
        setState(() {});
      } else {
        debugPrint('else state');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      body: Stack(
        children: [
          /// Map
          const Positioned(
              top: 0, left: 0, right: 0, bottom: 0, child: ShowOnMapScreen()),

          /// App bar
          Positioned(
            top: 12.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Home', style: kHeadingStyle1),
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
                          return Text(
                            '0 Points',
                            style: kBodyStyle7,
                          );
                        }
                        int point = 0;
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          RideModel ride =
                              RideModel.fromJson(snapshot.data!.docs[i].data());
                          point += int.parse(ride.points);
                        }
                        return Text(
                          '$point Points',
                          style: kBodyStyle7,
                        );
                      }),
                ],
              ),
            ),
          ),

          /// Location & Tracking Widget
          Positioned(
            bottom: 10.h,
            right: 10.w,
            left: 10.w,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: [
                /// Location & time widget
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23.r),
                          child: Image.asset('assets/homeCar.png'),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        flex: 3,
                        child: Text(
                          currentLocation!,
                          style: kBodyStyle8,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.hardEdge,
                            child: Text(
                              DateFormat.jm().format(DateTime.now()),
                              textAlign: TextAlign.end,
                              style: kBodyStyle7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Tracking widget
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06E96D).withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r)),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ready to go?',
                          style: kBodyStyle8,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Unlock the most premium experience by using Cash Driver',
                          style: kBodyStyle1,
                        ),
                      ),
                      SizedBox(height: 40.w),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ActionSlider.standard(
                          width: 300.w,
                          height: 65.h,
                          backgroundColor: _isTracking
                              ? Colors.white
                              : const Color(0xFF36B770),
                          toggleColor:
                              _isTracking ? kPrimaryColor : Colors.white,
                          actionThresholdType: ThresholdType.release,
                          child: _isTracking
                              ? const Text(
                                  'Slide to Stop Tracking',
                                  style: TextStyle(color: Colors.black),
                                )
                              : const Text('Slide to Start Tracking'),
                          action: (controller) async {
                            setState(() {
                              _isTracking = !_isTracking;
                            });
                            if (_isTracking == false) {
                              calTotalDistance();
                              print(totalDistance.toString().substring(0, 3));
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
                              if (totalDistance < 10) {
                                dis = totalDistance.toString().substring(0, 3);
                              } else if (totalDistance < 100) {
                                dis = totalDistance.toString().substring(0, 4);
                              } else {
                                dis = totalDistance.toString().substring(0, 5);
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
                            Position position = await _getGeoLocationPosition();
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
                      //SizedBox(height: 20.h),
                      // _isTracking
                      //     ? Expanded(
                      //         child: Align(
                      //             alignment: Alignment.centerRight,
                      //             child: InkWell(
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             const ShowOnMapScreen()));
                      //               },
                      //               child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: 4.sp, vertical: 2.sp),
                      //                 decoration: BoxDecoration(
                      //                     border: Border.all(
                      //                   color: kPrimaryColor,
                      //                   width: 2,
                      //                 )),
                      //                 child: Text(
                      //                   'Show on map',
                      //                   style: kBodyStyle5a,
                      //                 ),
                      //               ),
                      //             )),
                      //       )
                      //     : const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
