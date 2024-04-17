import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String reciverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.reciverID,
    required this.message,
    required this.timestamp,
  });

  //convert to a map

  Map<String,dynamic> toMap(){
    return{
      "senderName":senderID,
      "reciverID":reciverID,
      "message":message,
      "timestamp":timestamp,
    };
  }
}
