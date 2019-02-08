import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/main.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';
import 'package:redux_training/widgets/goal_image_picker.dart';

class CreateGoalScreen extends StatefulWidget {
  final String goalUuid;

  CreateGoalScreen({
    @required this.goalUuid,
  });

  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  var textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('_CreateGoalScreenState.build');
    return StoreConnector<AppState, GoalViewModel>(
      converter: (Store<AppState> store) => GoalViewModel.create(store),
      builder: (BuildContext context, GoalViewModel goalViewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Create goal"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: <Widget>[
                // TITLE
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Card(
                    elevation: kCardElevation,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: new TextField(
                        onSubmitted: (String newTitle) {
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
                // CHOOSE IMAGE
                GoalImagePicker(
                  goalUuid: widget.goalUuid,
                  goalViewModel: goalViewModel,
                ),
                // WHY SECTION
                // WHAT SECTION
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
