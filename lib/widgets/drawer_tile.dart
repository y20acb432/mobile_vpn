import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const DrawerTile({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //tileColor: Colors.blue[100],
    );
  }
}