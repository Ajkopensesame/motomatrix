class ChatMessage {
  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      content: map['content'],
      sender: map['sender'],
      timestamp: map['timestamp'],
    );
  }
}
