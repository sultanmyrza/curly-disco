import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';
import 'package:redux_training/widgets/add_why.dart';
import 'package:redux_training/widgets/goal_card_home_screen.dart';

class TaskList extends StatefulWidget {
  final String goalUuid;

  TaskList({
    @required this.goalUuid,
  });

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          var goal = goalViewModel.goals.firstWhere(
              (Goal g) => g.uuid == widget.goalUuid,
              orElse: () => null);
          if (goal == null) {
            return Scaffold();
          }

          var children = List<Widget>.from([
            Container(
              padding: EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 8,
                right: 8,
              ),
              child: ListTile(
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
                  title: TextFormField(
                    initialValue: goal.title,
                    onSaved: (newTitle) {
                      goalViewModel.onGoalTitleChanged(
                          widget.goalUuid, newTitle);
                    },
                    onFieldSubmitted: (newTitle) {
                      goalViewModel.onGoalTitleChanged(
                          widget.goalUuid, newTitle);
                    },
                    decoration: new InputDecoration.collapsed(
                      hintText: 'I want to...',
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Navigator.pop(context);
                      goalViewModel.onRemoveGoal(goal);
                    },
                  ),
                  trailing: Checkbox(
                      value: goal.isCompleted,
                      onChanged: (_) {
                        goalViewModel.onCompleted(goal);
                      })),
            ),
            AddWhy(goalUuid: goal.uuid),
            SizedBox(height: 30.0),
          ]);

          var parentGoals = goal.parentGoalsUuids
              .map((String parenUuid) => goalViewModel.goals.firstWhere(
                  (Goal g) => g.uuid == parenUuid,
                  orElse: () => null))
              .where((Goal g) => g != null)
              .toList()
              .reversed
              .toList();
          parentGoals.forEach((Goal parentGoal) {
            children.add(GoalCardHomeScreen(
              goal: parentGoal,
              deleteGoal: () {
                goalViewModel.onRemoveGoal(parentGoal);
              },
            ));
          });

          return Scaffold(
            body: ListView(
              children: children,
            ),
          );
        });
  }
}
