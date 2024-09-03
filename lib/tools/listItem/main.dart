import 'package:flutter/material.dart';

Widget buildListItem(String title, String amount) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    padding: EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.circle),
        Text(title, style: TextStyle(fontSize: 20)),
        Text(amount, style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}
