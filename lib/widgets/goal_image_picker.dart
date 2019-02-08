import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux_training/main.dart';
import 'package:redux_training/models/model.dart';
import 'package:redux_training/view_models/view_models.dart';

class GoalImagePicker extends StatelessWidget {
  final GoalViewModel goalViewModel;
  final String goalUuid;

  GoalImagePicker({
    @required this.goalViewModel,
    @required this.goalUuid,
  });

  @override
  Widget build(BuildContext context) {
    print('GoalImagePicker.build');
    var goal = goalViewModel.goals.firstWhere((Goal g) => g.uuid == goalUuid);

    Widget image;

    // TODO implement
    if (Platform.isAndroid) {
      try {} catch (e) {}
    } else if (Platform.isIOS) {
      try {
        var file = File(goal.photoLocalPathIOS);
        image = Image.file(
          file,
          fit: BoxFit.cover,
        );
      } catch (e) {}
    }

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection disDir) async {
        // TODO add ability to get images from camera
//        if (disDir == DismissDirection.startToEnd) {
//          uploadFromCamera()
//        } else {
//          uploadFromGallery();
//        }

        var file = await ImagePicker.pickImage(source: ImageSource.gallery);
        // TODO: implement for android specific version (action,reducer, path)
        var photoLocalPathIOS = file.path;
        goalViewModel.onGoalUpdatePhotoLocalPathIOS(
            goal.uuid, photoLocalPathIOS);

        // TODO: implement upload to firebase with preferredName
        String preferredFileNameForCloud = file.path.split("/").last;
        preferredFileNameForCloud =
            "FROM_GALLERY___" + preferredFileNameForCloud;
      },
      child: Container(
        height: 320,
        width: double.infinity,
        child: Card(
          elevation: kCardElevation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: image != null ? image : Text("swipe to set image"),
          ),
        ),
      ),
      background: Icon(Icons.image),
    );
  }
}
