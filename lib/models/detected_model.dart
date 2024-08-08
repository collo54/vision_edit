import 'package:flutter/material.dart';

class DetectedModel {
  /// Tracking ID of object. If tracking is disabled it is null.
  final int? trackingId;

  /// Rect that contains the detected object.
  /// Rect myRect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);
  final RectModel boundingBox;

  /// List of [Label], identified for the object.
  final List<LabelModel> labels;

  /// Constructor to create an instance of [DetectedObject].
  DetectedModel({
    required this.boundingBox,
    required this.labels,
    required this.trackingId,
  });
}

class RectModel {
  final Offset offset;
  final Size size;

  RectModel({
    required this.offset,
    required this.size,
  });
}

class LabelModel {
  final double confidence;

  /// Gets the index of this label.
  final int index;

  /// Gets the text of this label.
  final String text;

  LabelModel({
    required this.confidence,
    required this.index,
    required this.text,
  });
}
