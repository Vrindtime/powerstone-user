// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:powerstone/common/dot_menu.dart';
// import 'package:powerstone/common/profile_picture.dart';
// import 'package:powerstone/services/user_managment/users.dart';

// class ViewUserList extends StatelessWidget {
//   const ViewUserList({
//     super.key,
//     required this.firestoreServices,
//     required this.search,
//     required this.searchController,
//     required this.gender,
//     required this.job,
//     required this.bloodGroup,
//   });

//   final FirestoreServices firestoreServices;
//   final String search;
//   final String gender;
//   final String job;
//   final String bloodGroup;
//   final TextEditingController searchController;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         // stream: firestoreServices.getUserDetails(search),
//         stream: firestoreServices.getUserDetailsTest(value: search,bloodGroup: bloodGroup,gender: gender,job: job),
//         builder: (context, snapshot) {
//           //if we have data, get all the docs
//           if (snapshot.hasData) {
//             List userList = snapshot.data!.docs;
//             return Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Total User : ${userList.length}",
//                     style: const TextStyle(
//                         fontSize: 21, fontWeight: FontWeight.bold),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: userList.length,
//                       itemBuilder: (context, index) {
//                         //get each individual doc
//                         DocumentSnapshot document = userList[index];
//                         String docID = document.id; //keep track of users
                                
//                         //get userdata from each doc
//                         Map<String, dynamic> data =
//                             document.data() as Map<String, dynamic>;
//                         String userName =
//                             data['firstName'] ?? "No Name Recieved";
                                
//                         String userImg = data['image'] ?? "nil";
                                
//                         // display as a list tile
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                               color: Theme.of(context).splashColor,
//                               borderRadius: BorderRadius.circular(16)),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(6),
//                             leading: (userImg.isNotEmpty)
//                                 ? ProfilePicture(userImg: userImg)
//                                 : const CircleAvatar(
//                                     radius: 40,
//                                     child: Icon(
//                                       Icons.person_outline_rounded,
//                                       size: 50,
//                                     ),
//                                   ),
//                             title: Text(
//                               userName,
//                               style: Theme.of(context).textTheme.labelMedium,
//                             ),
//                             trailing: DotMenu(docID: docID),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: Text(
//                 "No User data Exists",
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//             );
//           }
//         });
//   }
// }
