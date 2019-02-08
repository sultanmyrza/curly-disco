import 'package:flutter/material.dart';
import 'package:redux_training/main.dart';

class GoalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Text(""),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  //TODO implement dissonnect;
                })
          ],
        ),
      ),
    );
  }
}
