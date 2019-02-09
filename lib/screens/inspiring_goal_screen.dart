import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/main.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';
import 'package:redux_training/widgets/add_why.dart';
import 'package:redux_training/widgets/goal_image_picker.dart';

class InspiringGoalScreen extends StatefulWidget {
  final String goalUuid;
  final String goalTitle;

  InspiringGoalScreen({@required this.goalUuid, @required this.goalTitle});

  @override
  _InspiringGoalScreenState createState() => _InspiringGoalScreenState();
}

class _InspiringGoalScreenState extends State<InspiringGoalScreen> {
  var textEditingController;
  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController(text: widget.goalTitle);

    return StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          var goal = goalViewModel.goals
              .firstWhere((Goal g) => g.uuid == widget.goalUuid);
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
                        child: new TextField(
                          onSubmitted: (String newTitle) {
                            goalViewModel.onGoalTitleChanged(
                                widget.goalUuid, newTitle);
                          },
                          onChanged: (String newTitle) {
                            goalViewModel.onGoalTitleChanged(
                                widget.goalUuid, newTitle);
                          },
                          controller: textEditingController,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      height: 240.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 320.0,
                            child: Card(
                              color: Colors.orange,
                              child: Text('data'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("What"),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return GestureDetector(
                      child: Text("$index"),
                      onTap: () {},
                    );
                  }),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }
}
