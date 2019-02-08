import 'package:redux/redux.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/redux/actions.dart';

class GoalViewModel {
  final List<Goal> goals;
  final Function(String) onAddGoal;
  final Function(Goal) onCompleted;
  final Function(Goal) onRemoveGoal;

  GoalViewModel({
    this.goals,
    this.onAddGoal,
    this.onCompleted,
    this.onRemoveGoal,
  });

  factory GoalViewModel.create(Store<AppState> store) {
    _onAddGoal(String newGoalTitle) {
      store.dispatch(AddGoalAction(newGoalTitle));
    }

    _onRemoveGoal(Goal goal) {
      store.dispatch(RemoveGoalAction(goal));
    }

    _onCompleted(Goal goal) {
      store.dispatch(GoalCompletedAction(goal));
    }

    return GoalViewModel(
      goals: store.state.goals,
      onAddGoal: _onAddGoal,
      onCompleted: _onCompleted,
      onRemoveGoal: _onRemoveGoal,
    );
  }
}
