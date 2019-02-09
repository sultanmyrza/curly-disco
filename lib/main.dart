import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';
import 'package:redux_training/redux/middleware.dart';
import 'package:redux_training/redux/reducer.dart';
import 'package:redux_training/screens/home_screen.dart';
import 'package:redux_training/screens/login_screen.dart';

void main() => runApp(StarterScreen());

var kCardElevation = 1.0;
var kDarkTheme = ThemeData.dark();
var kLightTheme = ThemeData.light();

class StarterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData && snapshot.data.email != null) {
            var userPath = snapshot.data.email;

            return MyApp();
//            return StreamBuilder(
//                stream: Firestore.instance.collection(userPath).snapshots(),
//                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                  if (snapshot.hasData) {
//                    return BlocProvider(
//                      uuid: Uuid(),
//                      goalsBloc: GoalsBloc(
//                          userPath: userPath,
//                          initialDataFromFirebase: snapshot.data.documents),
//                      child: HomeScreen(),
//                    );
//                  } else {
//                    return Text("Fettching data from firebase");
//                  }
//                });
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

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
        theme: kLightTheme,
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
