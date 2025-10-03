import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String name;
  final String avatar;
  final bool isAddButton;

  const StatusWidget({
    super.key,
    required this.name,
    required this.avatar,
    this.isAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(avatar),
              ),
              if (isAddButton)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.pinkAccent,
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
