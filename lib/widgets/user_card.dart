import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String userName;
  final VoidCallback onTap;

  const UserCard({
    super.key,
    required this.userId,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(userName),
        subtitle: Text("ID: $userId"),
        onTap: onTap,
        trailing: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
