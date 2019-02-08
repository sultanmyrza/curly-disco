import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux_training/main.dart';
import 'package:redux_training/models/model.dart';

class GoalCardHomeScreen extends StatelessWidget {
  final Goal goal;
  final Function deleteGoal;
  GoalCardHomeScreen({
    @required this.goal,
    @required this.deleteGoal,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset("assets/default.png");

    if (goal.photoUrl != null && goal.photoUrl.contains("http")) {
      image = Image.network(goal.photoUrl);
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: 16,
        left: 8,
        right: 8,
      ),
      child: Dismissible(
        onDismissed: (DismissDirection dismissDirection) {
          this.deleteGoal();
        },
        key: UniqueKey(),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Container()));
          },
          child: Card(
            elevation: CARD_ELEVATION,
            key: UniqueKey(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  child: image,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8, left: 16, bottom: 8),
                  child: Text(
                    goal.title,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
