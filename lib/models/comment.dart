class Comment {
  final int bookId;
  final int userId;
  final double rate;
  final int createdAt;
  final String content;
  Comment({
    required this.bookId,
    required this.userId,
    required this.rate,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<dynamic, dynamic> json) {
    return Comment(
        bookId: json['book_id'],
        userId: json['user_id'],
        rate: double.parse(json['rate'].toString()),
        createdAt: json['createdAt'],
        content: json['content'],);
  }
  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
      'user_id': userId,
      'rate': rate,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
