import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';

class CreateGoalScreen extends StatefulWidget {
  String goalUuid;

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
          body: ListView(
            children: <Widget>[
              // TITLE
              Container(
                padding: EdgeInsets.all(16),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: new TextField(
                      onSubmitted: (String newTitle) {
                        print(newTitle);
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
              Card(),
              // WHY SECTION
              // WHAT SECTION
            ],
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
