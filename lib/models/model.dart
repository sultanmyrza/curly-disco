import 'package:flutter/foundation.dart';

class Goal {
  String uuid;
  String title;
  String photoUrl;
  String photoLocalPathIOS;
  String photoLocalPathAndroid;
  double xPos;
  double yPos;
  bool isCompleted;
  List<String> parentGoalsUuids;
  List<String> childGoalsUuids;

  Goal({
    @required this.uuid,
    this.title = "New goal",
    this.photoUrl = "",
    this.photoLocalPathIOS,
    this.photoLocalPathAndroid,
    this.isCompleted = false,
    this.parentGoalsUuids = const <String>[],
    this.childGoalsUuids = const <String>[],
  });

  Goal copyWith({
    String uuid,
    String title,
    String photoUrl = "",
    String photoLocalPathIOS,
    String photoLocalPathAndroid,
    bool isCompleted,
    List<Goal> parentGoals,
    List<Goal> childGoals,
  }) {
    return Goal(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      photoUrl: photoUrl ?? this.photoUrl,
      photoLocalPathIOS: photoLocalPathIOS ?? this.photoLocalPathIOS,
      photoLocalPathAndroid:
          photoLocalPathAndroid ?? this.photoLocalPathAndroid,
      isCompleted: isCompleted ?? this.isCompleted,
      parentGoalsUuids: parentGoals ?? this.parentGoalsUuids,
      childGoalsUuids: childGoals ?? this.childGoalsUuids,
    );
  }

  Goal.fromJson(Map json)
      : uuid = json['uuid'] ?? '',
        title = json['title'] ?? '',
        photoUrl = json['photoUrl'] ?? '',
        photoLocalPathIOS = json['photoLocalPathIOS'] ?? '',
        photoLocalPathAndroid = json['photoLocalPathAndroid'] ?? '',
        isCompleted = json['isCompleted'] ?? false,
        parentGoalsUuids =
            List<String>.from(json['parentGoalsUuids'] ?? <String>[]),
        childGoalsUuids =
            List<String>.from(json['childGoalsUuids'] ?? <String>[]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      "uuid": uuid,
      "title": title,
      "photoUrl": photoUrl,
      "photoLocalPathIOS": photoLocalPathIOS,
      "photoLocalPathAndroid": photoLocalPathAndroid,
      "isCompleted": isCompleted,
      "parentGoalsUuids": parentGoalsUuids,
      "childGoalsUuids": childGoalsUuids,
    };
    return result;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class AppState {
  final List<Goal> goals;

  const AppState({
    @required this.goals,
  });

  AppState.initialState() : goals = List.unmodifiable(<Goal>[]);

  AppState.fromJson(Map json)
      : goals = (json['goals'] as List)
            .map((goalJson) => Goal.fromJson(goalJson))
            .toList();

  Map toJson() => {'goals': goals};

  @override
  String toString() {
    return toJson().toString();
  }
}
