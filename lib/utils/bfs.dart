import 'dart:collection';

import 'package:redux_training/models/model.dart';

enum BFS_DIRECTION {
  PARENTS,
  CHILDREN,
}

Goal getGoalByUuid(List<Goal> goals, String goalUuid) {
  return goals.firstWhere((Goal g) => g.uuid == goalUuid);
}

List<Goal> bfs(
  List<Goal> goals,
  Goal startingGoal,
  BFS_DIRECTION direction,
) {
  List<Goal> result = [];
  List<String> visited = [];
  var queue = Queue();
  queue.add(startingGoal.uuid);

  while (queue.isNotEmpty) {
    var goalUuid = queue.removeFirst();

    if (visited.contains(goalUuid) == false) {
      visited.add(goalUuid);

      var goal = getGoalByUuid(goals, goalUuid);

      if (direction == BFS_DIRECTION.PARENTS) {
        goal.parentGoalsUuids.forEach((String parenUuid) {
          if (visited.contains(parenUuid) == false) {
            queue.add(parenUuid);
            result.add(getGoalByUuid(goals, parenUuid));
          }
        });
      } else {
        goal.childGoalsUuids.forEach((String childUuid) {
          if (visited.contains(childUuid) == false) {
            queue.add(childUuid);
            result.add(getGoalByUuid(goals, childUuid));
          }
        });
      }
    }
  }
  return result;
}
