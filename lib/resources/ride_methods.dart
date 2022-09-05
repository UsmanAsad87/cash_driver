import 'package:cash_driver/Models/RideModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class RideMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRide({
    required String distance,
    required bool isSpeedLess20,
    required String points,
  }) async {
    String res = "Some error occurred";
    try {
      var rideId = const Uuid().v4();

      RideModel ride = RideModel(
          dateTime: DateTime.now(),
          distance: distance,
          uid: rideId,
          isSpeedLess20: isSpeedLess20,
          points: points);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('rides')
          .doc(rideId)
          .set(ride.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
