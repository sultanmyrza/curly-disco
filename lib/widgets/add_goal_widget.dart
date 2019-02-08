import 'package:flutter/material.dart';
import 'package:redux_training/view_models/view_models.dart';

class AddGoalWidget extends StatefulWidget {
  final GoalViewModel goalViewModel;

  AddGoalWidget(this.goalViewModel);

  @override
  _AddGoalWidgetState createState() => _AddGoalWidgetState();
}

class _AddGoalWidgetState extends State<AddGoalWidget> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('_AddGoalWidgetState.build');
    return TextField(
      controller: textEditingController,
      onSubmitted: (String goalTitle) {
        widget.goalViewModel.onAddGoal(goalTitle);
        textEditingController.clear();
      },
    );
  }
}
