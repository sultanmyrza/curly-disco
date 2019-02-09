import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware(
    [AppState state = const AppState(goals: [])]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);
  final addToFireBase = _addToFireBase(state);
  final updateTitleInFirebase = _updateTitleInFirebase(state);
  final deleteGoalInFirebase = _deleteGoalInFirebase(state);
  final loadItemsFromFireBase = _loadFromFireBase(state);
  final connectParentInFirebase = _connectParentInFirebase(state);
  final connectChildInFirebase = _connectChildInFirebase(state);

  var updatePhotoPathIOS = _updatePhotoPathIOS(state);

  return [
    TypedMiddleware<AppState, AddGoalAction>(addToFireBase),
    TypedMiddleware<AppState, RemoveGoalAction>(deleteGoalInFirebase),
    TypedMiddleware<AppState, RemoveGoalsAction>(saveItems),
    TypedMiddleware<AppState, GetGoalsAction>(loadItemsFromFireBase),
    TypedMiddleware<AppState, GoalChangeTitleAction>(updateTitleInFirebase),
    TypedMiddleware<AppState, GoalUpdatePhotoLocalPathIOSAction>(
        updatePhotoPathIOS),
    TypedMiddleware<AppState, ConnectParentAction>(connectParentInFirebase),
    TypedMiddleware<AppState, ConnectChildAction>(connectChildInFirebase),
  ];
}

Middleware<AppState> _addToFireBase(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();
    var addGoalAction = action as AddGoalAction;
    var goal = addGoalAction.goal;
    Map<String, dynamic> data = goal.toJson();
//    Firestore.instance.collection(currentUser.email)
    Firestore.instance
        .document('${currentUser.email}/${goal.uuid}')
        .setData(data);
  };
}

Middleware<AppState> _updatePhotoPathIOS(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();

    var goalUpdatePhotoLocalPathIOSAction =
        action as GoalUpdatePhotoLocalPathIOSAction;
    var goalUuid = goalUpdatePhotoLocalPathIOSAction.goalUuid;
    var photoLocalPathIOS =
        goalUpdatePhotoLocalPathIOSAction.photoLocalPathIOS.toString();

    await Firestore.instance
        .document("${currentUser.email}/${goalUuid}")
        .updateData({
      "photoLocalPathIOS": photoLocalPathIOS,
    });

    String userPath = (await FirebaseAuth.instance.currentUser()).email;

    var file = File(photoLocalPathIOS);

    StorageReference FirebaseStorageRef =
        FirebaseStorage.instance.ref().child("$userPath/$goalUuid.jpeg");
    var storageUploadTask = FirebaseStorageRef.putFile(file);

    storageUploadTask.events.listen((storageUploadTask) {
      var bytesTransferred = storageUploadTask.snapshot.bytesTransferred;
      var totalByteCount = storageUploadTask.snapshot.totalByteCount;
      var progress = (bytesTransferred / totalByteCount * 100).toInt();
      print(progress);
    });

    var storageTaskSnapshot = await storageUploadTask.onComplete;
    var downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
    var photoUrl = downloadURL.toString();
    await Firestore.instance
        .document("${currentUser.email}/${goalUuid}")
        .updateData({
      "photoUrl": photoUrl,
    });
    print(photoUrl);
  };
}

Middleware<AppState> _connectParentInFirebase(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();
    var connectParentAction = action as ConnectParentAction;
    var goalUuid = connectParentAction.goalUuid;
    var parentGoalUuid = connectParentAction.parentGoalUuid;

    var goal = store.state.goals
        .firstWhere((Goal g) => g.uuid == goalUuid, orElse: () => null);
    var parentGoal = store.state.goals
        .firstWhere((Goal g) => g.uuid == parentGoalUuid, orElse: () => null);

    Firestore.instance.document("${currentUser.email}/${goalUuid}").updateData({
      'parentGoalsUuids': goal.parentGoalsUuids,
      'childGoalsUuids': goal.childGoalsUuids,
    });

    Firestore.instance
        .document("${currentUser.email}/${parentGoalUuid}")
        .updateData({
      'parentGoalsUuids': parentGoal.parentGoalsUuids,
      'childGoalsUuids': parentGoal.childGoalsUuids,
    });
  };
}

Middleware<AppState> _connectChildInFirebase(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();
    var connectChildAction = action as ConnectChildAction;
    var goalUuid = connectChildAction.goalUuid;
    var childGoalUuid = connectChildAction.childGoalUuid;

    var goal = store.state.goals
        .firstWhere((Goal g) => g.uuid == goalUuid, orElse: () => null);
    var childGoal = store.state.goals
        .firstWhere((Goal g) => g.uuid == childGoalUuid, orElse: () => null);

    Firestore.instance.document("${currentUser.email}/${goalUuid}").updateData({
      'parentGoalsUuids': goal.parentGoalsUuids,
      'childGoalsUuids': goal.childGoalsUuids,
    });

    Firestore.instance
        .document("${currentUser.email}/${childGoalUuid}")
        .updateData({
      'parentGoalsUuids': childGoal.parentGoalsUuids,
      'childGoalsUuids': childGoal.childGoalsUuids,
    });
  };
}

Middleware<AppState> _updateTitleInFirebase(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();
    var changeTitleAction = action as GoalChangeTitleAction;
    var goalUuid = changeTitleAction.goalUuid;
    var newTitle = changeTitleAction.newTitle;
    Firestore.instance
        .document("${currentUser.email}/${goalUuid}")
        .updateData({'title': newTitle});
  };
}

Middleware<AppState> _deleteGoalInFirebase(AppState state) {
  //TODO: when goal is deleted the reference to it from other goal's parent,child must be updated too
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var currentUser = await FirebaseAuth.instance.currentUser();
    var removeGoalAction = action as RemoveGoalAction;
    var uuid = removeGoalAction.goal.uuid;

    Firestore.instance.collection(currentUser.email).document(uuid).delete();
  };
}

Middleware<AppState> _loadFromFireBase(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    var state = await loadFromFireBase();
    store.dispatch(LoadedGoalsAction(state.goals));
  };
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
    saveToFireBase(store.state);
  };
}

void saveToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var encodeState = json.encode(state.toJson());
  await preferences.setString('goalsState', encodeState);
}

void saveToFireBase(AppState state) async {
  var currentUser = await FirebaseAuth.instance.currentUser();
  Firestore.instance.collection(currentUser.email);

//  var encode = json.encode(state.toJson());
//  var currentUser =await FirebaseAuth.instance.currentUser();
//
//  Firestore.instance.document("${currentUser.email}/goals").setData(encode);
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

Future<AppState> loadFromFireBase() async {
  try {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var userCollection =
        await Firestore.instance.collection(currentUser.email).getDocuments();
    var goalDocuments = userCollection.documents;
    var goals = goalDocuments.map((DocumentSnapshot ds) => ds.data).toList();
    Map<String, dynamic> result = {"goals": goals};

    return AppState.fromJson(result);
  } catch (e) {
    return AppState.initialState();
  }
}
