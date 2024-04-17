import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference _notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  Stream<QuerySnapshot> getNotificationsStream() {
    return _notificationsCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting notification: $e');
      rethrow; // Rethrow the error to handle it in the UI if needed
    }
  }

  Future<void> addNotification(String message) async {
    try {
      await _notificationsCollection.add({
        'message': message,
        'timestamp':
            FieldValue.serverTimestamp(), // Automatically adds server timestamp
      });
      // After adding the notification, trigger FCM message
      // await _sendFCMNotification(message);
    } catch (e) {
      // Handle any errors that occur during notification creation
      print('Error adding notification: $e');
      throw e; // Rethrow the error to handle it in the UI if needed
    }
  }
}
