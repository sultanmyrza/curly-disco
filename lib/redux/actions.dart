import 'package:flutter/foundation.dart';
import 'package:redux_training/models/model.dart';
import 'package:uuid/uuid.dart';

final uuidGenerator = Uuid();

class AddGoalAction {
  String uuid;
  Goal goal;
  String newGoalUuid;
  String newGoalTitle;
  AddGoalAction({this.newGoalUuid, this.newGoalTitle = "New Title"}) {
    this.goal = Goal(uuid: newGoalUuid, title: newGoalTitle);
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

class GoalUpdatePhotoLocalPathIOSAction {
  final goalUuid;
  final photoLocalPathIOS;

  GoalUpdatePhotoLocalPathIOSAction({
    @required this.goalUuid,
    @required this.photoLocalPathIOS,
  });
}

class ConnectParentAction {
  final goalUuid;
  final parentGoalUuid;
  final bool connect;

  ConnectParentAction({
    @required this.goalUuid,
    @required this.parentGoalUuid,
    @required this.connect,
  });
}
