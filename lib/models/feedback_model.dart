
class FeedBackModel {
  final String feedback;
  int upvotes;
  final List<String> upvotedBy; // List of user IDs who upvoted
  final List<String> downvotedBy; // List of user IDs who downvoted
  final DateTime timestamp;

  FeedBackModel({
    required this.feedback,
    required this.upvotes,
    required this.upvotedBy,
    required this.downvotedBy,
    required this.timestamp,
  });

  factory FeedBackModel.fromMap(Map<String, dynamic> map) {
    return FeedBackModel(
      feedback: map['feedback'],
      upvotes: map['upvotes'],
      upvotedBy: List<String>.from(map['upvotedBy'] ?? []),
      downvotedBy: List<String>.from(map['downvotedBy'] ?? []),
      timestamp: DateTime.parse(map['timestamp']), // Convert string back to DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'feedback': feedback,
      'upvotes': upvotes,
      'upvotedBy': upvotedBy,
      'downvotedBy': downvotedBy,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to a string format
    };
  }
}
