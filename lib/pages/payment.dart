import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:powerstone/services/payment/payment_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String userID = '';
  late Razorpay _razorpay;
  late List<bool> paymentStatus; // List to store payment status for each month
  late int currentYear;
  int selectedMonth = DateTime.now().month;

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

  final PaymentService paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    getUserDetails().then((value) => getMontlyPayments());
    initializePaymentStatus();
  }

  Future<void> getUserDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String docID = prefs.getString('userID') ?? '';
      if (docID.isNotEmpty) {
        setState(() {
          userID = docID;
        });
      } else {
        debugPrint('Error: docID is empty');
      }
    } catch (e) {
      debugPrint('Error retrieving userID: $e');
    }
  }

  // Initialize payment status list with default value (false for unpaid)
  void initializePaymentStatus() {
    paymentStatus =
        List.generate(12, (index) => false); // Assuming 12 months in a year
  }

  Future<Stream<DocumentSnapshot<Object?>>> getMontlyPayments() async {
    return FirebaseFirestore.instance
        .collection('payment')
        .doc(userID)
        .collection(currentYear.toString())
        .doc(selectedMonth.toString())
        .snapshots();
  }

  Future<bool> getPaymentStatus(String userID, int year, String month) async {
    try {
      // Reference to the document containing the status
      DocumentReference paymentRef = FirebaseFirestore.instance
          .collection('payment')
          .doc(userID)
          .collection(year.toString())
          .doc(month);

      // Get the document snapshot
      DocumentSnapshot snapshot = await paymentRef.get();

      // Check if the document exists and has a 'status' field
      if (snapshot.exists && snapshot.data() != null) {
        // Cast the data to Map<String, dynamic>
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('status')) {
          // Get the value of the 'status' field
          bool status = data['status'];
          return status;
        }
      }
      // If the document or 'status' field doesn't exist, return false
      return false;
    } catch (e) {
      // Handle any errors
      print('Error getting payment status: $e');
      return false;
    }
  }

  void openCheckout(amount, month, year) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_4ysa6m6EcW5Nyc',
      'amount': amount,
      'name': 'Powerstone',
      'prefill': {'contact': '123456789', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm', 'gpay']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Successful${response.paymentId!}',
        toastLength: Toast.LENGTH_SHORT);
        paymentService.updatePaymentStatus(userID,selectedMonth - 1,currentYear,true);
    // Update payment status for selected month and year
    setState(() {});
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Error: ${response.message!}',
        toastLength: Toast.LENGTH_SHORT);
    debugPrint('DEBUG MESSAGE: ${response.message!}');
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Successful${response.walletName!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Payment Status'),
        actions: [
          DropdownButton<int>(
            value: currentYear,
            onChanged: (int? year) {
              setState(() {
                currentYear = year!;
                // Reset payment status for the new selected year
                initializePaymentStatus();
              });
            },
            items: List.generate(
              10,
              (index) => DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString()),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Payment\'s in $currentYear',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: List.generate(
                  12,
                  (index) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${DateFormat.MMMM().format(DateTime(currentYear, index + 1))}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<bool>(
                            future: getPaymentStatus(
                                userID, currentYear, months[index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasData) {
                                  if (snapshot.data!) {
                                    return Center(
                                      child: Text(
                                        'Paid',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Colors.green,
                                                fontSize: 28),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 35,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Pass the selected month and year to openCheckout
                                          setState(() {
                                            selectedMonth = index + 1;
                                          });
                                          debugPrint(
                                              'DEBUG month: ${months[selectedMonth - 1]} and year $currentYear');
                                          openCheckout(
                                              700, selectedMonth, currentYear);
                                        },
                                        child: const Text('Pay'),
                                      ),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text('No Data');
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
