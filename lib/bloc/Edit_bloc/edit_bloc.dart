import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(EditInitial());

  File _image;
  String userName, fullName, bio, imageLink = '', userNameError;
  bool spinner=false;
  final picker = ImagePicker();

  @override
  Stream<EditState> mapEventToState(
    EditEvent event,
  ) async* {
     if (event is DownloadImageEvent) {
         await downloadImage();
      yield DownloadImageState();
    } else if (event is GetNameEvent) {
       await getName();
      yield GetNameState();
    }  else if (event is UpdateUserDetailEvent) {
      updateUserDetail();
      yield UpdateUserDetailState();
    } else if (event is GetImageEvent) {
       yield Spinner(spinner: spinner=true);

       await getImage();
       await updateUserImage();
      await downloadImage();
       yield Spinner(spinner: spinner=false);

       yield GetImageState();
    } else if (event is SignOutEvent) {
      await signOut();
      yield SignOutState();
    } else if (event is ChangeNameEvent) {
      yield ChangeNameState(name: fullName = event.name);
    } else if (event is ChangeBioEvent) {
      yield ChangeBioState(bio: bio = event.bio);
    } else if (event is ChangeUserNameEvent) {
      yield ChangeUserNameState(userName: userName = event.userName.trim());
    } else if (event is CheckUserEvent) {
      final userCheck = await usernameCheck(event.userName.trim());
      if (!userCheck) {
        yield CheckUserState(
            error: userNameError = 'This User is Already exists');
      }
    } else if (event is SecondCheckUserEvent) {
      yield CheckUserState(error: userNameError = null);
    }
  }

  Future<void> updateUserImage() async {
    if (_image != null) {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child('${FirebaseAuth.instance.currentUser.email}.jpg');
      final StorageUploadTask task = ref.putFile(_image);
      var imageUrl = await (await task.onComplete).ref.getDownloadURL();

      FirebaseAuth.instance.currentUser.updateProfile(photoURL: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .update(
        {"userImage": imageUrl},
      ).catchError((onError) {
      });
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      if(temp.length>=3)
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  Future<void> updateUserDetail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'Name': fullName.trim(),
      'bio': bio.trim(),
      'User': userName.trim(),
      'caseSearch':setSearchParam(userName.trim()),


    });
  }

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);


    if (pickedFile != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1,
              ratioY: 1,
          ),
          compressQuality: 100,
          maxHeight: 130,
          maxWidth: 130,
          cropStyle: CropStyle.circle,
          compressFormat:ImageCompressFormat.jpg,

      );

      _image = cropped;
    }
    else{
    }
  }

  Future<void> downloadImage() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                imageLink = doc.data()['userImage'].toString().isEmpty
                    ? null
                    : doc.data()['userImage'];
              })
            });
  }

  Future<void> getName() async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      fullName = value.data()['Name'];
      bio = value.data()['bio'];
      userName = value.data()['User'];
    });
  }

  Future<void> signOut()async {
    FirebaseAuth.instance.signOut();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'mobileToken':''


    });
  }

  Future<bool> usernameCheck(String username) async {
    final _fireStore = FirebaseFirestore.instance;

    final result = await _fireStore
        .collection('users')
        .where('User', isEqualTo: username)
        .get();

    return result.docs.isEmpty;
  }
}
