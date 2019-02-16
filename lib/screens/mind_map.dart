import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';

double originX = 0.0;
double originY = 0.0;

class MindMap extends StatefulWidget {
  @override
  _MindMapState createState() => _MindMapState();
}

Goal findGoalOrNull(goalUid, List<Goal> goals) {
  return goals.firstWhere((Goal g) => g.uuid == goalUid, orElse: () => null);
}

class _MindMapState extends State<MindMap> {
  double initialX = 30;
  double initialY = 300;
  double distanceY = 190;
  double distanceX = 190;

  double dragStartX;
  double dragStartY;
  double dragEndX;
  double dragEndY;

  Map<double, int> yPositions = Map();
  @override
  Widget build(BuildContext context) {
    print('_MindMapState.build');
    print(initialX);
    print(initialY);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mind map"),
      ),
      body: StoreConnector<AppState, GoalViewModel>(
          converter: (Store<AppState> store) => GoalViewModel.create(store),
          builder: (BuildContext context, GoalViewModel goalViewModel) {
            var goals = goalViewModel.goals.map((Goal g) => g).toList();

            yPositions[initialY] = 30;

            for (var i = 0; i < goals.length; ++i) {
              var goal = goals[i];
              if (goal.xPos == null || goal.yPos == null) {
                goal.xPos = yPositions[initialY].toDouble();
                goal.yPos = initialY;

                for (var j = 0; j < goal.parentGoalsUuids.length; ++j) {
                  var parentGoalUuid = goal.parentGoalsUuids[j];
                  var parentGoal = findGoalOrNull(parentGoalUuid, goals);
                  placeRelatedGoal(goal, parentGoal, distanceY * -1.toDouble());
                }

                for (var j = 0; j < goal.childGoalsUuids.length; ++j) {
                  var childGoalUuid = goal.childGoalsUuids[j];
                  var childGoal = findGoalOrNull(childGoalUuid, goals);
                  placeRelatedGoal(goal, childGoal, distanceY);
                }
              }
              yPositions[initialY] += goal.title.length + distanceY.toInt();
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blueAccent,
              child: GestureDetector(
                onPanStart: (DragStartDetails details) {
                  RenderBox box = context.findRenderObject();
                  Offset point = box.globalToLocal(details.globalPosition);
                  point = point.translate(0.0, AppBar().preferredSize.height);

                  dragStartX = point.dx;
                  dragStartY = point.dy;
                },
                onPanEnd: (DragEndDetails details) {
                  RenderBox box = context.findRenderObject();
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox box = context.findRenderObject();
                    Offset point = box.globalToLocal(details.globalPosition);
                    point = point.translate(0.0, AppBar().preferredSize.height);

                    initialY = point.dy;
                    initialX = point.dx;

                    yPositions.clear();

                    goals.forEach((Goal goal) {
                      goal.xPos = null;
                      goal.yPos = null;
                    });

                    print(initialX);
                    print(initialY);
                    print("\n");
                  });
                },
                child: CustomPaint(
                  painter: MindMapPainter(goals),
                ),
              ),
            );
          }),
    );
  }

  void placeRelatedGoal(Goal goal, Goal relatedGoal, double distance) {
    if (relatedGoal == null) return;

    if (relatedGoal.xPos == null || relatedGoal.yPos == null) {
      var newYPos = goal.yPos + distance;
      if (yPositions.containsKey(newYPos) == false) {
        yPositions[newYPos] = 30;
      }

      relatedGoal.yPos = newYPos;
      relatedGoal.xPos = yPositions[newYPos].toDouble();
      yPositions[newYPos] += goal.title.length + distanceX.toInt();
    }
  }
}

class MindMapPainter extends CustomPainter {
  final List<Goal> goals;
  final textStyle = TextStyle(color: Colors.black, fontSize: 12);

  MindMapPainter(this.goals);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.redAccent;

    for (var i = 0; i < goals.length; ++i) {
      var goal = goals[i];

      for (var j = 0; j < goal.parentGoalsUuids.length; ++j) {
        var parentGoalUuid = goal.parentGoalsUuids[j];
        var parentGoal = findGoalOrNull(parentGoalUuid, goals);
        if (parentGoal != null) {
          canvas.drawLine(Offset(goal.xPos, goal.yPos),
              Offset(parentGoal.xPos, parentGoal.yPos), paint);
        }
      }

      for (var j = 0; j < goal.childGoalsUuids.length; ++j) {
        var childGoalUuid = goal.childGoalsUuids[j];
        var childGoal = findGoalOrNull(childGoalUuid, goals);
        if (childGoal != null) {
          canvas.drawLine(Offset(goal.xPos, goal.yPos),
              Offset(childGoal.xPos, childGoal.yPos), paint);
        }
      }
    }

    drawLabels(canvas, paint);
  }

  void drawLabels(Canvas canvas, Paint paint) {
    for (var i = 0; i < goals.length; ++i) {
      var goal = goals[i];
      if (goal != null) {
        canvas.drawRect(
            Rect.fromCircle(
              center: Offset(goal.xPos + 40, goal.yPos),
              radius: 40,
            ),
            paint);

        var textPainter = TextPainter(textDirection: TextDirection.ltr);

        textPainter.text = TextSpan(
          text: goal.title,
          style: textStyle,
        );
        textPainter.layout(maxWidth: 100);
        textPainter.paint(canvas, Offset(goal.xPos, goal.yPos));
      }
    }
  }

  @override
  bool shouldRepaint(MindMapPainter oldDelegate) {
    return oldDelegate.goals != goals;
  }
}
