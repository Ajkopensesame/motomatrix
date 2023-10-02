class CustomOpenAIChatMessageModel {
  final String role;
  final String content;
  final int timestamp;

  CustomOpenAIChatMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'CustomOpenAIChatMessageModel(role: $role, content: $content, timestamp: $timestamp)';
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory CustomOpenAIChatMessageModel.fromMap(Map<String, dynamic> map) {
    return CustomOpenAIChatMessageModel(
      role: map['role'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}
