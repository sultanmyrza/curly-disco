import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';
import 'package:uuid/uuid.dart';

class AddWhat extends StatelessWidget {
  final goalUuid;

  const AddWhat({
    Key key,
    @required this.goalUuid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "What...",
                style: TextStyle(fontSize: 32),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ConnectChildSearchDelegate(
                      goalUuid: goalUuid,
                      goalViewModel: goalViewModel,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class ConnectChildSearchDelegate extends SearchDelegate<String> {
  final String goalUuid;
  GoalViewModel goalViewModel;

  ConnectChildSearchDelegate({
    this.goalUuid,
    this.goalViewModel,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Navigator.pop(context);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var goals = goalViewModel.goals;
    var goal = goals.firstWhere((Goal g) => g.uuid == goalUuid);

    var connectableGoals = goals.where((Goal g) {
      if (goal.parentGoalsUuids.contains(g.uuid) ||
          goal.childGoalsUuids.contains(g.uuid)) {
        return false;
      } else {
        return true;
      }
    }).toList();

    var suggestions = query.length == 0
        ? connectableGoals
        : connectableGoals.where((Goal g) => g.title.startsWith(query));

    var suggestionList = suggestions.map((Goal g) {
      return ListTile(
        leading: Icon(Icons.golf_course),
        title: RichText(
          text: TextSpan(
            text: g.title.substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: g.title.substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        trailing: Text("connect"),
        onTap: () {
          goalViewModel.connectChild(goalUuid, g.uuid, true);
          close(context, null);
        },
      );
    }).toList();

    var createNewSuggestion = ListTile(
      leading: Icon(Icons.golf_course),
      title: Text(query),
      trailing: Text("CREATE NEW"),
      onTap: () {
        var newGoalUuid = Uuid().v1();
        var newGoalTitle = query;
        goalViewModel.onAddGoal(newGoalUuid, newGoalTitle);
        goalViewModel.connectChild(goal.uuid, newGoalUuid, true);
        close(context, null);
      },
    );

    suggestionList.add(createNewSuggestion);

    return ListView(
      children: suggestionList,
    );
  }
}
