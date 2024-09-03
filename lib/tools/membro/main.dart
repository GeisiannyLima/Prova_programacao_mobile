import 'package:flutter/material.dart';

widgetMembro(context, nome) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
      ),
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 140, 188, 254),
          border: Border.all(
            color: Colors.black,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 40,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content left
                children: [
                  Text(
                    "${nome}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
