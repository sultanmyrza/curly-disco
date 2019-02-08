import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(goals: goalReducer(state.goals, action));
}

Reducer<List<Goal>> goalReducer = combineReducers<List<Goal>>([
  TypedReducer<List<Goal>, AddGoalAction>(addGoalReducer),
  TypedReducer<List<Goal>, RemoveGoalAction>(removeGoalReducer),
  TypedReducer<List<Goal>, RemoveGoalsAction>(removeGoalsReducer),
  TypedReducer<List<Goal>, LoadedGoalsAction>(loadGoalsReducer),
  TypedReducer<List<Goal>, GoalCompletedAction>(goalCompletedReducer),
  TypedReducer<List<Goal>, GoalChangeTitleAction>(goalChangeTitleReducer),
  TypedReducer<List<Goal>, GoalUpdatePhotoLocalPathIOSAction>(
      goalUpdatePhotoLocalPathIOSReducer),
  TypedReducer<List<Goal>, ConnectParentAction>(connectParentReducer),
  TypedReducer<List<Goal>, ConnectChildAction>(connectChildReducer),
]);

List<Goal> addGoalReducer(List<Goal> goals, AddGoalAction action) {
  return []
    ..add(action.goal)
    ..addAll(goals);
}

List<Goal> removeGoalReducer(List<Goal> goals, RemoveGoalAction action) {
  return List.unmodifiable(List.from(goals)..remove(action.goal));
}

List<Goal> removeGoalsReducer(List<Goal> goals, RemoveGoalsAction action) {
  return List.unmodifiable([]);
}

List<Goal> loadGoalsReducer(List<Goal> goals, LoadedGoalsAction action) {
  return action.goals;
}

List<Goal> goalCompletedReducer(List<Goal> goals, GoalCompletedAction action) {
  return goals
      .map((Goal goal) => goal.uuid == action.goal.uuid
          ? goal.copyWith(isCompleted: !goal.isCompleted)
          : goal)
      .toList();
}

List<Goal> goalChangeTitleReducer(
    List<Goal> goals, GoalChangeTitleAction action) {
  return goals.map((Goal goal) {
    if (goal.uuid == action.goalUuid) {
      /**
       * Also works
       * goal.title = action.newTitle;
       * return goal;
       */
      var newGoal = goal.copyWith(title: action.newTitle);
      return newGoal;
    } else {
      return goal;
    }
  }).toList();
}

List<Goal> goalUpdatePhotoLocalPathIOSReducer(
    List<Goal> goals, GoalUpdatePhotoLocalPathIOSAction action) {
  return goals.map((Goal goal) {
    if (goal.uuid != action.goalUuid) {
      return goal;
    } else {
      var newGoal = goal.copyWith(photoLocalPathIOS: action.photoLocalPathIOS);
      return newGoal;
    }
  }).toList();
}

List<Goal> connectParentReducer(List<Goal> goals, ConnectParentAction action) {
  var goal = goals.firstWhere((Goal g) => g.uuid == action.goalUuid);
  var parentGoal =
      goals.firstWhere((Goal g) => g.uuid == action.parentGoalUuid);

  if (action.connect == true) {
    goal.parentGoalsUuids = List.from(goal.parentGoalsUuids)
      ..add(parentGoal.uuid)
      ..toSet()
      ..toList();

    parentGoal.childGoalsUuids = List.from(parentGoal.childGoalsUuids)
      ..add(goal.uuid)
      ..toSet()
      ..toList();
  } else {
    goal.parentGoalsUuids = goal.parentGoalsUuids
        .where((String parentGoalUuid) => parentGoalUuid != parentGoal.uuid)
        .toList();
    parentGoal.childGoalsUuids = parentGoal.childGoalsUuids
        .where((String childGoalUuid) => childGoalUuid != goal.uuid)
        .toList();
  }

  return goals.map((Goal g) {
    if (g.uuid == parentGoal.uuid) {
      return parentGoal;
    } else if (g.uuid == goal.uuid) {
      return goal;
    } else {
      return g;
    }
  }).toList();
}

List<Goal> connectChildReducer(List<Goal> goals, ConnectChildAction action) {
  var goal = goals.firstWhere((Goal g) => g.uuid == action.goalUuid);
  var childGoal = goals.firstWhere((Goal g) => g.uuid == action.childGoalUuid);

  if (action.connect == true) {
    goal.childGoalsUuids = List.from(goal.childGoalsUuids)
      ..add(childGoal.uuid)
      ..toSet()
      ..toList();

    childGoal.parentGoalsUuids = List.from(childGoal.parentGoalsUuids)
      ..add(goal.uuid)
      ..toSet()
      ..toList();
  } else {
    goal.childGoalsUuids = goal.childGoalsUuids
        .where((String childGoalUuid) => childGoalUuid != childGoal.uuid)
        .toList();
    childGoal.parentGoalsUuids = childGoal.parentGoalsUuids
        .where((String parentGoalUuid) => parentGoalUuid != goal.uuid)
        .toList();
  }

  return goals.map((Goal g) {
    if (g.uuid == childGoal.uuid) {
      return childGoal;
    } else if (g.uuid == goal.uuid) {
      return goal;
    } else {
      return g;
    }
  }).toList();
}
