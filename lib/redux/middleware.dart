import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware(
    [AppState state = const AppState(goals: [])]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);

  return [
    TypedMiddleware<AppState, AddGoalAction>(saveItems),
    TypedMiddleware<AppState, RemoveGoalAction>(saveItems),
    TypedMiddleware<AppState, RemoveGoalsAction>(saveItems),
    TypedMiddleware<AppState, GetGoalsAction>(loadItems),
    TypedMiddleware<AppState, GoalChangeTitleAction>(saveItems),
    TypedMiddleware<AppState, GoalUpdatePhotoLocalPathIOSAction>(saveItems),
    TypedMiddleware<AppState, ConnectParentAction>(saveItems),
  ];
}

Middleware<AppState> _loadFromPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    loadFromPrefs()
        .then((state) => store.dispatch(LoadedGoalsAction(state.goals)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    saveToPrefs(store.state);
  };
}

void saveToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var encodeState = json.encode(state.toJson());
  await preferences.setString('goalsState', encodeState);
}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String encodedState = preferences.getString('goalsState');
  if (encodedState != null) {
    Map decodedState = json.decode(encodedState);
    return AppState.fromJson(decodedState);
  }
  return AppState.initialState();
}
