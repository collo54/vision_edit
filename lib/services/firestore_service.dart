import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vision_edit/models/display_data_model.dart';

import 'document_path.dart';

//String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;

  // generic funtion creates a dcomcument and sets data in the document
  Future<void> _set({required String path, Map<String, dynamic>? data}) async {
    final DocumentReference<Map<String, dynamic>?> reference =
        FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('$path: $data');
    }
    await reference.set(data);
  }

  //creates or writes a displaydatamodel for users collection per user id
  Future<void> setDisplayDataModel(DisplayDataModel dataModel) async {
    await _set(
      path: DocumentPath.newResponse(uid, dataModel.id),
      data: dataModel.toJson(),
    );
  }

  //reads a displaydatamodel for users collection per user id
  Stream<List<DisplayDataModel>> displayDataModelStream() {
    final path = DocumentPath.streamResponse(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            DisplayDataModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from users geminiResponse collection/uid/docid
  Future<void> deleteDisplayDataModel(DisplayDataModel dataModel) async {
    final path = DocumentPath.newResponse(uid, dataModel.id);
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }
    await reference.delete();
  }

  //creates or writes a product for apliances collection per user id
  Future<void> setLocation(DisplayDataModel dataModel) async {
    await _set(
      path: DocumentPath.newLocation(dataModel.id),
      data: dataModel.toJson(),
    );
  }

  //reads a latlang from Locations collection
  Stream<List<DisplayDataModel>> locationsStream() {
    final path = DocumentPath.streamLocation();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            DisplayDataModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from aplliances collection
  Future<void> deleteLocation(DisplayDataModel dataModel) async {
    final path = DocumentPath.newLocation(dataModel.id);
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }
    await reference.delete();
  }
}
