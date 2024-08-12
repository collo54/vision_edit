import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'document_path.dart';

var uuid = const Uuid();

class FirebaseStorageService {
  FirebaseStorageService({required this.uid});
  final String uid;

  /// Upload image bytes to firebase storage
  Future<String> uploadImageBytes({
    required Uint8List data,
  }) async =>
      await upload(
        data: data,
        path: '${DocumentPath.newStorageFile(uuid.v1())}.jpeg',
        contentType: 'image/jpeg',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    required Uint8List data,
    required String path,
    required String contentType,
  }) async {
    if (kDebugMode) {
      print('uploading to: $path');
    }
    final firebase = FirebaseStorage.instance;
    final reference = firebase.ref().child(path);
    final uploadTask =
        reference.putData(data, SettableMetadata(contentType: contentType));
    final snapshot = await uploadTask.whenComplete(() {});

    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print('downloadUrl: $downloadUrl');
    }
    return downloadUrl;
  }
}
