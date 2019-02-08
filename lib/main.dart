import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';
import 'package:redux_training/redux/middleware.dart';
import 'package:redux_training/redux/reducer.dart';
import 'package:redux_training/screens/home_screen.dart';

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
        theme: ThemeData.dark(),
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
