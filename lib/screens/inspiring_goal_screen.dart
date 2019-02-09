import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/main.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/screens/taks_screen.dart';
import 'package:redux_training/view_models/view_models.dart';
import 'package:redux_training/widgets/add_what.dart';
import 'package:redux_training/widgets/add_why.dart';
import 'package:redux_training/widgets/goal_card_home_screen.dart';
import 'package:redux_training/widgets/goal_image_picker.dart';

class InspiringGoalScreen extends StatefulWidget {
  final String goalUuid;
  final String goalTitle;

  InspiringGoalScreen({@required this.goalUuid, @required this.goalTitle});

  @override
  _InspiringGoalScreenState createState() => _InspiringGoalScreenState();
}

class _InspiringGoalScreenState extends State<InspiringGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          var goal = goalViewModel.goals.firstWhere(
              (Goal g) => g.uuid == widget.goalUuid,
              orElse: () => null);
          if (goal == null) {
            Navigator.pop(context);
            return Scaffold();
          }

          // TODO use bfs to fetch parents recursively
          var parentsRecursively = goal.parentGoalsUuids
              .map((String uuid) => goalViewModel.goals
                  .firstWhere((Goal g) => g.uuid == uuid, orElse: () => null))
              .where((Goal g) => g != null)
              .toList()
              .reversed
              .toList();

          var childrenGoals = goal.childGoalsUuids
              .map((String childrenUuid) => goalViewModel.goals.firstWhere(
                    (Goal g) => g.uuid == childrenUuid,
                    orElse: () => null,
                  ))
              .where((Goal g) => g != null)
              .toList()
              .reversed
              .toList();

//          goal.childGoalsUuids.forEach((String childUuid) {
//            var childGoal = goalViewModel.goals.firstWhere(
//                (Goal g) => g.uuid == childUuid,
//                orElse: () => null);
//            if (childGoal == null) {
//              print(childUuid);
//            } else {
//              childrenGoals.add(childGoal);
//            }
//          });

          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: 250,
                  floating: false,
//                  pinned: true,
                  flexibleSpace: Dismissible(
                    key: UniqueKey(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GoalImagePicker(
                        goalViewModel: goalViewModel,
                        goalUuid: widget.goalUuid,
                      ),
                    ),
                  ),
                ),
//                SliverToBoxAdapter(
//                  child: GoalImagePicker(
//                    goalViewModel: goalViewModel,
//                    goalUuid: widget.goalUuid,
//                  ),
//                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                      left: 8,
                      right: 8,
                    ),
                    child: Card(
                      elevation: kCardElevation,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          initialValue: goal.title,
                          onSaved: (newTitle) {
                            goalViewModel.onGoalTitleChanged(
                                widget.goalUuid, newTitle);
                          },
                          onFieldSubmitted: (newTitle) {
                            goalViewModel.onGoalTitleChanged(
                                widget.goalUuid, newTitle);
                          },
                          decoration: new InputDecoration.collapsed(
                            hintText: 'I want to...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AddWhy(goalUuid: widget.goalUuid),
                ),
                SliverToBoxAdapter(
                  child: parentsRecursively.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            height: 320.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: parentsRecursively.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 320.0,
                                  child: GoalCardHomeScreen(
                                    dismissable: false,
                                    goal: parentsRecursively[index],
                                    deleteGoal: () {
                                      goalViewModel.onRemoveGoal(
                                          parentsRecursively[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AddWhat(goalUuid: widget.goalUuid),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var childGoal = childrenGoals[index];
                    return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TaskList(
                                  goalUuid: childGoal.uuid,
                                );
                              },
                            ),
                          );
                        },
                        title: Text(childGoal.title),
                        leading: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            goalViewModel.onRemoveGoal(childGoal);
                          },
                        ),
                        trailing: Checkbox(
                            value: childGoal.isCompleted,
                            onChanged: (_) {
                              goalViewModel.onCompleted(childGoal);
                            }));
                  }, childCount: childrenGoals.length),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 200)),
              ],
            ),
          );
        });
  }
}
