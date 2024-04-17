import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/common/menu_item.dart';
import 'package:powerstone/pages/Starter/LoginPage.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  final Function(int) onNavigate;
  final bool isOpen; // Received from NavigationMenu
  const SideBar({Key? key, required this.onNavigate, required this.isOpen})
      : super(key: key);
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  bool _isSidebarOpen = false; // Internal state for SideBar

  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  late AnimationController _animationController;
  final _animationDuration = const Duration(milliseconds: 250);
  late final SharedPreferences prefs;
  String userID = '';
  Map? data;
  Future<void> getUserID() async {
    prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') as String;
    final docRef =
        await FirebaseFirestore.instance.collection("user").doc(userID).get();

    setState(() {
      data = docRef.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    getUserID();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void navigateToPage(int pageIndex) {
    widget.onNavigate(pageIndex); // Trigger navigation using callback
    setState(() {
      _isSidebarOpen = false; // Close sidebar after navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      stream: isSidebarOpenedStream,
      initialData: false,
      builder: (context, snapshot) {
        // Check if data has been loaded
        if (data == null) {
          // Display a loading indicator or an empty container while data is loading
          return const SizedBox();
        } else {
          // Data has been loaded, build the sidebar with user information
          return AnimatedPositioned(
            duration: _animationDuration,
            top: 0,
            bottom: 0,
            left: _isSidebarOpen ? 0 : -screenWidth,
            right: _isSidebarOpen ? 0 : screenWidth - 35,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Column(
                          children: [
                            // Display user information
                            (data!['image'] != '')
                                ? ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/img_not_found.jpg',
                                      image: data!['image'],
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const CircleAvatar(
                                          child: Icon(
                                            Icons.person_outline_rounded,
                                            size: 80,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 80,
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      size: 80,
                                    ),
                                  ),
                            Text(
                              data != null
                                  ? data!['firstName'].toUpperCase() ??
                                      'Not Found'
                                  : 'Not Found',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              data != null
                                  ? data!['phone'] ?? 'Not Found'
                                  : 'Not Found',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const Divider(
                          height: 64,
                          thickness: 0.5,
                          color: Colors.black,
                          indent: 16,
                          endIndent: 16,
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.home, title: 'H O M E'),
                          onTap: () => navigateToPage(0),
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.perm_identity,
                              title: 'P R O F I L E'),
                          onTap: () => navigateToPage(1),
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.payment_rounded,
                              title: 'P A Y M E N T'),
                          onTap: () => navigateToPage(2),
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.chat, title: 'C H A T'),
                          onTap: () => navigateToPage(3),
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.feedback_rounded, title: 'F E E D B A C K'),
                          onTap: () => navigateToPage(4),
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.person, title: 'A T T E N D A N C E'),
                          onTap: () => navigateToPage(5),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        GestureDetector(
                          child: const Menuitem(
                              icon: Icons.logout_outlined,
                              title: 'L O G O U T',
                              color: 'red'),
                          onTap: () => showLogoutConfirmation(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.9),
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: 110,
                        width: 35,
                        color: Theme.of(context).primaryColor,
                        child: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _animationController.view,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      onTap: () {
                        onIconPressed();
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  void onIconPressed() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  Future<bool?> showLogoutConfirmation(BuildContext context) async {
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
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
