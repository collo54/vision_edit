import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/services/image_conversion_service.dart';


final imageConversionServiceProvider = Provider((ref) {
  return ImageConversionService();
});
