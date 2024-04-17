import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/common/search.dart';
import 'package:powerstone/services/function/feedback_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedBackService _feedbackService = FeedBackService();
  // Get the current user ID
  late String userId;
  late final SharedPreferences prefs;
  Future<String?> getCurrentUserId() async{
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userID') as String;
    if (userId != '') {
      return userId; // Return the user ID if the user is logged in
    } else {
      return null; // Return null if no user is logged in
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserId();
  }

  String search = '';
  void updateSearch(String newSearch) {
    setState(() {
      search = newSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: SearchTextField(
                  onSearchUpdate: updateSearch,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _feedbackService.getFeedBacks(search),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Feedback Found'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String feedback = data['feedback'];
                      int vote = data['upvotes'];
                      return Card(
                        child: ListTile(
                          title: Text(
                            feedback,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          subtitle: Text('Upvotes: ${vote.toString()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up,
                                    color: data['upvotedBy'] != null &&
                                            data['upvotedBy'].contains(userId)
                                        ? Colors.green
                                        : null),
                                onPressed: () {
                                  _feedbackService.upvoteFeedback(
                                      doc.id, userId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.thumb_down,
                                    color: data['downvotedBy'] != null &&
                                            data['downvotedBy'].contains(userId)
                                        ? Colors.red
                                        : null),
                                onPressed: () {
                                  _feedbackService.downvoteFeedback(
                                      doc.id, userId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //custom components Here after
  AppBar customAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('FEEDBACK'),
      centerTitle: true,
    );
  }
}

class User {
}
