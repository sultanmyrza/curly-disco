import 'package:flutter/material.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';

class GoalListWidget extends StatelessWidget {
  final GoalViewModel goalViewModel;

  GoalListWidget(this.goalViewModel);

  @override
  Widget build(BuildContext context) {
    print('GoalListWidget.build');
    return ListView(
      children: goalViewModel.goals.map((Goal goal) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Container();
                },
              ),
            );
          },
          title: Text(goal.title),
          leading: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              goalViewModel.onRemoveGoal(goal);
            },
          ),
          trailing: Checkbox(
              value: goal.isCompleted,
              onChanged: (_) {
                goalViewModel.onCompleted(goal);
              }),
        );
      }).toList(),
    );
  }
}
