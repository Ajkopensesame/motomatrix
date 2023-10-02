class Message {
  final String role;  // 'user', 'system', or 'assistant'
  final String content;
  final int timestamp;

  Message({required this.role, required this.content, required this.timestamp});
}