import 'package:redux_training/models/model.dart';
import 'package:uuid/uuid.dart';

final uuidGenerator = Uuid();

class AddGoalAction {
  String uuid;
  Goal goal;
  String newGoalTitle;
  AddGoalAction(this.newGoalTitle) {
    String randomUuid = uuidGenerator.v1();
    this.goal = Goal(uuid: randomUuid, title: newGoalTitle);
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
