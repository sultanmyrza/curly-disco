import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';

class GoalViewModel {
  final List<Goal> goals;
  final Function(String, String) onAddGoal;
  final Function(Goal) onCompleted;
  final Function(Goal) onRemoveGoal;
  final Function(
    String,
    String,
  ) onGoalTitleChanged;
  final Function(
    String,
    String,
  ) onGoalUpdatePhotoLocalPathIOS;
  final Function(
    String,
    String,
    bool,
  ) connectParent;
  final Function(
    String,
    String,
    bool,
  ) connectChild;

  GoalViewModel({
    this.goals,
    this.onAddGoal,
    this.onCompleted,
    this.onRemoveGoal,
    this.onGoalTitleChanged,
    this.onGoalUpdatePhotoLocalPathIOS,
    this.connectParent,
    this.connectChild,
  });

  factory GoalViewModel.create(Store<AppState> store) {
    _onAddGoal(String newGoalUuid, String newGoalTitle) {
      store.dispatch(
          AddGoalAction(newGoalUuid: newGoalUuid, newGoalTitle: newGoalTitle));
    }

    _onRemoveGoal(Goal goal) {
      store.dispatch(RemoveGoalAction(goal));
    }

    _onCompleted(Goal goal) {
      store.dispatch(GoalCompletedAction(goal));
    }

    _onGoalTitleChanged(String goalUuid, String newTitle) {
      store.dispatch(GoalChangeTitleAction(
        goalUuid: goalUuid,
        newTitle: newTitle,
      ));
    }

    _onGoalUpdatePhotoLocalPathIOS(String goalUuid, String photoLocalPathIOS) {
      store.dispatch(GoalUpdatePhotoLocalPathIOSAction(
        goalUuid: goalUuid,
        photoLocalPathIOS: photoLocalPathIOS,
      ));
    }

    _connectParent(String goalUuid, String parentUuid, bool connect) {
      return store.dispatch(
        ConnectParentAction(
          goalUuid: goalUuid,
          parentGoalUuid: parentUuid,
          connect: connect,
        ),
      );
    }

    _connectChild(String goalUuid, String connectChild, bool connect) {
      return store.dispatch(
        ConnectChildAction(
          goalUuid: goalUuid,
          childGoalUuid: connectChild,
          connect: connect,
        ),
      );
    }

    return GoalViewModel(
      goals: store.state.goals,
      onAddGoal: _onAddGoal,
      onCompleted: _onCompleted,
      onRemoveGoal: _onRemoveGoal,
      onGoalTitleChanged: _onGoalTitleChanged,
      onGoalUpdatePhotoLocalPathIOS: _onGoalUpdatePhotoLocalPathIOS,
      connectParent: _connectParent,
      connectChild: _connectChild,
    );
  }
}
