class Message {
  final int id;
  final String content;
  final String? sender;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    this.sender,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
