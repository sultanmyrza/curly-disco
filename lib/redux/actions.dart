import 'package:flutter/foundation.dart';
import 'package:redux_training/models/model.dart';
import 'package:uuid/uuid.dart';

final uuidGenerator = Uuid();

class AddGoalAction {
  String uuid;
  Goal goal;
  String newGoalUuid;
  AddGoalAction(this.newGoalUuid) {
    this.goal = Goal(uuid: newGoalUuid);
  }
}

class RemoveGoalAction {
  final Goal goal;
  RemoveGoalAction(this.goal);
}

class RemoveGoalsAction {}

class GetGoalsAction {}

class LoadedGoalsAction {
  final List<Goal> goals;

  LoadedGoalsAction(this.goals);
}

class GoalCompletedAction {
  final Goal goal;
  GoalCompletedAction(this.goal);
}

class GoalChangeTitleAction {
  final goalUuid;
  final newTitle;

  GoalChangeTitleAction({
    @required this.goalUuid,
    @required this.newTitle,
  });
}
