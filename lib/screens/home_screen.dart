import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models.dart';
import 'package:redux_training/widgets/add_goal_widget.dart';
import 'package:redux_training/widgets/goal_list_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.store}) : super(key: key);

  final DevToolsStore<AppState> store;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var pageController = PageController(initialPage: 0);
    print('_MyHomePageState.build');
    return Scaffold(
      body: StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          return PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              new HomeGoalsList(
                goalViewModel: goalViewModel,
              ),
              new HomeTaskList(
                goalViewModel: goalViewModel,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, icon: Icon(Icons.add), label: Text("Create new")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 32, bottom: 8),
              child: IconButton(
                icon: Icon(
                  Icons.golf_course,
                  size: 32,
                ),
                onPressed: () {
                  pageController.animateToPage(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 32, bottom: 8),
              child: IconButton(
                icon: Icon(
                  Icons.format_list_numbered,
                  size: 32,
                ),
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
            )
          ],
        ),
      ),
      drawer: Container(
        child: ReduxDevTools(widget.store),
      ), // trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomeTaskList extends StatelessWidget {
  final GoalViewModel goalViewModel;
  const HomeTaskList({
    Key key,
    @required this.goalViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoalListWidget(goalViewModel);
  }
}

class HomeGoalsList extends StatelessWidget {
  final GoalViewModel goalViewModel;
  const HomeGoalsList({
    Key key,
    @required this.goalViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AddGoalWidget(goalViewModel),
        Expanded(child: GoalListWidget(goalViewModel)),
      ],
    );
  }
}
