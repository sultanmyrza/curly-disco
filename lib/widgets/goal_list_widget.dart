import 'package:flutter/material.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/screens/taks_screen.dart';
import 'package:redux_training/view_models/view_models.dart';

class GoalListWidget extends StatelessWidget {
  final GoalViewModel goalViewModel;

  GoalListWidget(this.goalViewModel);

  @override
  Widget build(BuildContext context) {
    print('GoalListWidget.build');

    var tasks = goalViewModel.goals
        .where((Goal g) => g.childGoalsUuids.length == 0)
        .toList();

    return ListView(
      children: tasks.map((Goal goal) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TaskList(
                    goalUuid: goal.uuid,
                  );
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
