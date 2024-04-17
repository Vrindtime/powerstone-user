import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powerstone/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  
  //send message
  Future<void> sendMessage(String reciverID, message) async {
    //get curent user info
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String senderID = prefs.getString('userID') as String;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderID: senderID,
      reciverID: reciverID,
      message: message,
      timestamp: timestamp,
    );

    String chatRoomID = reciverID;

    //add new message to db
    await _firestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String chatRoomID) {
    return _firestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",
            descending: true,
        ) // Sort by timestamp in descending order
        .snapshots();
  }
}
