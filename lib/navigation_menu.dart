import 'package:flutter/material.dart';
import 'package:powerstone/pages/Starter/LoginPage.dart';
import 'package:powerstone/pages/chat_room.dart';
import 'package:powerstone/pages/comming_soon.dart';
import 'package:powerstone/pages/feedback.dart';
import 'package:powerstone/pages/home_page.dart';
import 'package:powerstone/pages/payment.dart';
import 'package:powerstone/pages/user_edit.dart';
import 'package:powerstone/services/notifications/push_notifications.dart';
import 'package:powerstone/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatefulWidget {
  final int initialPageIndex;
  const NavigationMenu({Key? key, this.initialPageIndex = 0}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentPage = 0;
  late final SharedPreferences prefs;
  FCMNotificationServices fcmNotificationServices = FCMNotificationServices();
  @override
  void initState() {
    super.initState();
    fcmNotificationServices.requestNotificationPermission();
    fcmNotificationServices.getDeviceToken();
    // fcmNotificationServices.isTokenRefresh();
    fcmNotificationServices.firebaseInit(context);
    fcmNotificationServices.setupInteractMessage(context);
    currentPage = widget.initialPageIndex;
  }

  Future<bool?> showLogoutConfirmation(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    return await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing without choosing an option
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: Text(
          'Are you sure you want to log out?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false), // Indicate user chose "Cancel"
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () async {
              prefs.remove('userID');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          const LoginPage()))); // Indicate user chose "Log Out"
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToPage(int pageIndex) {
    setState(() {
      currentPage = pageIndex;
    });
  }

  final pageWidgets = [
    const HomePage(),
    const EditProfile(),
    const PaymentPage(),
    const ChatRoom(),
    FeedbackPage(),
    const CommingSoon()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didpop) {
          showLogoutConfirmation(context);
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                pageWidgets[currentPage],
                SideBar(
                  isOpen: true,
                  onNavigate: navigateToPage,
                ),
              ],
            ),
          ),
        ));
  }
}
