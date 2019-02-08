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
  TypedReducer<List<Goal>, GoalChangeTitleAction>(goalChangeTitleReducer)
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

//List<Goal> goalReducer(List<Goal> state, action) {
//  if (action is AddGoalAction) {
//    return []
//      ..addAll(state)
//      ..add(action.goal);
//  }
//
//  if (action is RemoveGoalAction) {
//    return List.unmodifiable(List.from(state)..remove(action.goal));
//  }
//
//  if (action is LoadedGoalsAction) {
//    return List.unmodifiable(action.goals);
//  }
//
//  return state;
//}
