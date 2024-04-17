import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference _paymentStatus =
      FirebaseFirestore.instance.collection("payment");

  //READ USER DATA
  Stream<QuerySnapshot> getUserDetailsP(String value) {
    Query userstream = _userCollection.orderBy('firstName', descending: false);
    if (value.isNotEmpty) {
      String searchValue =
          value.toLowerCase(); // Convert search value to lowercase
      String endValue = searchValue.substring(0, searchValue.length - 1) +
          String.fromCharCode(
              searchValue.codeUnitAt(searchValue.length - 1) + 1);
      userstream = userstream.where('firstName',
          isGreaterThanOrEqualTo: searchValue, isLessThan: endValue);
    }
    return userstream.snapshots();
  }

  //READ PAYMENT STATUS
  Stream<DocumentSnapshot<Object?>> getPaymentStatusForMonth(
      String uid, String year, String month) {
    return _paymentStatus.doc(uid).collection(year).doc(month).snapshots();
  }

  //add new payment
  Future<void> addPaymentStatus(String userId, int month, int year) async {
    final String monthName = months[month];
    final DocumentReference userDocRef = _paymentStatus.doc(userId);

    try {
      // Ensure user document exists
      await userDocRef.get();

      // Set payment status for the specified month
      await userDocRef.collection(year.toString()).doc(monthName).set({
        'status': false,
      });

      // print(
      //     'DEBUG Payment status added successfully for $userId: $month/$year');
    } on FirebaseException catch (e) {
      // Handle specific Firebase errors or generic error
      print('DEBUG Error adding payment status: $e');
    } catch (e) {
      // Handle unexpected errors
      print('DEBUG An unexpected error occurred: $e');
    }
  }

  Future<void> updatePaymentStatus(
      String uid, int month, int year, bool status) async {
    // print('DEBUG: $status');
    // print('DEBUG:  Got into updatePaymentStatus: UID: $uid');
    try {
      final DocumentReference userDocRef = _paymentStatus.doc(uid);
      final String monthName = months[month];
      // print(
      //     'DEBUG:  YEAR $year AND MONTH $monthName AND STATUS $status AND UID $uid');

      userDocRef.collection(year.toString()).doc(monthName).set({
        'status': status,
      }, SetOptions(merge: true)).then((_) async {
        int? currentValue = await getMonthEarning(monthName, year.toString());
        // print('DEBUG:  CURRENT VALUE: $currentValue');

        if (status == true) {
          currentValue += 700;
        } else {
          currentValue -= 700;
        }
        currentValue = currentValue.clamp(0, double.infinity) as int;
        // print('DEBUG: UPDATED CURRENT VALUE: $currentValue');

        /// clamp: stays within the specified range, which is 0 to positive infinity in this case
        final earningsRef = _paymentStatus
            .doc('earning')
            .collection(year.toString())
            .doc(monthName);
        earningsRef.set({'value': currentValue}, SetOptions(merge: true));
        // print('DEBUG TOTAL VALUE IN  updatePaymentStatus $currentValue');
      });
    } catch (e) {
      print('DEBUG: UPDATE PAYMENT STATUS : $e');
    }
  }
  
  // Function to handle checkbox change
  Future<void> handleCheckboxChange(
      String uid, int month, int year, bool value) async {
    try {
      updatePaymentStatus(uid, month, year, value);
    } catch (_) {
      addPaymentStatus(uid, month, year);
    }
  }

  //DELETE PAYMENT OF THE USER
  Future<void> deletePaymentUser(String docID) {
    return _paymentStatus.doc(docID).delete();
  }

  Future<int> getMonthEarning(String monthName, String year) async {
    DocumentSnapshot earningsSnapshot = await _paymentStatus
        .doc('earning')
        .collection(year.toString())
        .doc(monthName)
        .get();
    if (earningsSnapshot.exists) {
      Map<String, dynamic> data =
          earningsSnapshot.data() as Map<String, dynamic>;
      int value = data['value']??0;
      return value;
    } else {
      return 0;
    }
  }

  //READ PAYMENT STATUS PER MONTH
  Future<DocumentSnapshot<Object?>> getMonthEarningPerMonth(
      String year, String month) async {
    // Get the document reference
    final docRef = _paymentStatus.doc('earning').collection(year).doc(month);

    // Get the snapshot using a Future
    final snapshot = await docRef.get();
    return snapshot;
  }
}
