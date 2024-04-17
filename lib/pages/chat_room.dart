import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/common/chat_bubble.dart';
import 'package:powerstone/services/chat/chat_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final String reciverID = '68Gx0DYc0Zcw3NkfBCgIPxIHbOo1';
  String img = '';
  String username = '';
  String docID = '';
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final scrollController = ScrollController();

  final focusNode = FocusNode();

  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(docID, _messageController.text);
    }
    _messageController.text = '';
    _messageController.clear();
    // Move the scroll position to the bottom
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    docID = prefs.getString('userID') ?? '';
    if (docID.isNotEmpty) {
      // Check if docID is not empty before proceeding
      final docRef =
          await FirebaseFirestore.instance.collection('user').doc(docID).get();
      final data = docRef.data();
      if (data != null) {
        setState(() {
          img = data['image'];
          username = data['firstName'];
        });
      }
    } else {
      print('Error: docID is empty');
    }
  }

  String _getTime(Timestamp time) {
    // Convert Timestamp to DateTime
    DateTime dateTime = time.toDate();
    // Format the DateTime object
    String formattedTime = DateFormat.jm().format(dateTime); // "0:00 PM/AM"

    return formattedTime;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserDetails().then((value) => setState((){}));
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: appbar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //display all messages
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: _buildMessageList(),
              ),
              const SizedBox(
                height: 5,
              ),
              _buildUserInput(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      automaticallyImplyLeading: false, // Disable the back button
      title: Row(
        children: [
          (img != '')
              ? ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/img_not_found.jpg',
                    image: img,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const CircleAvatar(
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 40,
                        ),
                      );
                    },
                  ),
                )
              : const CircleAvatar(
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 40,
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Text(username),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (docID.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return StreamBuilder(
        stream: _chatService.getMessages(docID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('LOADING FOR Message List'));
          }
          return _messageList(snapshot);
        },
      );
    }
  }

  ListView _messageList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.separated(
      controller: scrollController,
      reverse: true, // Maintain reverse order
      separatorBuilder: (context, index) => const SizedBox.shrink(),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot doc = snapshot.data!.docs[index];
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        bool isCurrentUser = data['senderName'] == docID;
        //align msg to right when sender is current user or vice versa
        var alignment =
            isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
        String message = data["message"];
        Timestamp time = data["timestamp"];
        String formattedTime = _getTime(time);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: alignment,
              child: ChatBubble(
                message: message,
                isCurrentUser: isCurrentUser,
              ),
            ),
            const SizedBox(
                height: 4), // Add some space between bubble and timestamp
            Align(
              alignment: alignment,
              child: Text(
                formattedTime,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  //build msg input
  Widget _buildUserInput(context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: _messageController,
            style: Theme.of(context).textTheme.labelMedium,
            decoration: InputDecoration(
              hintText: "Enter Your Message",
              labelStyle: Theme.of(context).textTheme.labelSmall,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 0.5)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .primaryColor, // Border color when focused
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 22,
          child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).scaffoldBackgroundColor,
              )),
        )
      ],
    );
  }
}
