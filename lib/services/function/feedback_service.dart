import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powerstone/models/feedback_model.dart';

class FeedBackService {
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  Future<void> addFeedBack({
    required String feedback,
    required int upvotes,
    required DateTime timestamp,
  }) async {
    FeedBackModel newFeedback = FeedBackModel(
      feedback: feedback,
      upvotes: upvotes,
      timestamp: timestamp,
      upvotedBy: [],
      downvotedBy: [],
    );

    await _feedbackCollection.add(newFeedback.toMap());
  }

  Stream<QuerySnapshot> getFeedBacks(String value) {
    Query feedbackStream = _feedbackCollection;

    // Function to filter search and order by upvotes
    if (value.isNotEmpty) {
      String searchValue =
          value.toLowerCase(); // Convert search value to lowercase
      String endValue = searchValue.substring(0, searchValue.length - 1) +
          String.fromCharCode(
              searchValue.codeUnitAt(searchValue.length - 1) + 1);
      feedbackStream = _feedbackCollection
          .where(
            'feedback',
            isGreaterThanOrEqualTo: searchValue,
            isLessThan: endValue,
          );
          // .orderBy('upvotes',
          //     descending: true); // Order by upvotes in descending order
    } else {
      feedbackStream = _feedbackCollection.orderBy('upvotes', descending: true);
    }

    return feedbackStream.snapshots();
  }

  Future<void> upvoteFeedback(String feedbackId, String user) async {
    DocumentReference feedbackRef = _feedbackCollection.doc(feedbackId);

    // Check if the user has already upvoted
    DocumentSnapshot snapshot = await feedbackRef.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      dynamic upvotedByData = data['upvotedBy'];
      if (upvotedByData is List<dynamic> && upvotedByData.contains(user)) {
        // User has already upvoted, toggle the upvote (remove it)
        await feedbackRef.update({
          'upvotes': FieldValue.increment(-1),
          'upvotedBy': FieldValue.arrayRemove([user]),
        });
      } else {
        // User hasn't upvoted, so add the upvote
        await feedbackRef.update({
          'upvotes': FieldValue.increment(1),
          'upvotedBy': FieldValue.arrayUnion([user]),
          'downvotedBy':
              FieldValue.arrayRemove([user]), // Remove downvote if any
        });
      }
    } else {
      // Handle case where data is null (optional)
      print('Feedback data is null');
    }
  }

  Future<void> downvoteFeedback(String feedbackId, String user) async {
    DocumentReference feedbackRef = _feedbackCollection.doc(feedbackId);

    // Check if the user has already downvoted
    DocumentSnapshot snapshot = await feedbackRef.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      dynamic downvotedBy = data['downvotedBy'];
      if (downvotedBy is List<dynamic> && downvotedBy.contains(user)) {
        // User has already downvoted, toggle the downvote (remove it)
        await feedbackRef.update({
          'upvotes': FieldValue.increment(1), // Increment upvotes by 1
          'downvotedBy': FieldValue.arrayRemove([user]),
        });
      } else {
        // User hasn't downvoted, so add the downvote and remove upvote if any
        await feedbackRef.update({
          'upvotes': FieldValue.increment(-1), // Decrement upvotes by 1
          'upvotedBy': FieldValue.arrayRemove([user]), // Remove upvote if any
          'downvotedBy': FieldValue.arrayUnion([user]),
        });
      }
    } else {
      // Handle case where data is null (optional)
      print('Feedback data is null');
    }
  }

  // Future<void> downvoteFeedback(String feedbackId, String user) async {
  //   DocumentReference feedbackRef = _feedbackCollection.doc(feedbackId);

  //   // Check if the user has already downvoted
  //   DocumentSnapshot snapshot = await feedbackRef.get();
  //   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

  //   if (data != null) {
  //     dynamic downvotedBy = data['downvotedBy'];
  //     if (downvotedBy is List<dynamic> && downvotedBy.contains(user)) {
  //       // User has already upvoted, toggle the upvote (remove it)
  //       await feedbackRef.update({
  //         'upvotes': FieldValue.increment(1),
  //         'downvotedBy': FieldValue.arrayRemove([user]),
  //       });
  //     } else {
  //       // User hasn't upvoted, so add the upvote
  //       await feedbackRef.update({
  //         'upvotes': FieldValue.increment(-1),
  //         'upvotedBy': FieldValue.arrayRemove([user]), // Remove upvote if any
  //         'downvotedBy': FieldValue.arrayUnion([user]),
  //       });
  //     }
  //   } else {
  //     // Handle case where data is null (optional)
  //     print('Feedback data is null');
  //   }
  // }
}
