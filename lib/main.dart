import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';
import 'package:redux_training/redux/middleware.dart';
import 'package:redux_training/redux/reducer.dart';
import 'package:redux_training/view_models.dart';
import 'package:redux_training/widgets/add_goal_widget.dart';
import 'package:redux_training/widgets/goal_list_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Goals app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreBuilder(
            onInit: (store) => store.dispatch(GetGoalsAction()),
            builder: (BuildContext context, Store<AppState> store) {
              return MyHomePage(
                store: store,
              );
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.store}) : super(key: key);

  final DevToolsStore<AppState> store;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print('_MyHomePageState.build');
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO Redux"),
      ),
      body: StoreConnector<AppState, GoalViewModel>(
        converter: (Store<AppState> store) => GoalViewModel.create(store),
        builder: (BuildContext context, GoalViewModel goalViewModel) {
          return Column(
            children: <Widget>[
              AddGoalWidget(goalViewModel),
              Expanded(child: GoalListWidget(goalViewModel)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create new goal',
        child: Icon(Icons.add),
      ), // This
      drawer: Container(
        child: ReduxDevTools(widget.store),
      ), // trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
